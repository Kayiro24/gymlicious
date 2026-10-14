import 'package:meta/meta.dart';

/// A local wall-clock time of day (no date, no time zone), stored "HH:mm".
@immutable
class DayTime implements Comparable<DayTime> {
  const new(this.hour, this.minute)
    : assert(hour >= 0 && hour < 24, 'hour'),
      assert(minute >= 0 && minute < 60, 'minute');

  factory fromDateTime(DateTime dateTime) =>
      DayTime(dateTime.hour, dateTime.minute);

  factory parse(String value) {
    final match = _pattern.firstMatch(value);
    if (match == null) {
      throw FormatException('Expected HH:mm', value);
    }
    final hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    if (hour > 23 || minute > 59) {
      throw FormatException('Not a real time', value);
    }
    return DayTime(hour, minute);
  }

  static final _pattern = RegExp(r'^(\d{2}):(\d{2})$');
  static const _minutesPerHour = 60;

  final int hour;
  final int minute;

  int get minutesSinceMidnight => hour * _minutesPerHour + minute;

  String toStorage() =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  @override
  int compareTo(DayTime other) =>
      minutesSinceMidnight.compareTo(other.minutesSinceMidnight);

  @override
  bool operator ==(Object other) =>
      other is DayTime && other.hour == hour && other.minute == minute;

  @override
  int get hashCode => Object.hash(hour, minute);

  @override
  String toString() => toStorage();
}
