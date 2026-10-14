import 'package:gym_tracker/core/failure/failure.dart';
import 'package:gym_tracker/core/failure/result.dart';
import 'package:gym_tracker/features/quotes/domain/quote.dart';
import 'package:gym_tracker/features/quotes/domain/quote_cache.dart';
import 'package:gym_tracker/features/quotes/domain/quote_source.dart';

abstract interface class QuoteCacheRepository {
  Future<QuoteCache> load();

  Future<void> save(QuoteCache cache);

  Future<void> clear();
}

typedef RefreshOutcome = ({QuoteCache cache, List<Quote> fetched});

/// Fetches from online sources within their local budgets. Failures are
/// silent: they only update the budget (spec 6.2 rules 3 and 6).
class QuoteRefresher {
  const new({required this.sources, required this.cacheRepository});

  static const backgroundInterval = Duration(days: 1);

  final List<QuoteSource> sources;
  final QuoteCacheRepository cacheRepository;

  bool isBackgroundRefreshDue(QuoteCache cache, DateTime now) {
    final last = cache.lastBackgroundRefresh;
    return last == null || now.difference(last) >= backgroundInterval;
  }

  bool canFetchNow(QuoteCache cache, DateTime now) => sources.any(
    (source) => cache
        .budgetFor(source.id)
        .canRequest(now, maxPerWindow: source.maxRequestsPerHour),
  );

  Future<RefreshOutcome> refresh(
    QuoteCache cache,
    DateTime now, {
    required bool isBackground,
  }) async {
    var updated = cache.pruned(now);
    final fetched = <Quote>[];
    for (final source in sources) {
      final budget = updated.budgetFor(source.id);
      if (!budget.canRequest(now, maxPerWindow: source.maxRequestsPerHour)) {
        continue;
      }
      final requested = budget.recordRequest(now);
      final result = await source.fetch(now);
      switch (result) {
        case Ok(:final value):
          fetched.addAll(value);
          updated = updated
              .withFetched(value, now)
              .withBudget(source.id, requested.recordSuccess());
        case Err(:final failure):
          updated = updated.withBudget(
            source.id,
            requested.recordFailure(
              now,
              isRateLimited: failure is NetworkFailure && failure.isRateLimited,
            ),
          );
      }
    }
    if (isBackground) {
      updated = updated.copyWith(lastBackgroundRefresh: now);
    }
    await cacheRepository.save(updated);
    return (cache: updated, fetched: fetched);
  }
}
