import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/features/checkin/checkin_domain.dart';
import 'package:gym_tracker/features/stats/domain/training_stats.dart';

import '../../fakes/fake_gateways.dart';

CalendarDate _oct(int day) => CalendarDate(2026, 10, day);

StreakSnapshot _streak(Set<CalendarDate> days, CalendarDate today) =>
    WeeklyStreakCalculator(
      FixedClock(DateTime(today.year, today.month, today.day, 9)),
    ).compute((workoutDays: days, goals: const WeeklyGoalHistory()));

void main() {
  test('time of day buckets', () {
    expect(TrainingPeriod.of(const DayTime(4, 59)), TrainingPeriod.night);
    expect(TrainingPeriod.of(const DayTime(6, 30)), TrainingPeriod.morning);
    expect(TrainingPeriod.of(const DayTime(12, 0)), TrainingPeriod.afternoon);
    expect(TrainingPeriod.of(const DayTime(18, 30)), TrainingPeriod.evening);
    expect(TrainingPeriod.of(const DayTime(22, 0)), TrainingPeriod.night);
  });

  test('typical period counts only done days with a time', () {
    final log = const CheckInLog()
        .withEntry(
          CheckInEntry(date: _oct(12), done: true, time: const DayTime(7, 0)),
        )
        .withEntry(
          CheckInEntry(date: _oct(13), done: true, time: const DayTime(8, 0)),
        )
        .withEntry(
          CheckInEntry(date: _oct(14), done: true, time: const DayTime(19, 0)),
        )
        .withEntry(CheckInEntry(date: _oct(15), time: const DayTime(19, 0)));
    final records = DayRecords.build(log, const [], _oct(18));
    final counts = TrainingStats.timeOfDay(records);
    expect(counts[TrainingPeriod.morning], 2);
    expect(counts[TrainingPeriod.evening], 1);
    expect(TrainingStats.typicalPeriod(counts), TrainingPeriod.morning);
    expect(TrainingStats.typicalPeriod(const {}), isNull);
  });

  test('consistency uses finished weeks only', () {
    final days = {_oct(5), _oct(6), _oct(7), _oct(8), _oct(12)};
    final streak = _streak(days, _oct(14));
    expect(TrainingStats.consistency(streak), (met: 1, total: 1));
    expect(TrainingStats.consistency(_streak({_oct(12)}, _oct(14))), isNull);
  });

  test('recent weeks fill gaps and end with this week', () {
    final streak = _streak({_oct(5), _oct(12)}, _oct(14));
    final weeks = TrainingStats.recentWeeks(streak, const WeeklyGoalHistory());
    expect(weeks, hasLength(TrainingStats.chartWeeks));
    expect(weeks.last.monday, _oct(12));
    expect(weeks.last.isComplete, isFalse);
    expect(weeks[weeks.length - 2].done, 1);
    expect(weeks.first.done, 0);
    expect(weeks.first.goal, WeeklyGoalHistory.defaultDays);
  });

  test('month workouts', () {
    final log = const CheckInLog()
        .withEntry(CheckInEntry(date: _oct(1), done: true))
        .withEntry(
          const CheckInEntry(date: CalendarDate(2026, 9, 30), done: true),
        );
    final records = DayRecords.build(log, const [], _oct(14));
    expect(TrainingStats.workoutsInMonth(records, 2026, 10), 1);
  });
}
