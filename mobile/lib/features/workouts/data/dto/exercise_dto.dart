import 'package:json_annotation/json_annotation.dart';

part 'exercise_dto.g.dart';

@JsonSerializable(includeIfNull: true)
class ExerciseDto {
  const new({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.equipment,
    this.isCustom = false,
    this.archived = false,
    this.baselineMaxKg,
    this.baselineLastKg,
    this.baselineLastDate,
    this.maxWeightKg,
    this.maxWeightDate,
    this.lastWeightKg,
    this.lastWeightDate,
    this.notes = '',
  });

  factory fromJson(Map<String, dynamic> json) => _$ExerciseDtoFromJson(json);

  final String id;
  final String name;
  final String muscleGroup;
  final String equipment;
  final bool isCustom;
  final bool archived;
  final double? baselineMaxKg;
  final double? baselineLastKg;
  final String? baselineLastDate;

  /// Cached for readers of the raw file; recomputed from sessions on load.
  final double? maxWeightKg;
  final String? maxWeightDate;
  final double? lastWeightKg;
  final String? lastWeightDate;
  final String notes;

  Map<String, dynamic> toJson() => _$ExerciseDtoToJson(this);
}
