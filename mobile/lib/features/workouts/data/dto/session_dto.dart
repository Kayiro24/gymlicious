import 'package:json_annotation/json_annotation.dart';

part 'session_dto.g.dart';

@JsonSerializable()
class SetDto {
  const new({
    required this.weightKg,
    this.reps,
    this.isWarmup = false,
    this.done = false,
  });

  factory fromJson(Map<String, dynamic> json) => _$SetDtoFromJson(json);

  final double weightKg;
  final int? reps;
  final bool isWarmup;
  final bool done;

  Map<String, dynamic> toJson() => _$SetDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SessionEntryDto {
  const new({
    required this.exerciseId,
    required this.exerciseNameSnapshot,
    this.sets = const [],
    this.note = '',
  });

  factory fromJson(Map<String, dynamic> json) =>
      _$SessionEntryDtoFromJson(json);

  final String exerciseId;
  final String exerciseNameSnapshot;
  final List<SetDto> sets;
  final String note;

  Map<String, dynamic> toJson() => _$SessionEntryDtoToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: true)
class SessionDto {
  const new({
    required this.id,
    required this.startedAt,
    this.endedAt,
    this.splitId,
    this.dayId,
    this.dayNameSnapshot,
    this.entries = const [],
    this.note = '',
  });

  factory fromJson(Map<String, dynamic> json) => _$SessionDtoFromJson(json);

  final String id;
  final String startedAt;
  final String? endedAt;
  final String? splitId;
  final String? dayId;
  final String? dayNameSnapshot;
  final List<SessionEntryDto> entries;
  final String note;

  Map<String, dynamic> toJson() => _$SessionDtoToJson(this);
}
