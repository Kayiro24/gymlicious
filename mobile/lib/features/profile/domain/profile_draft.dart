import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/units/units.dart';
import 'package:gym_tracker/features/profile/domain/profile.dart';

part 'profile_draft.freezed.dart';

/// Raw form input, in the user's chosen units, before validation.
@freezed
abstract class ProfileDraft with _$ProfileDraft {
  const factory({
    @Default('') String name,
    Gender? gender,
    @Default('') String weight,
    @Default('') String heightCm,
    @Default('') String heightFeet,
    @Default('') String heightInches,
    CalendarDate? dateOfBirth,
    @Default('') String age,
    @Default(false) bool usesAge,
    @Default(WeightUnit.kg) WeightUnit weightUnit,
    @Default(HeightUnit.cm) HeightUnit heightUnit,
  }) = _ProfileDraft;

  /// Where a brand-new profile starts: feet and inches, 5 ft 7 in (170 cm).
  static const starterHeightCm = 170.0;

  static const starter = ProfileDraft(
    heightCm: '170',
    heightFeet: '5',
    heightInches: '7',
    heightUnit: HeightUnit.ftIn,
  );
}
