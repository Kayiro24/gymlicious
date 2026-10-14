import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';

part 'profile.freezed.dart';

enum Gender {
  male,
  female,
  other,
  preferNotToSay('prefer_not_to_say');

  new([this._storageName]);

  final String? _storageName;

  String get storageName => _storageName ?? name;

  static Gender? tryParse(String? value) {
    for (final gender in values) {
      if (gender.storageName == value) {
        return gender;
      }
    }
    return null;
  }
}

/// Either [dateOfBirth] or [age] + [ageSetOn] is set, never both.
@freezed
abstract class Profile with _$Profile {
  const factory({
    required String name,
    required Gender gender,
    required double weightKg,
    required double heightCm,
    required DateTime createdAt,
    required DateTime updatedAt,
    CalendarDate? dateOfBirth,
    int? age,
    CalendarDate? ageSetOn,
    @Default(false) bool hasPhoto,
  }) = _Profile;
}
