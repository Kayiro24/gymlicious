import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';

part 'weekly_goal.freezed.dart';

/// "Gym days per week" from [effectiveFrom] (always a Monday) onwards.
@freezed
abstract class GoalPeriod with _$GoalPeriod {
  const factory({
    required CalendarDate effectiveFrom,
    required int daysPerWeek,
  }) = _GoalPeriod;
}

/// Every goal the user has had, so past weeks keep the goal of their time.
@freezed
abstract class WeeklyGoalHistory with _$WeeklyGoalHistory {
  const factory({@Default(<GoalPeriod>[]) List<GoalPeriod> periods}) =
      _WeeklyGoalHistory;

  const new _();

  static const minDays = 1;
  static const maxDays = 6;
  static const defaultDays = 4;

  static bool isValidGoal(int days) => days >= minDays && days <= maxDays;

  List<GoalPeriod> get _sorted =>
      [...periods]..sort((a, b) => a.effectiveFrom.compareTo(b.effectiveFrom));

  /// The newest period starting on or before [monday]; weeks before the first
  /// period use the first one, and an empty history means the default.
  int goalFor(CalendarDate monday) {
    final sorted = _sorted;
    if (sorted.isEmpty) {
      return defaultDays;
    }
    var goal = sorted.first.daysPerWeek;
    for (final period in sorted) {
      if (period.effectiveFrom.isAfter(monday)) {
        break;
      }
      goal = period.daysPerWeek;
    }
    return goal;
  }

  int get latest => _sorted.lastOrNull?.daysPerWeek ?? defaultDays;

  /// Sets the goal from [monday] forward, replacing a change made earlier in
  /// the same week.
  WeeklyGoalHistory withGoal(CalendarDate monday, int days) {
    if (!isValidGoal(days)) {
      throw ArgumentError.value(days, 'days', 'Must be $minDays–$maxDays');
    }
    return WeeklyGoalHistory(
      periods: [
        for (final period in _sorted)
          if (period.effectiveFrom != monday) period,
        GoalPeriod(effectiveFrom: monday, daysPerWeek: days),
      ]..sort((a, b) => a.effectiveFrom.compareTo(b.effectiveFrom)),
    );
  }
}
