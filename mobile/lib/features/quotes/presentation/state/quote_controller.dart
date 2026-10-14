import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/network/quote_http_client.dart';
import 'package:gym_tracker/core/providers.dart';
import 'package:gym_tracker/features/quotes/data/quote_cache_store.dart';
import 'package:gym_tracker/features/quotes/data/sources/anime_chan_source.dart';
import 'package:gym_tracker/features/quotes/domain/quote.dart';
import 'package:gym_tracker/features/quotes/domain/quote_cache.dart';
import 'package:gym_tracker/features/quotes/domain/quote_pool.dart';
import 'package:gym_tracker/features/quotes/domain/quote_queue.dart';
import 'package:gym_tracker/features/quotes/domain/quote_refresher.dart';
import 'package:gym_tracker/features/quotes/domain/quote_source.dart';
import 'package:gym_tracker/features/settings/settings.dart';

/// Loaded once at startup so a quote is on screen on the first frame.
final bundledQuotesProvider = Provider<List<Quote>>((ref) => const []);

final quoteSourcesProvider = Provider<List<QuoteSource>>((ref) {
  if (!ref.watch(appConfigProvider).isOnlineQuotesEnabled) {
    return const [];
  }
  return [AnimeChanSource(QuoteHttpClient.create())];
});

final quoteCacheRepositoryProvider = Provider<QuoteCacheRepository>(
  (ref) => QuoteCacheStore(ref.watch(fileGatewayProvider)),
);

final quoteRefresherProvider = Provider<QuoteRefresher>(
  (ref) => QuoteRefresher(
    sources: ref.watch(quoteSourcesProvider),
    cacheRepository: ref.watch(quoteCacheRepositoryProvider),
  ),
);

final quoteRandomProvider = Provider<Random>((ref) => Random());

class QuoteCardState {
  const new({this.quote, this.isFetching = false, this.isHidden = false});

  final Quote? quote;
  final bool isFetching;
  final bool isHidden;
}

class QuoteController extends Notifier<QuoteCardState> {
  static const Duration liveFetchTimeout = QuoteHttpClient.timeout;

  late QuoteQueue _queue;
  QuoteCache _cache = const QuoteCache();
  bool _isLoaded = false;

  QuoteMode get _mode => ref.read(settingsControllerProvider).quoteMode;

  List<Quote> get _pool => QuotePool.forMode(
    _mode,
    bundled: ref.read(bundledQuotesProvider),
    cached: _cache.quotes,
  );

  @override
  QuoteCardState build() {
    final mode = ref.watch(
      settingsControllerProvider.select((settings) => settings.quoteMode),
    );
    _queue = QuoteQueue(ref.read(quoteRandomProvider));
    if (mode == QuoteMode.off) {
      return const QuoteCardState(isHidden: true);
    }
    if (!_isLoaded) {
      unawaited(_loadCacheAndRefresh());
    }
    return QuoteCardState(quote: _queue.next(_pool));
  }

  Future<void> _loadCacheAndRefresh() async {
    _cache = await ref.read(quoteCacheRepositoryProvider).load();
    _isLoaded = true;
    final refresher = ref.read(quoteRefresherProvider);
    final now = ref.read(clockProvider).now();
    if (QuotePool.usesOnlineSources(_mode) &&
        refresher.isBackgroundRefreshDue(_cache, now)) {
      _cache = (await refresher.refresh(_cache, now, isBackground: true)).cache;
    }
  }

  /// Instant swap when an unseen quote is ready; otherwise a live fetch of
  /// at most five seconds, falling back silently to what is available.
  Future<void> showNext() async {
    if (state.isFetching || state.isHidden) {
      return;
    }
    final online = [
      for (final quote in _pool)
        if (quote.fetchedAt != null) quote,
    ];
    final refresher = ref.read(quoteRefresherProvider);
    final now = ref.read(clockProvider).now();
    final shouldFetch =
        QuotePool.usesOnlineSources(_mode) &&
        !_queue.hasUnseen(online) &&
        refresher.canFetchNow(_cache, now);
    if (!shouldFetch) {
      state = QuoteCardState(quote: _queue.next(_pool) ?? state.quote);
      return;
    }
    state = QuoteCardState(quote: state.quote, isFetching: true);
    final fetched = await _fetchLive(refresher, now);
    if (!ref.mounted) {
      return;
    }
    final fresh = fetched.where(
      (quote) => !_queue.recentIds.contains(quote.id),
    );
    state = QuoteCardState(
      quote: fresh.isNotEmpty ? fresh.first : _queue.next(_pool) ?? state.quote,
    );
  }

  Future<List<Quote>> _fetchLive(QuoteRefresher refresher, DateTime now) async {
    try {
      final outcome = await refresher
          .refresh(_cache, now, isBackground: false)
          .timeout(liveFetchTimeout);
      _cache = outcome.cache;
      return outcome.fetched;
    } on TimeoutException {
      return const [];
    }
  }
}

final quoteControllerProvider =
    NotifierProvider<QuoteController, QuoteCardState>(QuoteController.new);
