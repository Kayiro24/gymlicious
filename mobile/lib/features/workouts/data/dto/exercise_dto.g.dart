// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExerciseDto _$ExerciseDtoFromJson(Map<String, dynamic> json) => ExerciseDto(
  id: json['id'] as String,
  name: json['name'] as String,
  muscleGroup: json['muscleGroup'] as String,
  equipment: json['equipment'] as String,
  isCustom: json['isCustom'] as bool? ?? false,
  archived: json['archived'] as bool? ?? false,
  baselineMaxKg: (json['baselineMaxKg'] as num?)?.toDouble(),
  baselineLastKg: (json['baselineLastKg'] as num?)?.toDouble(),
  baselineLastDate: json['baselineLastDate'] as String?,
  maxWeightKg: (json['maxWeightKg'] as num?)?.toDouble(),
  maxWeightDate: json['maxWeightDate'] as String?,
  lastWeightKg: (json['lastWeightKg'] as num?)?.toDouble(),
  lastWeightDate: json['lastWeightDate'] as String?,
  notes: json['notes'] as String? ?? '',
);

Map<String, dynamic> _$ExerciseDtoToJson(ExerciseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'muscleGroup': instance.muscleGroup,
      'equipment': instance.equipment,
      'isCustom': instance.isCustom,
      'archived': instance.archived,
      'baselineMaxKg': instance.baselineMaxKg,
      'baselineLastKg': instance.baselineLastKg,
      'baselineLastDate': instance.baselineLastDate,
      'maxWeightKg': instance.maxWeightKg,
      'maxWeightDate': instance.maxWeightDate,
      'lastWeightKg': instance.lastWeightKg,
      'lastWeightDate': instance.lastWeightDate,
      'notes': instance.notes,
    };
