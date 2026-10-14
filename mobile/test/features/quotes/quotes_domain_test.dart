import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/core/failure/failure.dart';
import 'package:gym_tracker/core/failure/result.dart';
import 'package:gym_tracker/core/network/quote_http_client.dart';
import 'package:gym_tracker/features/quotes/data/quote_cache_store.dart';
import 'package:gym_tracker/features/quotes/data/sources/anime_chan_source.dart';
import 'package:gym_tracker/features/quotes/domain/quote.dart';
import 'package:gym_tracker/features/quotes/domain/quote_cache.dart';
import 'package:gym_tracker/features/quotes/domain/quote_pool.dart';
import 'package:gym_tracker/features/quotes/domain/quote_queue.dart';
import 'package:gym_tracker/features/quotes/domain/quote_refresher.dart';
import 'package:gym_tracker/features/quotes/domain/quote_source.dart';
import 'package:gym_tracker/features/quotes/domain/quote_validator.dart';
import 'package:gym_tracker/features/quotes/domain/rate_budget.dart';
import 'package:gym_tracker/features/settings/settings_domain.dart';

import '../../fakes/memory_file_gateway.dart';

final _now = DateTime.utc(2026, 10, 14, 9);

Quote _quote(
  String id, {
  QuoteCategory category = QuoteCategory.gym,
  DateTime? fetchedAt,
}) => Quote(
  id: id,
  text: 'Quote $id',
  category: category,
  provider: category == QuoteCategory.gym ? 'bundled' : 'animechan',
  fetchedAt: fetchedAt,
);

class _FakeSource implements QuoteSource {
  new(this.results);

  final List<Result<List<Quote>>> results;
  int calls = 0;

  @override
  String get id => 'fake';

  @override
  QuoteCategory get category => QuoteCategory.anime;

  @override
  int get maxRequestsPerHour => 3;

  @override
  Future<Result<List<Quote>>> fetch(DateTime now) async =>
      results[calls++ % results.length];
}

class _MemoryCacheRepository implements QuoteCacheRepository {
  QuoteCache? saved;

  @override
  Future<QuoteCache> load() async => saved ?? const QuoteCache();

  @override
  Future<void> save(QuoteCache cache) async => saved = cache;

  @override
  Future<void> clear() async => saved = null;
}

/// Replays a recorded response; CI never calls live APIs.
class _RecordedAdapter implements HttpClientAdapter {
  new(this.statusCode, this.body);

  final int statusCode;
  final String body;
  RequestOptions? lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    return ResponseBody.fromString(
      body,
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  group('RateBudget', () {
    test('allows up to the limit per rolling hour', () {
      var budget = const RateBudget();
      for (var i = 0; i < 3; i++) {
        expect(budget.canRequest(_now, maxPerWindow: 3), isTrue);
        budget = budget.recordRequest(_now);
      }
      expect(budget.canRequest(_now, maxPerWindow: 3), isFalse);
      final later = _now.add(RateBudget.window);
      expect(budget.canRequest(later, maxPerWindow: 3), isTrue);
    });

    test('a 429 blocks for an hour', () {
      final budget = const RateBudget().recordFailure(
        _now,
        isRateLimited: true,
      );
      final almost = _now.add(const Duration(minutes: 59));
      expect(budget.canRequest(almost, maxPerWindow: 3), isFalse);
      final after = _now.add(RateBudget.backoff);
      expect(budget.canRequest(after, maxPerWindow: 3), isTrue);
    });

    test('three consecutive errors back off; a success resets', () {
      var budget = const RateBudget()
          .recordFailure(_now, isRateLimited: false)
          .recordFailure(_now, isRateLimited: false);
      expect(budget.canRequest(_now, maxPerWindow: 3), isTrue);
      expect(
        budget.recordSuccess().recordFailure(_now, isRateLimited: false),
        isA<RateBudget>().having((b) => b.consecutiveErrors, 'errors', 1),
      );
      budget = budget.recordFailure(_now, isRateLimited: false);
      expect(budget.canRequest(_now, maxPerWindow: 3), isFalse);
    });
  });

  group('QuoteCache', () {
    test('dedupes by id and drops quotes older than 30 days', () {
      final old = _now.subtract(const Duration(days: 31));
      final cache = const QuoteCache().withFetched([
        _quote('a', fetchedAt: _now),
        _quote('a', fetchedAt: _now),
        _quote('b', fetchedAt: old),
      ], _now);
      expect(cache.quotes.map((q) => q.id), ['a']);
    });

    test('keeps only the newest 100', () {
      final fetched = [
        for (var i = 0; i < 120; i++)
          _quote('$i', fetchedAt: _now.subtract(Duration(minutes: i))),
      ];
      final cache = const QuoteCache().withFetched(fetched, _now);
      expect(cache.quotes, hasLength(QuoteCache.maxEntries));
      expect(cache.quotes.first.id, '0');
      expect(cache.quotes.last.id, '99');
    });
  });

  group('QuoteQueue', () {
    test('never repeats any of the last five', () {
      final pool = [for (var i = 0; i < 8; i++) _quote('$i')];
      final queue = QuoteQueue(Random(7));
      final shown = <String>[];
      for (var i = 0; i < 200; i++) {
        final id = queue.next(pool)!.id;
        final recent = shown.length < 5
            ? shown
            : shown.sublist(shown.length - 5);
        expect(recent, isNot(contains(id)));
        shown.add(id);
      }
    });

    test('a small pool still rotates without immediate repeats', () {
      final pool = [_quote('a'), _quote('b')];
      final queue = QuoteQueue(Random(1));
      var previous = queue.next(pool)!.id;
      for (var i = 0; i < 20; i++) {
        final id = queue.next(pool)!.id;
        expect(id, isNot(previous));
        previous = id;
      }
    });

    test('an empty pool gives nothing', () {
      expect(QuoteQueue(Random(1)).next(const []), isNull);
    });
  });

  group('QuotePool', () {
    final bundled = [_quote('g')];
    final cached = [_quote('x', category: QuoteCategory.anime)];

    test('picks quotes per mode', () {
      List<String> ids(QuoteMode mode, List<Quote> fromCache) => [
        for (final quote in QuotePool.forMode(
          mode,
          bundled: bundled,
          cached: fromCache,
        ))
          quote.id,
      ];
      expect(ids(QuoteMode.gym, cached), ['g']);
      expect(ids(QuoteMode.anime, cached), ['x']);
      expect(ids(QuoteMode.anime, const []), ['g']);
      expect(ids(QuoteMode.mix, cached), ['g', 'x']);
      expect(ids(QuoteMode.off, cached), isEmpty);
    });

    test('only anime and mix go online', () {
      expect(QuotePool.usesOnlineSources(QuoteMode.gym), isFalse);
      expect(QuotePool.usesOnlineSources(QuoteMode.off), isFalse);
      expect(QuotePool.usesOnlineSources(QuoteMode.mix), isTrue);
    });
  });

  group('QuoteValidator', () {
    Quote? validate(String text, {String? author}) => QuoteValidator.validate(
      text: text,
      author: author,
      category: QuoteCategory.anime,
      provider: 'test',
      fetchedAt: _now,
    );

    test('strips tags and collapses whitespace', () {
      expect(validate('  Keep <b>going</b>\n now ')!.text, 'Keep going now');
    });

    test('rejects empty, over-long and profane quotes', () {
      expect(validate('   '), isNull);
      expect(validate('a' * (QuoteValidator.maxLength + 1)), isNull);
      expect(validate('What the shit'), isNull);
      expect(validate('Fine words', author: 'Bitch'), isNull);
    });

    test('ids ignore case and punctuation', () {
      expect(
        QuoteValidator.idFor('Never give up!'),
        QuoteValidator.idFor('never   give up'),
      );
    });
  });

  group('QuoteRefresher', () {
    test('caches fetched quotes and saves the budget', () async {
      final source = _FakeSource([
        Ok([_quote('n', category: QuoteCategory.anime, fetchedAt: _now)]),
      ]);
      final repository = _MemoryCacheRepository();
      final refresher = QuoteRefresher(
        sources: [source],
        cacheRepository: repository,
      );
      final outcome = await refresher.refresh(
        const QuoteCache(),
        _now,
        isBackground: true,
      );
      expect(outcome.fetched.map((q) => q.id), ['n']);
      expect(repository.saved!.quotes.map((q) => q.id), ['n']);
      expect(repository.saved!.lastBackgroundRefresh, _now);
      expect(repository.saved!.budgetFor('fake').recentRequests, [_now]);
    });

    test('stops calling a source once its budget is spent', () async {
      final source = _FakeSource([const Ok([])]);
      final refresher = QuoteRefresher(
        sources: [source],
        cacheRepository: _MemoryCacheRepository(),
      );
      var cache = const QuoteCache();
      for (var i = 0; i < 5; i++) {
        cache = (await refresher.refresh(
          cache,
          _now,
          isBackground: false,
        )).cache;
      }
      expect(source.calls, 3);
      expect(refresher.canFetchNow(cache, _now), isFalse);
    });

    test('a rate-limited failure is silent and blocks the source', () async {
      final source = _FakeSource([
        const Err(NetworkFailure('429', isRateLimited: true)),
      ]);
      final refresher = QuoteRefresher(
        sources: [source],
        cacheRepository: _MemoryCacheRepository(),
      );
      final outcome = await refresher.refresh(
        const QuoteCache(),
        _now,
        isBackground: false,
      );
      expect(outcome.fetched, isEmpty);
      expect(outcome.cache.budgetFor('fake').blockedUntil, isNotNull);
    });

    test('a background refresh is due once a day', () {
      final refresher = QuoteRefresher(
        sources: const [],
        cacheRepository: _MemoryCacheRepository(),
      );
      final cache = QuoteCache(lastBackgroundRefresh: _now);
      final soon = _now.add(const Duration(hours: 23));
      expect(refresher.isBackgroundRefreshDue(cache, soon), isFalse);
      final tomorrow = _now.add(const Duration(days: 1));
      expect(refresher.isBackgroundRefreshDue(cache, tomorrow), isTrue);
    });
  });

  group('AnimeChanSource (recorded fixture)', () {
    final fixture = File('test/fixtures/animechan_random.json')
        .readAsStringSync();

    AnimeChanSource sourceWith(_RecordedAdapter adapter) =>
        AnimeChanSource(QuoteHttpClient.create()..httpClientAdapter = adapter);

    test('parses quote, character and anime', () async {
      final adapter = _RecordedAdapter(200, fixture);
      final result = await sourceWith(adapter).fetch(_now);
      final quote = (result as Ok<List<Quote>>).value.single;
      expect(quote.text, "If you don't take risks, you can't create a future.");
      expect(quote.author, 'Monkey D. Luffy');
      expect(quote.sourceTitle, 'One Piece');
      expect(quote.category, QuoteCategory.anime);
      expect(quote.fetchedAt, _now);
      expect(adapter.lastRequest!.headers.keys, isNot(contains('cookie')));
    });

    test('a 429 becomes a rate-limited failure', () async {
      final adapter = _RecordedAdapter(429, '{"message":"Too many"}');
      final result = await sourceWith(adapter).fetch(_now);
      expect(
        (result as Err<List<Quote>>).failure,
        isA<NetworkFailure>().having((f) => f.isRateLimited, 'limited', true),
      );
    });

    test('an unexpected payload is a failure, not a crash', () async {
      final adapter = _RecordedAdapter(200, '{"status":"error"}');
      final result = await sourceWith(adapter).fetch(_now);
      expect(result, isA<Err<List<Quote>>>());
    });
  });

  group('QuoteCacheStore', () {
    test(
      'round-trips quotes and budgets, and clear removes the file',
      () async {
        final files = MemoryFileGateway();
        final store = QuoteCacheStore(files);
        final cache = const QuoteCache()
            .withFetched([
              _quote('a', category: QuoteCategory.anime, fetchedAt: _now),
            ], _now)
            .withBudget('animechan', const RateBudget().recordRequest(_now));
        await store.save(cache);
        final loaded = await store.load();
        expect(loaded.quotes.single.id, 'a');
        expect(loaded.budgetFor('animechan').recentRequests, hasLength(1));
        await store.clear();
        expect(files.text(QuoteCacheStore.fileName), isNull);
      },
    );

    test('a damaged file loads as an empty cache', () async {
      final files = MemoryFileGateway();
      files.files[QuoteCacheStore.fileName] = utf8.encode('{not json');
      expect((await QuoteCacheStore(files).load()).quotes, isEmpty);
    });
  });
}
