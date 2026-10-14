import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gym_tracker/features/quotes/domain/quote.dart';
import 'package:gym_tracker/features/quotes/domain/rate_budget.dart';

part 'quote_cache.freezed.dart';

/// Contents of `quotes_cache.json` (never backed up).
@freezed
abstract class QuoteCache with _$QuoteCache {
  const factory({
    @Default(<Quote>[]) List<Quote> quotes,
    @Default(<String, RateBudget>{}) Map<String, RateBudget> budgets,
    DateTime? lastBackgroundRefresh,
  }) = _QuoteCache;

  const new _();

  static const maxEntries = 100;
  static const maxAge = Duration(days: 30);

  RateBudget budgetFor(String sourceId) =>
      budgets[sourceId] ?? const RateBudget();

  QuoteCache withBudget(String sourceId, RateBudget budget) =>
      copyWith(budgets: {...budgets, sourceId: budget});

  /// Adds new quotes (deduped by id), then keeps the newest 100 that are
  /// at most 30 days old.
  QuoteCache withFetched(Iterable<Quote> fetched, DateTime now) {
    final byId = {for (final quote in quotes) quote.id: quote};
    for (final quote in fetched) {
      byId.putIfAbsent(quote.id, () => quote);
    }
    return copyWith(quotes: _pruned(byId.values, now));
  }

  QuoteCache pruned(DateTime now) => copyWith(quotes: _pruned(quotes, now));

  static List<Quote> _pruned(Iterable<Quote> candidates, DateTime now) {
    final fresh = [
      for (final quote in candidates)
        if (quote.fetchedAt case final fetchedAt?
            when now.difference(fetchedAt) <= maxAge)
          quote,
    ]..sort((a, b) => b.fetchedAt!.compareTo(a.fetchedAt!));
    return fresh.take(maxEntries).toList();
  }
}
