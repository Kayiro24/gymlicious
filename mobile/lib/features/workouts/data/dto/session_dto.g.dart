// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetDto _$SetDtoFromJson(Map<String, dynamic> json) => SetDto(
  weightKg: (json['weightKg'] as num).toDouble(),
  reps: (json['reps'] as num?)?.toInt(),
  isWarmup: json['isWarmup'] as bool? ?? false,
  done: json['done'] as bool? ?? false,
);

Map<String, dynamic> _$SetDtoToJson(SetDto instance) => <String, dynamic>{
  'weightKg': instance.weightKg,
  'reps': instance.reps,
  'isWarmup': instance.isWarmup,
  'done': instance.done,
};

SessionEntryDto _$SessionEntryDtoFromJson(Map<String, dynamic> json) =>
    SessionEntryDto(
      exerciseId: json['exerciseId'] as String,
      exerciseNameSnapshot: json['exerciseNameSnapshot'] as String,
      sets:
          (json['sets'] as List<dynamic>?)
              ?.map((e) => SetDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      note: json['note'] as String? ?? '',
    );

Map<String, dynamic> _$SessionEntryDtoToJson(SessionEntryDto instance) =>
    <String, dynamic>{
      'exerciseId': instance.exerciseId,
      'exerciseNameSnapshot': instance.exerciseNameSnapshot,
      'sets': instance.sets.map((e) => e.toJson()).toList(),
      'note': instance.note,
    };

SessionDto _$SessionDtoFromJson(Map<String, dynamic> json) => SessionDto(
  id: json['id'] as String,
  startedAt: json['startedAt'] as String,
  endedAt: json['endedAt'] as String?,
  splitId: json['splitId'] as String?,
  dayId: json['dayId'] as String?,
  dayNameSnapshot: json['dayNameSnapshot'] as String?,
  entries:
      (json['entries'] as List<dynamic>?)
          ?.map((e) => SessionEntryDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  note: json['note'] as String? ?? '',
);

Map<String, dynamic> _$SessionDtoToJson(SessionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startedAt': instance.startedAt,
      'endedAt': instance.endedAt,
      'splitId': instance.splitId,
      'dayId': instance.dayId,
      'dayNameSnapshot': instance.dayNameSnapshot,
      'entries': instance.entries.map((e) => e.toJson()).toList(),
      'note': instance.note,
    };
