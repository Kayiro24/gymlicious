// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileDto _$ProfileDtoFromJson(Map<String, dynamic> json) => ProfileDto(
  name: json['name'] as String,
  gender: json['gender'] as String,
  weightKg: (json['weightKg'] as num).toDouble(),
  heightCm: (json['heightCm'] as num).toDouble(),
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
  dob: json['dob'] as String?,
  age: (json['age'] as num?)?.toInt(),
  ageSetOn: json['ageSetOn'] as String?,
  photoFile: json['photoFile'] as String?,
);

Map<String, dynamic> _$ProfileDtoToJson(ProfileDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'gender': instance.gender,
      'dob': instance.dob,
      'age': instance.age,
      'ageSetOn': instance.ageSetOn,
      'weightKg': instance.weightKg,
      'heightCm': instance.heightCm,
      'photoFile': instance.photoFile,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
