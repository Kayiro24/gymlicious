import 'package:gym_tracker/features/workouts/domain/entities/exercise.dart';

enum ExerciseNameProblem { empty, tooLong, duplicate }

abstract final class ExerciseNameRules {
  static const maxLength = 60;

  /// Names are unique, ignoring case, among non-archived exercises.
  static ExerciseNameProblem? check(
    String name,
    Iterable<Exercise> exercises, {
    String? ignoreId,
  }) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return ExerciseNameProblem.empty;
    }
    if (trimmed.length > maxLength) {
      return ExerciseNameProblem.tooLong;
    }
    final folded = trimmed.toLowerCase();
    final isTaken = exercises.any(
      (exercise) =>
          !exercise.isArchived &&
          exercise.id != ignoreId &&
          exercise.name.trim().toLowerCase() == folded,
    );
    return isTaken ? ExerciseNameProblem.duplicate : null;
  }
}
