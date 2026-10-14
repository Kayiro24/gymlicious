import 'package:gym_tracker/core/units/number_format.dart';
import 'package:gym_tracker/core/units/units.dart';
import 'package:gym_tracker/features/profile/domain/profile.dart';
import 'package:gym_tracker/features/profile/domain/profile_draft.dart';

abstract final class ProfileDrafts {
  /// Pre-fills the form from a saved profile in the user's display units.
  static ProfileDraft fromProfile(
    Profile profile, {
    required WeightUnit weightUnit,
    required HeightUnit heightUnit,
    required int? currentAge,
  }) {
    final (:feet, :inches) = UnitConversion.cmToFeetInches(profile.heightCm);
    return ProfileDraft(
      name: profile.name,
      gender: profile.gender,
      weight: NumberText.trimmed(
        UnitConversion.toDisplayWeight(profile.weightKg, weightUnit),
      ),
      heightCm: NumberText.trimmed(profile.heightCm),
      heightFeet: '$feet',
      heightInches: NumberText.trimmed(inches),
      dateOfBirth: profile.dateOfBirth,
      age: profile.dateOfBirth == null && currentAge != null
          ? '$currentAge'
          : '',
      usesAge: profile.dateOfBirth == null,
      weightUnit: weightUnit,
      heightUnit: heightUnit,
    );
  }
}
