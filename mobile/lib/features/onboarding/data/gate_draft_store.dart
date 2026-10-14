import 'dart:convert';

import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/storage/file_gateway.dart';
import 'package:gym_tracker/core/storage/json_cast.dart';
import 'package:gym_tracker/core/units/units.dart';
import 'package:gym_tracker/features/profile/profile_domain.dart';

/// Keeps a half-filled gate form so killing the app mid-form loses nothing.
class GateDraftStore {
  const new(this.files);

  static const fileName = 'onboarding_draft.json';

  final FileGateway files;

  Future<ProfileDraft> load() async {
    try {
      final text = await files.readString(fileName);
      if (text == null) {
        return const ProfileDraft();
      }
      final json = JsonCast.object(jsonDecode(text), fileName);
      final dateOfBirth = json['dateOfBirth'] as String?;
      return ProfileDraft(
        name: json['name'] as String? ?? '',
        gender: Gender.tryParse(json['gender'] as String?),
        weight: json['weight'] as String? ?? '',
        heightCm: json['heightCm'] as String? ?? '',
        heightFeet: json['heightFeet'] as String? ?? '',
        heightInches: json['heightInches'] as String? ?? '',
        dateOfBirth: dateOfBirth == null
            ? null
            : CalendarDate.parse(dateOfBirth),
        age: json['age'] as String? ?? '',
        usesAge: json['usesAge'] as bool? ?? false,
        weightUnit: WeightUnit.fromName(json['weightUnit'] as String?),
        heightUnit: HeightUnit.fromName(json['heightUnit'] as String?),
      );
    } on Object {
      return const ProfileDraft();
    }
  }

  Future<void> save(ProfileDraft draft) => files.writeString(
    fileName,
    jsonEncode({
      'name': draft.name,
      'gender': draft.gender?.storageName,
      'weight': draft.weight,
      'heightCm': draft.heightCm,
      'heightFeet': draft.heightFeet,
      'heightInches': draft.heightInches,
      'dateOfBirth': draft.dateOfBirth?.toIso(),
      'age': draft.age,
      'usesAge': draft.usesAge,
      'weightUnit': draft.weightUnit.name,
      'heightUnit': draft.heightUnit.name,
    }),
  );

  Future<void> delete() => files.delete(fileName);
}
