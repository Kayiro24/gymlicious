import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/features/checkin/domain/check_in_entry.dart';
import 'package:gym_tracker/features/checkin/domain/weekly_goal.dart';

part 'check_in_log.freezed.dart';

/// Everything the check-in feature persists: one entry per day (unique by
/// construction) and the goal history.
@freezed
abstract class CheckInLog with _$CheckInLog {
  const factory({
    @Default(<CalendarDate, CheckInEntry>{})
    Map<CalendarDate, CheckInEntry> entries,
    @Default(WeeklyGoalHistory()) WeeklyGoalHistory goals,
  }) = _CheckInLog;

  const new _();

  CheckInEntry entryFor(CalendarDate date) =>
      entries[date] ?? CheckInEntry(date: date);

  /// Replaces the entry for its date, dropping it when it has become blank.
  CheckInLog withEntry(CheckInEntry entry) => copyWith(
    entries: {
      for (final MapEntry(:key, :value) in entries.entries)
        if (key != entry.date) key: value,
      if (!entry.isBlank) entry.date: entry,
    },
  );
}
