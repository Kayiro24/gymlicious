import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';

part 'exercise_stats.freezed.dart';

/// Max and last weight, always derived from history plus baselines.
@freezed
abstract class ExerciseStats with _$ExerciseStats {
  const factory({
    double? maxKg,
    CalendarDate? maxDate,
    double? lastKg,
    CalendarDate? lastDate,
  }) = _ExerciseStats;

  static const empty = ExerciseStats();
}
