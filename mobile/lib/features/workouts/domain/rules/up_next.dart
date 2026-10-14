import 'package:gym_tracker/features/workouts/domain/entities/split.dart';
import 'package:gym_tracker/features/workouts/domain/entities/workout_session.dart';

abstract final class UpNext {
  /// The training day after the most recently completed day of [split],
  /// wrapping around. Rest days are skipped because they are never logged.
  static SplitDay? dayFor(
    WorkoutSplit split,
    Iterable<WorkoutSession> sessions,
  ) {
    final days = split.days;
    if (split.trainingDays.isEmpty) {
      return null;
    }
    WorkoutSession? latest;
    for (final session in sessions) {
      final isInSplit =
          session.splitId == split.id &&
          days.any((day) => day.id == session.dayId);
      if (isInSplit &&
          (latest == null || session.startedAt.isAfter(latest.startedAt))) {
        latest = session;
      }
    }
    if (latest == null) {
      return split.trainingDays.first;
    }
    final lastIndex = days.indexWhere((day) => day.id == latest!.dayId);
    for (var step = 1; step <= days.length; step++) {
      final candidate = days[(lastIndex + step) % days.length];
      if (!candidate.isRest) {
        return candidate;
      }
    }
    return null;
  }
}
