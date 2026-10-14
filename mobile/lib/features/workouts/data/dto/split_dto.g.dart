// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'split_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SplitDayDto _$SplitDayDtoFromJson(Map<String, dynamic> json) => SplitDayDto(
  id: json['id'] as String,
  name: json['name'] as String,
  order: (json['order'] as num).toInt(),
  isRest: json['isRest'] as bool? ?? false,
  exerciseIds:
      (json['exerciseIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$SplitDayDtoToJson(SplitDayDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'order': instance.order,
      'isRest': instance.isRest,
      'exerciseIds': instance.exerciseIds,
    };

SplitDto _$SplitDtoFromJson(Map<String, dynamic> json) => SplitDto(
  id: json['id'] as String,
  name: json['name'] as String,
  isPreset: json['isPreset'] as bool? ?? false,
  days:
      (json['days'] as List<dynamic>?)
          ?.map((e) => SplitDayDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$SplitDtoToJson(SplitDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'isPreset': instance.isPreset,
  'days': instance.days.map((e) => e.toJson()).toList(),
};
