import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/features/workouts/domain/entities/workout_session.dart';

abstract final class TrainingCalendar {
  static const daysPerWeek = 7;

  /// Local dates on which at least one session started.
  static Set<CalendarDate> trainedDates(Iterable<WorkoutSession> sessions) => {
    for (final session in sessions)
      CalendarDate.fromDateTime(session.startedAt),
  };

  /// The seven dates of the week containing [today]. [firstWeekday] uses ISO
  /// numbering (Monday = 1 ... Sunday = 7).
  static List<CalendarDate> weekOf(CalendarDate today, int firstWeekday) {
    final offset = (today.weekday - firstWeekday) % daysPerWeek;
    final start = today.addDays(-offset);
    return [for (var day = 0; day < daysPerWeek; day++) start.addDays(day)];
  }

  static int sessionsInMonth(
    Iterable<WorkoutSession> sessions,
    int year,
    int month,
  ) => sessions
      .where(
        (session) =>
            session.startedAt.year == year && session.startedAt.month == month,
      )
      .length;
}
