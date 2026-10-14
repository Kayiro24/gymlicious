import 'dart:math';

import 'package:gym_tracker/features/quotes/domain/quote.dart';

/// Shuffled rotation through a pool that never repeats the last few shown.
class QuoteQueue {
  new(this._random);

  static const recentLimit = 5;

  final Random _random;
  final List<String> _recent = [];
  List<Quote> _pending = [];

  List<String> get recentIds => List.unmodifiable(_recent);

  /// Next quote from [pool], or null when the pool is empty.
  Quote? next(List<Quote> pool) {
    if (pool.isEmpty) {
      return null;
    }
    final poolIds = {for (final quote in pool) quote.id};
    _pending = [
      for (final quote in _pending)
        if (poolIds.contains(quote.id)) quote,
    ];
    if (_pending.isEmpty) {
      _pending = [...pool]..shuffle(_random);
    }
    final avoid = _recent.skip(
      max(0, _recent.length - min(recentLimit, pool.length - 1)),
    );
    final index = _pending.indexWhere((quote) => !avoid.contains(quote.id));
    final chosen = _pending.removeAt(index == -1 ? 0 : index);
    _recent.add(chosen.id);
    if (_recent.length > recentLimit) {
      _recent.removeAt(0);
    }
    return chosen;
  }

  /// Whether [pool] still has something not shown in the last few picks.
  bool hasUnseen(List<Quote> pool) =>
      pool.any((quote) => !_recent.contains(quote.id));
}
