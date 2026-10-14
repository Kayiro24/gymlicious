import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gym_tracker/features/workouts/domain/entities/exercise.dart';
import 'package:gym_tracker/features/workouts/domain/entities/split.dart';
import 'package:gym_tracker/features/workouts/domain/entities/workout_session.dart';

part 'workout_data.freezed.dart';

/// Everything the workouts feature persists, as one consistent value.
@freezed
abstract class WorkoutData with _$WorkoutData {
  const factory({
    @Default(<Exercise>[]) List<Exercise> exercises,
    @Default(<WorkoutSplit>[]) List<WorkoutSplit> splits,
    @Default(<WorkoutSession>[]) List<WorkoutSession> sessions,
    WorkoutSession? activeSession,
  }) = _WorkoutData;

  const new _();

  Exercise? exerciseById(String id) {
    for (final exercise in exercises) {
      if (exercise.id == id) {
        return exercise;
      }
    }
    return null;
  }

  WorkoutSplit? splitById(String? id) {
    for (final split in splits) {
      if (split.id == id) {
        return split;
      }
    }
    return null;
  }

  WorkoutSession? sessionById(String id) {
    for (final session in sessions) {
      if (session.id == id) {
        return session;
      }
    }
    return null;
  }

  List<Exercise> get activeExercises =>
      exercises.where((exercise) => !exercise.isArchived).toList();

  /// Finished sessions, most recent first.
  List<WorkoutSession> get sessionsNewestFirst =>
      [...sessions]..sort((a, b) => b.startedAt.compareTo(a.startedAt));
}
