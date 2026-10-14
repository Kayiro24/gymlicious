import 'package:gym_tracker/core/clock/calendar_date.dart';

enum DotState { done, today, left }

/// Progress through the year of [today], from local calendar dates only.
class YearProgress {
  new(this.today)
    : dayOfYear = today.dayOfYear,
      daysInYear = CalendarDate.daysInYear(today.year);

  static const _percent = 100;

  final CalendarDate today;

  /// Includes today.
  final int dayOfYear;
  final int daysInYear;

  /// Only days after today.
  int get daysLeft => daysInYear - dayOfYear;

  int get percentDone => (dayOfYear * _percent / daysInYear).round();

  /// [dayIndex] is 0-based from Jan 1.
  DotState stateOf(int dayIndex) {
    final day = dayIndex + 1;
    if (day < dayOfYear) {
      return DotState.done;
    }
    return day == dayOfYear ? DotState.today : DotState.left;
  }

  CalendarDate dateOf(int dayIndex) =>
      CalendarDate(today.year, 1, 1).addDays(dayIndex);
}
