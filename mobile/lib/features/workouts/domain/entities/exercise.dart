import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/features/workouts/domain/entities/exercise_enums.dart';

part 'exercise.freezed.dart';

@freezed
abstract class Exercise with _$Exercise {
  const factory({
    required String id,
    required String name,
    required MuscleGroup muscleGroup,
    required Equipment equipment,
    @Default(false) bool isCustom,
    @Default(false) bool isArchived,
    double? baselineMaxKg,
    double? baselineLastKg,
    CalendarDate? baselineLastDate,
    @Default('') String notes,
  }) = _Exercise;

  const new _();

  bool get isBodyweight => equipment == Equipment.bodyweight;
}
