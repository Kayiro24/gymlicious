import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/features/checkin/checkin_domain.dart';

import '../../fakes/fake_gateways.dart';

CalendarDate _d(int year, int month, int day) => CalendarDate(year, month, day);

/// October 2026: Mon 5 to Sun 11, Mon 12 to Sun 18, Mon 19 onwards.
CalendarDate _oct(int day) => _d(2026, 10, day);

StreakSnapshot _compute(
  Iterable<CalendarDate> days, {
  required CalendarDate today,
  int goal = 4,
  WeeklyGoalHistory? goals,
  int hour = 9,
}) =>
    WeeklyStreakCalculator(
      FixedClock(DateTime(today.year, today.month, today.day, hour)),
    ).compute((
      workoutDays: days.toSet(),
      goals:
          goals ??
          WeeklyGoalHistory(
            periods: [GoalPeriod(effectiveFrom: _oct(5), daysPerWeek: goal)],
          ),
    ));

void main() {
  group('worked examples from the plan', () {
    test('A: skipped days never break a met week', () {
      final wednesday = _compute([_oct(12), _oct(13)], today: _oct(14));
      expect(wednesday.currentWeek.status, WeekStatus.onTrack);
      expect(wednesday.currentWeek.needed, 2);
      expect(wednesday.currentWeek.openDays, 5);

      final sunday = _compute([
        _oct(12),
        _oct(13),
        _oct(15),
        _oct(17),
      ], today: _oct(18));
      expect(sunday.currentWeek.status, WeekStatus.met);
      expect(sunday.currentDays, 4);
      expect(sunday.weeksOnTrack, 1);
    });

    test('B: three leave days and a Sunday bonus', () {
      final mondayToWednesday = [_oct(12), _oct(13), _oct(14)];
      final sundayMorning = _compute(mondayToWednesday, today: _oct(18));
      expect(sundayMorning.currentWeek.status, WeekStatus.lastChance);
      expect(sundayMorning.currentWeek.isLost, isFalse);
      expect(sundayMorning.currentDays, 3);

      final trained = _compute([
        ...mondayToWednesday,
        _oct(18),
      ], today: _oct(18));
      expect(trained.currentWeek.status, WeekStatus.met);
      expect(trained.currentDays, 4);
    });

    test('C: safe, then last chance, then lost, then a new streak', () {
      final done = [_oct(12), _oct(13)];
      final thursday = _compute(done, today: _oct(15));
      expect(thursday.currentWeek.status, WeekStatus.onTrack);
      expect(thursday.currentWeek.openDays, 4);

      final saturday = _compute(done, today: _oct(17));
      expect(saturday.currentWeek.status, WeekStatus.lastChance);
      expect(saturday.currentWeek.openDays, 2);

      final sunday = _compute(done, today: _oct(18));
      expect(sunday.currentWeek.status, WeekStatus.freshStart);
      expect(sunday.currentWeek.isLost, isTrue);
      expect(sunday.currentDays, 0);
      expect(sunday.bestDays, 2);

      final sundayTrained = _compute([...done, _oct(18)], today: _oct(18));
      expect(sundayTrained.currentDays, 1);
      expect(sundayTrained.currentWeek.status, WeekStatus.freshStart);
    });

    final lastWeek = [_oct(5), _oct(6), _oct(8), _oct(10), _oct(11)];

    test('D: the streak counts workout days across weeks', () {
      final snapshot = _compute([
        ...lastWeek,
        _oct(12),
        _oct(13),
      ], today: _oct(14));
      expect(snapshot.currentDays, 7);
      expect(snapshot.weeksOnTrack, 1);
      expect(snapshot.bestDays, 7);
      expect(snapshot.totalWorkouts, 7);
    });

    test('E: a week that ends short ends the streak, best is kept', () {
      final days = [...lastWeek, _oct(12), _oct(13)];
      final monday = _compute(days, today: _oct(19));
      expect(monday.currentDays, 0);
      expect(monday.bestDays, 7);
      expect(monday.weeksOnTrack, 0);
      expect(monday.currentWeek.status, WeekStatus.freshStart);

      final restarted = _compute([...days, _oct(19)], today: _oct(19));
      expect(restarted.currentDays, 1);
      expect(restarted.bestDays, 7);
    });

    test('F: a goal change applies from its Monday only', () {
      final goals = const WeeklyGoalHistory()
          .withGoal(_oct(5), 4)
          .withGoal(_oct(12), 3);
      final snapshot = _compute(
        [...lastWeek, _oct(12), _oct(13)],
        today: _oct(14),
        goals: goals,
      );
      expect(snapshot.weeks.first.goal, 4);
      expect(snapshot.currentWeek.goal, 3);
      expect(snapshot.currentWeek.needed, 1);

      final changedAgain = goals.withGoal(_oct(12), 5);
      expect(changedAgain.periods, hasLength(2));
      expect(changedAgain.goalFor(_oct(12)), 5);
      expect(changedAgain.goalFor(_oct(5)), 4);
    });

    test('G: backfilling forgotten days restores the streak', () {
      final forgot = _compute([_oct(12), _oct(13)], today: _oct(18));
      expect(forgot.currentDays, 0);
      final backfilled = _compute([
        _oct(12),
        _oct(13),
        _oct(15),
        _oct(17),
      ], today: _oct(18));
      expect(backfilled.currentDays, 4);
      expect(backfilled.currentWeek.status, WeekStatus.met);
    });

    test('I: a mid-week start can begin a streak straight away', () {
      final snapshot = _compute([_oct(16), _oct(17)], today: _oct(17));
      expect(snapshot.currentDays, 2);
      expect(snapshot.currentWeek.isLost, isTrue);
      expect(snapshot.currentWeek.status, WeekStatus.freshStart);

      final nextWeek = _compute([
        _oct(16),
        _oct(17),
        _oct(19),
      ], today: _oct(19));
      expect(nextWeek.currentDays, 3);
      expect(nextWeek.currentWeek.status, WeekStatus.onTrack);
    });
  });

  group('goals 3 to 6', () {
    for (final goal in [3, 4, 5, 6]) {
      final weekdays = [for (var day = 12; day <= 17; day++) _oct(day)];

      test('goal $goal met with the first $goal weekdays', () {
        final snapshot = _compute(
          weekdays.take(goal),
          today: _oct(19),
          goal: goal,
        );
        expect(snapshot.currentDays, goal);
        expect(snapshot.weeks.first.isMet, isTrue);
      });

      test('goal $goal met with ${goal - 1} weekdays plus Sunday', () {
        final snapshot = _compute(
          [...weekdays.take(goal - 1), _oct(18)],
          today: _oct(19),
          goal: goal,
        );
        expect(snapshot.currentDays, goal);
      });

      test('goal $goal ends the streak when one short', () {
        final snapshot = _compute(
          weekdays.take(goal - 1),
          today: _oct(19),
          goal: goal,
        );
        expect(snapshot.currentDays, 0);
        expect(snapshot.bestDays, goal - 1);
      });
    }
  });

  group('a leave day on each weekday', () {
    final weekdays = [for (var day = 12; day <= 17; day++) _oct(day)];
    for (final (index, leave) in weekdays.indexed) {
      final name = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][index];
      final trained = [
        for (final day in weekdays)
          if (day != leave) day,
      ];

      test('goal 4, leave on $name: still met', () {
        final snapshot = _compute(trained, today: _oct(19));
        expect(snapshot.weeks.first.isMet, isTrue);
        expect(snapshot.currentDays, 5);
      });

      test('goal 6, leave on $name: Sunday fills in', () {
        final withSunday = _compute(
          [...trained, _oct(18)],
          today: _oct(19),
          goal: 6,
        );
        expect(withSunday.currentDays, 6);
        final withoutSunday = _compute(trained, today: _oct(19), goal: 6);
        expect(withoutSunday.currentDays, 0);
      });

      test('goal 6, leave on $name: Sunday morning is the last chance', () {
        final snapshot = _compute(trained, today: _oct(18), goal: 6);
        expect(snapshot.currentWeek.status, WeekStatus.lastChance);
        expect(snapshot.currentWeek.openDays, 1);
      });
    }
  });

  group('Sunday bonus and week rollover', () {
    test('a Sunday-only week meets a goal of 1', () {
      final snapshot = _compute([_oct(18)], today: _oct(19), goal: 1);
      expect(snapshot.weeks.first.isMet, isTrue);
      expect(snapshot.currentDays, 1);
    });

    test('a Sunday workout in a met week adds a streak day', () {
      final days = [_oct(12), _oct(13), _oct(14), _oct(15)];
      expect(_compute(days, today: _oct(18)).currentDays, 4);
      expect(_compute([...days, _oct(18)], today: _oct(18)).currentDays, 5);
    });

    test('the streak carries from Sunday night into Monday', () {
      final days = [_oct(12), _oct(13), _oct(14), _oct(15)];
      final sundayNight = _compute(days, today: _oct(18), hour: 23);
      final mondayMorning = _compute(days, today: _oct(19), hour: 0);
      expect(sundayNight.currentDays, 4);
      expect(mondayMorning.currentDays, 4);
      expect(mondayMorning.weeksOnTrack, 1);
      expect(mondayMorning.currentWeek.monday, _oct(19));
      expect(mondayMorning.currentWeek.openDays, 7);
      expect(mondayMorning.currentWeek.status, WeekStatus.onTrack);
    });
  });

  group('edges', () {
    test('no workouts at all is a fresh start with the default goal', () {
      final snapshot = WeeklyStreakCalculator(
        FixedClock(DateTime(2026, 10, 14, 9)),
      ).compute((workoutDays: const {}, goals: const WeeklyGoalHistory()));
      expect(snapshot.currentDays, 0);
      expect(snapshot.currentWeek.goal, WeeklyGoalHistory.defaultDays);
      expect(snapshot.currentWeek.status, WeekStatus.freshStart);
      expect(snapshot.weeks, isEmpty);
    });

    test('future days never count', () {
      final snapshot = _compute([_oct(12), _oct(20)], today: _oct(14));
      expect(snapshot.totalWorkouts, 1);
      expect(snapshot.currentDays, 1);
    });

    test('unmarking a day lowers the streak again', () {
      final days = [_oct(12), _oct(13), _oct(15), _oct(17)];
      expect(_compute(days, today: _oct(18)).currentDays, 4);
      expect(_compute(days.skip(1), today: _oct(18)).currentDays, 3);
    });

    test('weeks before the first goal use the first goal', () {
      final goals = const WeeklyGoalHistory().withGoal(_oct(12), 2);
      expect(goals.goalFor(_oct(5)), 2);
      expect(goals.goalFor(_oct(19)), 2);
    });

    test('goals outside 1 to 6 are rejected', () {
      expect(
        () => const WeeklyGoalHistory().withGoal(_oct(12), 7),
        throwsArgumentError,
      );
    });
  });

  group('calendar safety', () {
    test('a week spanning New Year is one week', () {
      final days = [
        _d(2025, 12, 29),
        _d(2025, 12, 30),
        _d(2026, 1, 1),
        _d(2026, 1, 3),
      ];
      final snapshot = _compute(
        days,
        today: _d(2026, 1, 4),
        goals: const WeeklyGoalHistory().withGoal(_d(2025, 12, 29), 4),
      );
      expect(snapshot.currentWeek.monday, _d(2025, 12, 29));
      expect(snapshot.currentWeek.status, WeekStatus.met);
      expect(snapshot.currentDays, 4);
    });

    test('ten weeks across the 53-week year 2026 keep one streak', () {
      final firstMonday = _d(2026, 11, 23);
      final days = [
        for (var week = 0; week < 10; week++)
          for (final offset in [0, 2, 4])
            firstMonday.addDays(week * 7 + offset),
      ];
      final snapshot = _compute(
        days,
        today: firstMonday.addDays(10 * 7),
        goals: const WeeklyGoalHistory().withGoal(firstMonday, 3),
      );
      expect(snapshot.currentDays, 30);
      expect(snapshot.weeksOnTrack, 10);
    });

    for (final (label, sunday) in [
      ('spring', _d(2026, 3, 29)),
      ('autumn', _d(2026, 10, 25)),
    ]) {
      test('DST $label: dates near midnight stay on the right day', () {
        final monday = TrainingWeek.mondayOf(sunday);
        final days = [monday, monday.addDays(1), monday.addDays(3)];
        final goals = const WeeklyGoalHistory().withGoal(monday, 4);
        for (final hour in [0, 2, 3, 23]) {
          final snapshot = _compute(
            days,
            today: sunday,
            goals: goals,
            hour: hour,
          );
          expect(snapshot.currentWeek.monday, monday, reason: 'hour $hour');
          expect(snapshot.currentWeek.status, WeekStatus.lastChance);
        }
        final next = _compute(
          days,
          today: sunday.addDays(1),
          goals: goals,
          hour: 0,
        );
        expect(next.currentDays, 0);
        expect(next.currentWeek.monday, sunday.addDays(1));
      });
    }
  });
}
