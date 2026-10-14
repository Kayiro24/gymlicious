import 'package:freezed_annotation/freezed_annotation.dart';

part 'rate_budget.freezed.dart';

/// Local request budget for one quote source (spec 6.2 rule 3).
@freezed
abstract class RateBudget with _$RateBudget {
  const factory({
    @Default(<DateTime>[]) List<DateTime> recentRequests,
    DateTime? blockedUntil,
    @Default(0) int consecutiveErrors,
  }) = _RateBudget;

  const new _();

  static const window = Duration(hours: 1);
  static const backoff = Duration(hours: 1);
  static const errorsBeforeBackoff = 3;

  bool canRequest(DateTime now, {required int maxPerWindow}) {
    final blocked = blockedUntil;
    if (blocked != null && now.isBefore(blocked)) {
      return false;
    }
    return _inWindow(now).length < maxPerWindow;
  }

  List<DateTime> _inWindow(DateTime now) => [
    for (final at in recentRequests)
      if (now.difference(at) < window) at,
  ];

  RateBudget recordRequest(DateTime now) =>
      copyWith(recentRequests: [..._inWindow(now), now]);

  RateBudget recordSuccess() => copyWith(consecutiveErrors: 0);

  /// A 429, or repeated errors, block the source for an hour.
  RateBudget recordFailure(DateTime now, {required bool isRateLimited}) {
    final errors = consecutiveErrors + 1;
    final shouldBackOff = isRateLimited || errors >= errorsBeforeBackoff;
    return copyWith(
      consecutiveErrors: shouldBackOff ? 0 : errors,
      blockedUntil: shouldBackOff ? now.add(backoff) : blockedUntil,
    );
  }
}
