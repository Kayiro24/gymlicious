import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/features/checkin/domain/training_week.dart';

abstract final class CheckInReminders {
  static const horizonDays = 7;

  /// The next reminder times on Monday to Saturday that aren't checked in
  /// yet, within a week. Rescheduled on every app open and check-in, so a
  /// done day is never nagged and a week away quietly stops them.
  static List<DateTime> upcoming({
    required DateTime now,
    required int minutesOfDay,
    required Set<CalendarDate> doneDays,
  }) {
    final today = CalendarDate.fromDateTime(now);
    return [
      for (var offset = 0; offset < horizonDays; offset++)
        if (today.addDays(offset) case final date
            when !TrainingWeek.isBonusDay(date) && !doneDays.contains(date))
          if (_at(date, minutesOfDay) case final time when time.isAfter(now))
            time,
    ];
  }

  static DateTime _at(CalendarDate date, int minutesOfDay) => DateTime(
    date.year,
    date.month,
    date.day,
    minutesOfDay ~/ Duration.minutesPerHour,
    minutesOfDay % Duration.minutesPerHour,
  );
}
