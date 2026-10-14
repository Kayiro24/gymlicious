import 'package:gym_tracker/features/workouts/domain/entities/exercise_stats.dart';
import 'package:gym_tracker/features/workouts/domain/entities/workout_session.dart';
import 'package:gym_tracker/features/workouts/domain/entities/workout_set.dart';

abstract final class SetPrefill {
  /// Copies the sets from the most recent session with this exercise (same
  /// weight, reps and warm-up flags, not done). Falls back to one set at the
  /// last known weight.
  static List<WorkoutSet> forExercise(
    String exerciseId,
    Iterable<WorkoutSession> sessions,
    ExerciseStats stats,
  ) {
    SessionEntry? latestEntry;
    DateTime? latestStart;
    for (final session in sessions) {
      final entry = session.entryFor(exerciseId);
      if (entry == null || entry.sets.isEmpty) {
        continue;
      }
      if (latestStart == null || session.startedAt.isAfter(latestStart)) {
        latestStart = session.startedAt;
        latestEntry = entry;
      }
    }
    if (latestEntry != null) {
      return [for (final set in latestEntry.sets) set.copyWith(isDone: false)];
    }
    return [WorkoutSet(weightKg: stats.lastKg ?? 0)];
  }

  /// A new set appended in-session: copies the previous set, or the last
  /// known weight when the exercise has no sets yet.
  static WorkoutSet nextSet(List<WorkoutSet> current, ExerciseStats stats) {
    if (current.isEmpty) {
      return WorkoutSet(weightKg: stats.lastKg ?? 0);
    }
    final previous = current.last;
    return WorkoutSet(weightKg: previous.weightKg, reps: previous.reps);
  }
}
