import 'dart:math' as math;

import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/clock/clock.dart';
import 'package:gym_tracker/features/checkin/domain/streak_snapshot.dart';
import 'package:gym_tracker/features/checkin/domain/training_week.dart';
import 'package:gym_tracker/features/checkin/domain/weekly_goal.dart';

typedef CheckInHistory = ({
  Set<CalendarDate> workoutDays,
  WeeklyGoalHistory goals,
});

abstract interface class StreakCalculator {
  StreakSnapshot compute(CheckInHistory history);
}

/// The streak rules of plan section 4, as one deterministic pass over the
/// days from the first workout's week to today.
class WeeklyStreakCalculator implements StreakCalculator {
  const new(this.clock);

  final Clock clock;

  static const int _lastIndex = TrainingWeek.length - 1;

  @override
  StreakSnapshot compute(CheckInHistory history) {
    final today = CalendarDate.fromDateTime(clock.now());
    final days = {
      for (final day in history.workoutDays)
        if (!day.isAfter(today)) day,
    };
    final thisMonday = TrainingWeek.mondayOf(today);
    final firstMonday = days.isEmpty
        ? thisMonday
        : TrainingWeek.mondayOf(days.reduce((a, b) => a.isBefore(b) ? a : b));

    var streak = 0;
    var best = 0;
    var weeksOnTrack = 0;
    final weeks = <WeekResult>[];
    late CurrentWeek current;

    for (
      var monday = firstMonday;
      !monday.isAfter(thisMonday);
      monday = monday.addDays(TrainingWeek.length)
    ) {
      final goal = history.goals.goalFor(monday);
      var done = 0;
      var isLost = false;
      for (var index = 0; index <= _lastIndex; index++) {
        final day = monday.addDays(index);
        if (day.isAfter(today)) {
          break;
        }
        if (days.contains(day)) {
          done += 1;
          streak += 1;
          best = math.max(best, streak);
        }
        // Today is still open, so it can't end the week yet.
        if (day == today) {
          break;
        }
        if (!isLost && goal - done > _lastIndex - index) {
          isLost = true;
          streak = 0;
          weeksOnTrack = 0;
        }
      }
      final isComplete = monday.addDays(_lastIndex).isBefore(today);
      if (done >= goal) {
        weeksOnTrack += 1;
      }
      weeks.add(
        WeekResult(
          monday: monday,
          done: done,
          goal: goal,
          isComplete: isComplete,
        ),
      );
      if (monday == thisMonday) {
        current = _currentWeek(
          monday: monday,
          today: today,
          done: done,
          goal: goal,
          isLost: isLost,
          isTodayDone: days.contains(today),
          hasStreak: streak > 0,
        );
      }
    }

    return StreakSnapshot(
      currentDays: streak,
      bestDays: best,
      weeksOnTrack: weeksOnTrack,
      totalWorkouts: days.length,
      currentWeek: current,
      weeks: days.isEmpty ? const [] : weeks,
    );
  }

  static CurrentWeek _currentWeek({
    required CalendarDate monday,
    required CalendarDate today,
    required int done,
    required int goal,
    required bool isLost,
    required bool isTodayDone,
    required bool hasStreak,
  }) {
    final daysAfterToday = _lastIndex - monday.daysUntil(today);
    final openDays = daysAfterToday + (isTodayDone ? 0 : 1);
    final needed = goal - done;
    final status = switch (needed) {
      _ when isLost || !hasStreak => WeekStatus.freshStart,
      <= 0 => WeekStatus.met,
      _ when needed < openDays => WeekStatus.onTrack,
      _ => WeekStatus.lastChance,
    };
    return CurrentWeek(
      monday: monday,
      done: done,
      goal: goal,
      openDays: openDays,
      status: status,
      isLost: isLost,
    );
  }
}
