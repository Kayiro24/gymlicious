import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/features/workouts/domain/entities/workout_session.dart';

typedef ProgressPoint = ({CalendarDate date, double bestKg, String sessionId});

abstract final class ProgressSeries {
  /// Best completed working weight per session, oldest first.
  static List<ProgressPoint> forExercise(
    String exerciseId,
    Iterable<WorkoutSession> sessions,
  ) {
    final points = <ProgressPoint>[];
    final ordered = [...sessions]
      ..sort((a, b) => a.startedAt.compareTo(b.startedAt));
    for (final session in ordered) {
      final best = session.entryFor(exerciseId)?.bestWeightKg;
      if (best != null) {
        points.add((
          date: CalendarDate.fromDateTime(session.startedAt),
          bestKg: best,
          sessionId: session.id,
        ));
      }
    }
    return points;
  }

  /// Sessions that include [exerciseId], newest first.
  static List<WorkoutSession> sessionsWith(
    String exerciseId,
    Iterable<WorkoutSession> sessions,
  ) =>
      sessions.where((session) => session.entryFor(exerciseId) != null).toList()
        ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
}
