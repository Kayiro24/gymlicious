import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/features/workouts/domain/entities/exercise_stats.dart';
import 'package:gym_tracker/features/workouts/domain/entities/workout_set.dart';
import 'package:gym_tracker/features/workouts/domain/rules/exercise_name_rules.dart';
import 'package:gym_tracker/features/workouts/domain/rules/exercise_stats_calculator.dart';
import 'package:gym_tracker/features/workouts/domain/rules/progress_series.dart';
import 'package:gym_tracker/features/workouts/domain/rules/session_summary.dart';
import 'package:gym_tracker/features/workouts/domain/rules/set_prefill.dart';
import 'package:gym_tracker/features/workouts/domain/rules/training_calendar.dart';
import 'package:gym_tracker/features/workouts/domain/rules/up_next.dart';

import 'workout_fixtures.dart';

void main() {
  final monday = DateTime(2026, 10, 12, 18);
  final tuesday = DateTime(2026, 10, 13, 18);
  final wednesday = DateTime(2026, 10, 14, 18);

  group('ExerciseStatsCalculator', () {
    test('max is the heaviest completed working set across history', () {
      final stats = ExerciseStatsCalculator.compute(bench, [
        session('a', monday, {
          bench: [done(100), done(120, warmup: true), planned(130)],
        }),
        session('b', tuesday, {
          bench: [done(95)],
        }),
      ]);

      expect(stats.maxKg, 100);
      expect(stats.maxDate, const CalendarDate(2026, 10, 12));
    });

    test('last is the heaviest completed set of the most recent session', () {
      final stats = ExerciseStatsCalculator.compute(bench, [
        session('late', wednesday, {
          bench: [done(80), done(85)],
        }),
        session('early', monday, {
          bench: [done(100)],
        }),
      ]);

      expect(stats.lastKg, 85);
      expect(stats.lastDate, const CalendarDate(2026, 10, 14));
    });

    test('a backdated session does not become "last"', () {
      final stats = ExerciseStatsCalculator.compute(bench, [
        session('current', wednesday, {
          bench: [done(90)],
        }),
        session('backdated', monday, {
          bench: [done(70)],
        }),
      ]);

      expect(stats.lastKg, 90);
    });

    test('sessions without completed working sets are ignored', () {
      final stats = ExerciseStatsCalculator.compute(bench, [
        session('a', monday, {
          bench: [done(60)],
        }),
        session('b', tuesday, {
          bench: [planned(200), done(150, warmup: true)],
        }),
      ]);

      expect(stats.lastKg, 60);
      expect(stats.maxKg, 60);
    });

    test('baseline max wins when higher than logged history', () {
      final stats = ExerciseStatsCalculator.compute(
        bench.copyWith(baselineMaxKg: 110),
        [
          session('a', monday, {
            bench: [done(100)],
          }),
        ],
      );

      expect(stats.maxKg, 110);
      expect(stats.maxDate, isNull);
    });

    test('baseline last applies only until a real session exists', () {
      final withBaseline = bench.copyWith(
        baselineLastKg: 70,
        baselineLastDate: const CalendarDate(2026, 10, 1),
      );

      expect(ExerciseStatsCalculator.compute(withBaseline, []).lastKg, 70);
      expect(
        ExerciseStatsCalculator.compute(withBaseline, [
          session('a', monday, {
            bench: [done(72.5)],
          }),
        ]).lastKg,
        72.5,
      );
    });

    test('recomputing after a delete or edit never drifts', () {
      final sessions = [
        session('a', monday, {
          bench: [done(100)],
        }),
        session('b', tuesday, {
          bench: [done(110)],
        }),
      ];
      expect(ExerciseStatsCalculator.compute(bench, sessions).maxKg, 110);

      final afterDelete = sessions.where((item) => item.id != 'b');
      expect(ExerciseStatsCalculator.compute(bench, afterDelete).maxKg, 100);

      final edited = [
        sessions.first,
        sessions.last.copyWith(
          entries: [
            sessions.last.entries.single.copyWith(sets: [done(90)]),
          ],
        ),
      ];
      final stats = ExerciseStatsCalculator.compute(bench, edited);
      expect(stats.maxKg, 100);
      expect(stats.lastKg, 90);
    });

    test('bodyweight sets at 0 kg are tracked', () {
      final stats = ExerciseStatsCalculator.compute(pullUp, [
        session('a', monday, {
          pullUp: [done(0, reps: 10)],
        }),
      ]);

      expect(stats.maxKg, 0);
      expect(stats.lastKg, 0);
      expect(pullUp.isBodyweight, isTrue);
    });

    test('no history and no baselines gives empty stats', () {
      expect(ExerciseStatsCalculator.compute(bench, []), ExerciseStats.empty);
    });
  });

  group('UpNext', () {
    test('first training day when the split has never been trained', () {
      expect(UpNext.dayFor(ppl, [])?.id, 'push');
    });

    test('the day after the most recent one, skipping rest days', () {
      final sessions = [
        session('a', monday, {}, splitId: ppl.id, dayId: 'push'),
      ];

      expect(UpNext.dayFor(ppl, sessions)?.id, 'pull');
    });

    test('wraps around after the last day', () {
      final sessions = [
        session('a', monday, {}, splitId: ppl.id, dayId: 'pull'),
        session('b', tuesday, {}, splitId: ppl.id, dayId: 'legs'),
      ];

      expect(UpNext.dayFor(ppl, sessions)?.id, 'push');
    });

    test('uses the latest session by date, not list order', () {
      final sessions = [
        session('later', wednesday, {}, splitId: ppl.id, dayId: 'pull'),
        session('earlier', monday, {}, splitId: ppl.id, dayId: 'push'),
      ];

      expect(UpNext.dayFor(ppl, sessions)?.id, 'legs');
    });

    test('ignores freestyle sessions and other splits', () {
      final sessions = [
        session('freestyle', tuesday, {}),
        session('other', wednesday, {}, splitId: 'other', dayId: 'push'),
      ];

      expect(UpNext.dayFor(ppl, sessions)?.id, 'push');
    });

    test('a split with only rest days has nothing up next', () {
      expect(UpNext.dayFor(ppl.copyWith(days: [ppl.days[1]]), []), isNull);
    });
  });

  group('SetPrefill', () {
    test('copies the previous session sets as not done', () {
      final sets = SetPrefill.forExercise(bench.id, [
        session('a', monday, {
          bench: [done(60, warmup: true), done(100, reps: 3)],
        }),
      ], ExerciseStats.empty);

      expect(sets, [
        const WorkoutSet(weightKg: 60, reps: 5, isWarmup: true),
        const WorkoutSet(weightKg: 100, reps: 3),
      ]);
    });

    test('uses the most recent session', () {
      final sets = SetPrefill.forExercise(bench.id, [
        session('new', tuesday, {
          bench: [done(90)],
        }),
        session('old', monday, {
          bench: [done(80)],
        }),
      ], ExerciseStats.empty);

      expect(sets.single.weightKg, 90);
    });

    test('falls back to one set at the last known weight', () {
      final sets = SetPrefill.forExercise(
        bench.id,
        [],
        const ExerciseStats(lastKg: 70),
      );

      expect(sets, [const WorkoutSet(weightKg: 70)]);
    });

    test('next set copies the previous weight and reps', () {
      final next = SetPrefill.nextSet([done(80, reps: 8)], ExerciseStats.empty);

      expect(next, const WorkoutSet(weightKg: 80, reps: 8));
    });
  });

  group('SessionSummary', () {
    test('reports exercises that beat the previous max', () {
      final finished = session('a', wednesday, {
        bench: [done(105)],
        pullUp: [done(0)],
      });
      final summary = SessionSummary.of(finished, {
        bench.id: const ExerciseStats(maxKg: 100),
      });

      expect(summary.newMaxes.map((max) => max.exerciseId), [bench.id]);
      expect(summary.exerciseCount, 2);
      expect(summary.completedSetCount, 2);
      expect(summary.duration, const Duration(hours: 1));
    });

    test('isNewMax ignores bodyweight-only sets', () {
      expect(SessionSummary.isNewMax(0, null), isFalse);
      expect(SessionSummary.isNewMax(50, null), isTrue);
      expect(SessionSummary.isNewMax(50, 50), isFalse);
    });
  });

  group('ProgressSeries', () {
    test('best weight per session, oldest first', () {
      final points = ProgressSeries.forExercise(bench.id, [
        session('b', tuesday, {
          bench: [done(90), done(95)],
        }),
        session('a', monday, {
          bench: [done(80)],
        }),
        session('c', wednesday, {
          pullUp: [done(0)],
        }),
      ]);

      expect(points.map((point) => point.bestKg), [80, 95]);
    });
  });

  group('TrainingCalendar', () {
    test('week of a date honours the first weekday', () {
      const wednesdayDate = CalendarDate(2026, 10, 14);

      expect(
        TrainingCalendar.weekOf(wednesdayDate, DateTime.monday).first,
        const CalendarDate(2026, 10, 12),
      );
      expect(
        TrainingCalendar.weekOf(wednesdayDate, DateTime.sunday).first,
        const CalendarDate(2026, 10, 11),
      );
    });

    test('trained dates and monthly counts', () {
      final sessions = [
        session('a', monday, {}),
        session('b', monday.add(const Duration(hours: 2)), {}),
        session('c', DateTime(2026, 9, 30), {}),
      ];

      expect(TrainingCalendar.trainedDates(sessions), hasLength(2));
      expect(TrainingCalendar.sessionsInMonth(sessions, 2026, 10), 2);
    });
  });

  group('ExerciseNameRules', () {
    test('rejects duplicates ignoring case among active exercises', () {
      expect(
        ExerciseNameRules.check(' bench press ', [bench]),
        ExerciseNameProblem.duplicate,
      );
      expect(
        ExerciseNameRules.check('Bench Press', [
          bench.copyWith(isArchived: true),
        ]),
        isNull,
      );
      expect(
        ExerciseNameRules.check('Bench Press', [bench], ignoreId: bench.id),
        isNull,
      );
    });

    test('rejects empty and overly long names', () {
      expect(ExerciseNameRules.check('  ', []), ExerciseNameProblem.empty);
      expect(
        ExerciseNameRules.check('x' * 61, []),
        ExerciseNameProblem.tooLong,
      );
    });
  });
}
