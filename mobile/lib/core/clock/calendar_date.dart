import 'package:meta/meta.dart';

/// A local calendar date (year, month, day) with no time or time zone.
///
/// Day arithmetic goes through UTC so DST changes can never shift a date.
@immutable
class CalendarDate implements Comparable<CalendarDate> {
  const new(this.year, this.month, this.day);

  factory fromDateTime(DateTime dateTime) =>
      CalendarDate(dateTime.year, dateTime.month, dateTime.day);

  factory parse(String iso) {
    final parts = iso.split('-');
    if (parts.length != 3) {
      throw FormatException('Expected YYYY-MM-DD', iso);
    }
    final date = CalendarDate(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
    final normalised = date._utc;
    if (normalised.month != date.month || normalised.day != date.day) {
      throw FormatException('Not a real calendar date', iso);
    }
    return date;
  }

  final int year;
  final int month;
  final int day;

  DateTime get _utc => DateTime.utc(year, month, day);

  static bool isLeapYear(int year) =>
      (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;

  static int daysInYear(int year) => isLeapYear(year) ? 366 : 365;

  static int daysInMonth(int year, int month) =>
      DateTime.utc(year, month + 1, 0).day;

  /// 1 for Jan 1.
  int get dayOfYear => _utc.difference(DateTime.utc(year)).inDays + 1;

  /// ISO weekday: Monday = 1 ... Sunday = 7.
  int get weekday => _utc.weekday;

  CalendarDate addDays(int days) =>
      CalendarDate.fromDateTime(_utc.add(Duration(days: days)));

  int daysUntil(CalendarDate other) => other._utc.difference(_utc).inDays;

  bool isBefore(CalendarDate other) => compareTo(other) < 0;

  bool isAfter(CalendarDate other) => compareTo(other) > 0;

  /// Local midnight at the start of this date.
  DateTime toLocalDateTime() => DateTime(year, month, day);

  String toIso() =>
      '${year.toString().padLeft(4, '0')}-'
      '${month.toString().padLeft(2, '0')}-'
      '${day.toString().padLeft(2, '0')}';

  @override
  int compareTo(CalendarDate other) => _utc.compareTo(other._utc);

  @override
  bool operator ==(Object other) =>
      other is CalendarDate &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() => toIso();
}
