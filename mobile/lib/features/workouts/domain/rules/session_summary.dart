import 'package:gym_tracker/features/workouts/domain/entities/exercise_stats.dart';
import 'package:gym_tracker/features/workouts/domain/entities/workout_session.dart';

typedef NewMax = ({String exerciseId, String exerciseName, double weightKg});

class SessionSummary {
  const new({
    required this.duration,
    required this.exerciseCount,
    required this.completedSetCount,
    required this.newMaxes,
  });

  /// [statsBefore] are the stats computed without this session.
  factory of(WorkoutSession session, Map<String, ExerciseStats> statsBefore) {
    final newMaxes = <NewMax>[];
    for (final entry in session.entries) {
      final best = entry.bestWeightKg;
      final previousMax = statsBefore[entry.exerciseId]?.maxKg;
      if (best != null &&
          best > 0 &&
          (previousMax == null || best > previousMax)) {
        newMaxes.add((
          exerciseId: entry.exerciseId,
          exerciseName: entry.exerciseName,
          weightKg: best,
        ));
      }
    }
    return SessionSummary(
      duration: session.duration,
      exerciseCount: session.entries
          .where((entry) => entry.countedSets.isNotEmpty)
          .length,
      completedSetCount: session.entries.fold(
        0,
        (count, entry) => count + entry.countedSets.length,
      ),
      newMaxes: newMaxes,
    );
  }

  final Duration duration;
  final int exerciseCount;
  final int completedSetCount;
  final List<NewMax> newMaxes;

  /// Whether completing a set at [weightKg] beats the max held before the
  /// session (a first-ever weighted set counts as a new max).
  static bool isNewMax(double weightKg, double? maxBeforeSession) =>
      weightKg > 0 && (maxBeforeSession == null || weightKg > maxBeforeSession);
}
