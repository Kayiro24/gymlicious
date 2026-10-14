import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/features/checkin/domain/day_time.dart';

part 'check_in_entry.freezed.dart';

/// What the user set for one day. [done] is null when they never touched it,
/// so a logged session decides (D49).
@freezed
abstract class CheckInEntry with _$CheckInEntry {
  const factory({
    required CalendarDate date,
    bool? done,
    @Default('') String note,
    DayTime? time,
    int? durationMinutes,
    DateTime? updatedAt,
  }) = _CheckInEntry;

  const new _();

  /// Nothing left worth storing.
  bool get isBlank =>
      done == null && note.isEmpty && time == null && durationMinutes == null;
}
