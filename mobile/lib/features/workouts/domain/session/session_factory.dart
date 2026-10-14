import 'package:gym_tracker/features/workouts/domain/entities/exercise.dart';
import 'package:gym_tracker/features/workouts/domain/entities/exercise_stats.dart';
import 'package:gym_tracker/features/workouts/domain/entities/split.dart';
import 'package:gym_tracker/features/workouts/domain/entities/workout_session.dart';
import 'package:gym_tracker/features/workouts/domain/rules/set_prefill.dart';

abstract final class SessionFactory {
  static SessionEntry entryFor(
    Exercise exercise,
    Iterable<WorkoutSession> history,
    ExerciseStats stats,
  ) => SessionEntry(
    exerciseId: exercise.id,
    exerciseName: exercise.name,
    sets: SetPrefill.forExercise(exercise.id, history, stats),
  );

  /// A new session for [day] of [split] (or freestyle when both are null),
  /// with sets prefilled from the last time each exercise was logged.
  static WorkoutSession start({
    required String id,
    required DateTime startedAt,
    required List<Exercise> exercises,
    required Iterable<WorkoutSession> history,
    required Map<String, ExerciseStats> stats,
    WorkoutSplit? split,
    SplitDay? day,
  }) {
    final byId = {for (final exercise in exercises) exercise.id: exercise};
    final dayExercises = [
      for (final exerciseId in day?.exerciseIds ?? const <String>[])
        if (byId[exerciseId] case final exercise? when !exercise.isArchived)
          exercise,
    ];
    return WorkoutSession(
      id: id,
      startedAt: startedAt,
      splitId: split?.id,
      dayId: day?.id,
      dayName: day?.name,
      entries: [
        for (final exercise in dayExercises)
          entryFor(
            exercise,
            history,
            stats[exercise.id] ?? ExerciseStats.empty,
          ),
      ],
    );
  }
}
