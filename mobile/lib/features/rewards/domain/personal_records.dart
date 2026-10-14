import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/features/workouts/workouts_domain.dart';

typedef PersonalRecord = ({
  String exerciseId,
  CalendarDate date,
  double weightKg,
});

abstract final class PersonalRecords {
  /// A PR is a session's heaviest working set beating every earlier set and
  /// the baseline max. The first time an exercise is lifted only sets the
  /// bar, so new exercises don't hand out free PRs (D51).
  static List<PersonalRecord> find(
    Iterable<Exercise> exercises,
    Iterable<WorkoutSession> sessions,
  ) {
    final best = <String, double>{
      for (final exercise in exercises) exercise.id: ?exercise.baselineMaxKg,
    };
    final ordered = [...sessions]
      ..sort((a, b) => a.startedAt.compareTo(b.startedAt));
    final records = <PersonalRecord>[];
    for (final session in ordered) {
      for (final entry in session.entries) {
        final top = entry.bestWeightKg;
        if (top == null) {
          continue;
        }
        final previous = best[entry.exerciseId];
        if (previous != null && top > previous) {
          records.add((
            exerciseId: entry.exerciseId,
            date: CalendarDate.fromDateTime(session.startedAt),
            weightKg: top,
          ));
        }
        if (previous == null || top > previous) {
          best[entry.exerciseId] = top;
        }
      }
    }
    return records;
  }
}
