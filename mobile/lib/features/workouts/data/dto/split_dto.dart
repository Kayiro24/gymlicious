import 'package:json_annotation/json_annotation.dart';

part 'split_dto.g.dart';

@JsonSerializable()
class SplitDayDto {
  const new({
    required this.id,
    required this.name,
    required this.order,
    this.isRest = false,
    this.exerciseIds = const [],
  });

  factory fromJson(Map<String, dynamic> json) => _$SplitDayDtoFromJson(json);

  final String id;
  final String name;
  final int order;
  final bool isRest;
  final List<String> exerciseIds;

  Map<String, dynamic> toJson() => _$SplitDayDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SplitDto {
  const new({
    required this.id,
    required this.name,
    this.isPreset = false,
    this.days = const [],
  });

  factory fromJson(Map<String, dynamic> json) => _$SplitDtoFromJson(json);

  final String id;
  final String name;
  final bool isPreset;
  final List<SplitDayDto> days;

  Map<String, dynamic> toJson() => _$SplitDtoToJson(this);
}
