abstract final class IsoDateTime {
  static const _minutesPerHour = 60;

  /// Local time with its UTC offset, e.g. `2026-10-12T17:00:00+05:30`, so a
  /// restored backup shows sessions at the wall-clock time they happened.
  static String format(DateTime dateTime) {
    final local = dateTime.toLocal();
    final offset = local.timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final totalMinutes = offset.inMinutes.abs();
    final hours = (totalMinutes ~/ _minutesPerHour).toString().padLeft(2, '0');
    final minutes = (totalMinutes % _minutesPerHour).toString().padLeft(2, '0');
    final wallClock = DateTime(
      local.year,
      local.month,
      local.day,
      local.hour,
      local.minute,
      local.second,
    ).toIso8601String().split('.').first;
    return '$wallClock$sign$hours:$minutes';
  }

  static DateTime parse(String value) => DateTime.parse(value).toLocal();

  static DateTime? tryParse(String? value) =>
      value == null ? null : DateTime.tryParse(value)?.toLocal();
}
