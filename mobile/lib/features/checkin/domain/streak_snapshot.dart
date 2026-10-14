import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';

part 'streak_snapshot.freezed.dart';

/// How the current week stands (plan 4.4).
enum WeekStatus {
  /// The goal is already reached.
  met,

  /// The goal can be reached with days to spare.
  onTrack,

  /// Every remaining day (Sunday included) is needed.
  lastChance,

  /// No streak right now, or this week can no longer reach its goal.
  freshStart,
}

@freezed
abstract class WeekResult with _$WeekResult {
  const factory({
    required CalendarDate monday,
    required int done,
    required int goal,
    required bool isComplete,
  }) = _WeekResult;

  const new _();

  bool get isMet => done >= goal;
}

@freezed
abstract class CurrentWeek with _$CurrentWeek {
  const factory({
    required CalendarDate monday,
    required int done,
    required int goal,

    /// Remaining days, Sunday included, plus today if it isn't done yet.
    required int openDays,
    required WeekStatus status,

    /// The goal became unreachable earlier this week.
    @Default(false) bool isLost,
  }) = _CurrentWeek;

  const new _();

  int get needed => goal - done < 0 ? 0 : goal - done;
}

@freezed
abstract class StreakSnapshot with _$StreakSnapshot {
  const factory({
    required int currentDays,
    required int bestDays,
    required int weeksOnTrack,
    required int totalWorkouts,
    required CurrentWeek currentWeek,

    /// Oldest first, from the week of the first workout to this week.
    @Default(<WeekResult>[]) List<WeekResult> weeks,
  }) = _StreakSnapshot;
}
