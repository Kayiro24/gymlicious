import 'package:gym_tracker/core/clock/calendar_date.dart';

/// The check-in week: Monday to Saturday are regular days and Sunday is the
/// bonus day. A week is identified by its Monday.
abstract final class TrainingWeek {
  static const int length = DateTime.daysPerWeek;

  static CalendarDate mondayOf(CalendarDate date) =>
      date.addDays(-(date.weekday - DateTime.monday));

  static List<CalendarDate> daysOf(CalendarDate monday) => [
    for (var offset = 0; offset < length; offset++) monday.addDays(offset),
  ];

  static bool isBonusDay(CalendarDate date) => date.weekday == DateTime.sunday;
}
