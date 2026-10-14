import 'package:gym_tracker/core/clock/calendar_date.dart';

abstract final class CheckInRules {
  static const maxNoteLength = 120;
  static const minDurationMinutes = 1;
  static const maxDurationMinutes = 600;

  /// Quick picks in the day sheet.
  static const durationChoices = [15, 30, 45, 60, 90];

  static bool isValidDuration(int minutes) =>
      minutes >= minDurationMinutes && minutes <= maxDurationMinutes;

  /// Future days can be planned (note, time) but not ticked off.
  static bool canMarkDone(CalendarDate date, CalendarDate today) =>
      !date.isAfter(today);
}
