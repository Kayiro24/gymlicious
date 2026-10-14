import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/features/checkin/checkin_domain.dart';

enum TrainingPeriod {
  morning,
  afternoon,
  evening,
  night;

  static const _morningFrom = 5;
  static const _afternoonFrom = 12;
  static const _eveningFrom = 17;
  static const _nightFrom = 21;

  static TrainingPeriod of(DayTime time) => switch (time.hour) {
    < _morningFrom => night,
    < _afternoonFrom => morning,
    < _eveningFrom => afternoon,
    < _nightFrom => evening,
    _ => night,
  };
}

/// Read-only views over check-in data for the Stats screen.
abstract final class TrainingStats {
  static const consistencyWindow = 12;
  static const chartWeeks = 8;

  /// Share of the last up-to-12 finished weeks that met their goal, or null
  /// before the first week has finished.
  static ({int met, int total})? consistency(StreakSnapshot streak) {
    final finished = [
      for (final week in streak.weeks)
        if (week.isComplete) week,
    ];
    if (finished.isEmpty) {
      return null;
    }
    final window = finished.skip(
      finished.length > consistencyWindow
          ? finished.length - consistencyWindow
          : 0,
    );
    return (
      met: window.where((week) => week.isMet).length,
      total: window.length,
    );
  }

  static int workoutsInMonth(
    Map<CalendarDate, DayRecord> records,
    int year,
    int month,
  ) => records.values
      .where(
        (record) =>
            record.isDone &&
            record.date.year == year &&
            record.date.month == month,
      )
      .length;

  /// The last [count] weeks ending with this one, oldest first; weeks with no
  /// data show zero against the goal of their time.
  static List<WeekResult> recentWeeks(
    StreakSnapshot streak,
    WeeklyGoalHistory goals, {
    int count = chartWeeks,
  }) {
    final byMonday = {for (final week in streak.weeks) week.monday: week};
    final thisMonday = streak.currentWeek.monday;
    return [
      for (var back = count - 1; back >= 0; back--)
        _week(
          byMonday,
          goals,
          thisMonday.addDays(-back * TrainingWeek.length),
          isComplete: back > 0,
        ),
    ];
  }

  static WeekResult _week(
    Map<CalendarDate, WeekResult> byMonday,
    WeeklyGoalHistory goals,
    CalendarDate monday, {
    required bool isComplete,
  }) =>
      byMonday[monday] ??
      WeekResult(
        monday: monday,
        done: 0,
        goal: goals.goalFor(monday),
        isComplete: isComplete,
      );

  static Map<TrainingPeriod, int> timeOfDay(
    Map<CalendarDate, DayRecord> records,
  ) {
    final counts = {for (final period in TrainingPeriod.values) period: 0};
    for (final record in records.values) {
      if (record.time case final time? when record.isDone) {
        counts[TrainingPeriod.of(time)] = counts[TrainingPeriod.of(time)]! + 1;
      }
    }
    return counts;
  }

  static TrainingPeriod? typicalPeriod(Map<TrainingPeriod, int> counts) {
    TrainingPeriod? best;
    var bestCount = 0;
    for (final MapEntry(:key, :value) in counts.entries) {
      if (value > bestCount) {
        best = key;
        bestCount = value;
      }
    }
    return best;
  }
}
