import 'package:json_annotation/json_annotation.dart';

part 'profile_dto.g.dart';

@JsonSerializable(includeIfNull: true)
class ProfileDto {
  const new({
    required this.name,
    required this.gender,
    required this.weightKg,
    required this.heightCm,
    required this.createdAt,
    required this.updatedAt,
    this.dob,
    this.age,
    this.ageSetOn,
    this.photoFile,
  });

  factory fromJson(Map<String, dynamic> json) => _$ProfileDtoFromJson(json);

  final String name;
  final String gender;
  final String? dob;
  final int? age;
  final String? ageSetOn;
  final double weightKg;
  final double heightCm;
  final String? photoFile;
  final String createdAt;
  final String updatedAt;

  Map<String, dynamic> toJson() => _$ProfileDtoToJson(this);
}
