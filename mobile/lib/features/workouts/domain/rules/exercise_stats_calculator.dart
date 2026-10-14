import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/features/workouts/domain/entities/exercise.dart';
import 'package:gym_tracker/features/workouts/domain/entities/exercise_stats.dart';
import 'package:gym_tracker/features/workouts/domain/entities/workout_session.dart';

/// Recomputes max and last from history every time, so they cannot drift.
abstract final class ExerciseStatsCalculator {
  static ExerciseStats compute(
    Exercise exercise,
    Iterable<WorkoutSession> sessions,
  ) {
    double? maxKg;
    CalendarDate? maxDate;
    double? lastKg;
    CalendarDate? lastDate;
    DateTime? lastStartedAt;

    for (final session in sessions) {
      final best = session.entryFor(exercise.id)?.bestWeightKg;
      if (best == null) {
        continue;
      }
      final date = CalendarDate.fromDateTime(session.startedAt);
      if (maxKg == null || best > maxKg) {
        maxKg = best;
        maxDate = date;
      }
      if (lastStartedAt == null || session.startedAt.isAfter(lastStartedAt)) {
        lastStartedAt = session.startedAt;
        lastKg = best;
        lastDate = date;
      }
    }

    final baselineMax = exercise.baselineMaxKg;
    if (baselineMax != null && (maxKg == null || baselineMax > maxKg)) {
      maxKg = baselineMax;
      maxDate = null;
    }
    if (lastKg == null && exercise.baselineLastKg != null) {
      lastKg = exercise.baselineLastKg;
      lastDate = exercise.baselineLastDate;
    }
    return ExerciseStats(
      maxKg: maxKg,
      maxDate: maxDate,
      lastKg: lastKg,
      lastDate: lastDate,
    );
  }

  static Map<String, ExerciseStats> computeAll(
    Iterable<Exercise> exercises,
    List<WorkoutSession> sessions,
  ) => {
    for (final exercise in exercises) exercise.id: compute(exercise, sessions),
  };
}
