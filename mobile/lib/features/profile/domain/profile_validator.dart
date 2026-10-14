import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/units/number_format.dart';
import 'package:gym_tracker/core/units/units.dart';
import 'package:gym_tracker/features/profile/domain/profile.dart';
import 'package:gym_tracker/features/profile/domain/profile_draft.dart';
import 'package:gym_tracker/features/profile/domain/profile_rules.dart';

enum ProfileField { name, gender, weight, height, dateOfBirth, age }

enum ProfileProblem { required, tooLong, invalidNumber, outOfRange, inFuture }

/// Validated profile values in canonical units.
typedef ProfileValues = ({
  String name,
  Gender gender,
  double weightKg,
  double heightCm,
  CalendarDate? dateOfBirth,
  int? age,
});

class ProfileValidation {
  const new(this.errors, this.values);

  /// Errors in form order, so the first key is the first invalid field.
  final Map<ProfileField, ProfileProblem> errors;
  final ProfileValues? values;

  bool get isValid => errors.isEmpty;
}

abstract final class ProfileValidator {
  static ProfileValidation validate(ProfileDraft draft, CalendarDate today) {
    final errors = <ProfileField, ProfileProblem>{};

    final name = draft.name.trim();
    if (name.isEmpty) {
      errors[ProfileField.name] = ProfileProblem.required;
    } else if (name.length > ProfileRules.nameMaxLength) {
      errors[ProfileField.name] = ProfileProblem.tooLong;
    }

    if (draft.gender == null) {
      errors[ProfileField.gender] = ProfileProblem.required;
    }

    final weightKg = _weightKg(draft, errors);
    final heightCm = _heightCm(draft, errors);
    final (dateOfBirth, age) = _ageInputs(draft, today, errors);

    if (errors.isNotEmpty) {
      return ProfileValidation(_inFormOrder(errors), null);
    }
    return ProfileValidation(const {}, (
      name: name,
      gender: draft.gender!,
      weightKg: weightKg!,
      heightCm: heightCm!,
      dateOfBirth: dateOfBirth,
      age: age,
    ));
  }

  static double? _weightKg(
    ProfileDraft draft,
    Map<ProfileField, ProfileProblem> errors,
  ) {
    if (draft.weight.trim().isEmpty) {
      errors[ProfileField.weight] = ProfileProblem.required;
      return null;
    }
    final value = NumberText.parseDecimal(draft.weight);
    if (value == null) {
      errors[ProfileField.weight] = ProfileProblem.invalidNumber;
      return null;
    }
    final kilograms = UnitConversion.fromDisplayWeight(value, draft.weightUnit);
    if (!_isWithin(
      kilograms,
      ProfileRules.minWeightKg,
      ProfileRules.maxWeightKg,
    )) {
      errors[ProfileField.weight] = ProfileProblem.outOfRange;
      return null;
    }
    return kilograms;
  }

  static double? _heightCm(
    ProfileDraft draft,
    Map<ProfileField, ProfileProblem> errors,
  ) {
    final double? centimetres;
    if (draft.heightUnit == HeightUnit.cm) {
      if (draft.heightCm.trim().isEmpty) {
        errors[ProfileField.height] = ProfileProblem.required;
        return null;
      }
      centimetres = NumberText.parseDecimal(draft.heightCm);
    } else {
      if (draft.heightFeet.trim().isEmpty) {
        errors[ProfileField.height] = ProfileProblem.required;
        return null;
      }
      final feet = int.tryParse(draft.heightFeet.trim());
      final inches = draft.heightInches.trim().isEmpty
          ? 0.0
          : NumberText.parseDecimal(draft.heightInches);
      final isValidInches =
          inches != null &&
          inches >= 0 &&
          inches < UnitConversion.inchesPerFoot;
      centimetres = feet == null || !isValidInches
          ? null
          : UnitConversion.feetInchesToCm(feet, inches);
    }
    if (centimetres == null) {
      errors[ProfileField.height] = ProfileProblem.invalidNumber;
      return null;
    }
    if (!_isWithin(
      centimetres,
      ProfileRules.minHeightCm,
      ProfileRules.maxHeightCm,
    )) {
      errors[ProfileField.height] = ProfileProblem.outOfRange;
      return null;
    }
    return centimetres;
  }

  static (CalendarDate?, int?) _ageInputs(
    ProfileDraft draft,
    CalendarDate today,
    Map<ProfileField, ProfileProblem> errors,
  ) {
    if (draft.usesAge) {
      if (draft.age.trim().isEmpty) {
        errors[ProfileField.age] = ProfileProblem.required;
        return (null, null);
      }
      final age = int.tryParse(draft.age.trim());
      if (age == null) {
        errors[ProfileField.age] = ProfileProblem.invalidNumber;
        return (null, null);
      }
      if (age < ProfileRules.minAge || age > ProfileRules.maxAge) {
        errors[ProfileField.age] = ProfileProblem.outOfRange;
        return (null, null);
      }
      return (null, age);
    }
    final dateOfBirth = draft.dateOfBirth;
    if (dateOfBirth == null) {
      errors[ProfileField.dateOfBirth] = ProfileProblem.required;
      return (null, null);
    }
    if (dateOfBirth.isAfter(today)) {
      errors[ProfileField.dateOfBirth] = ProfileProblem.inFuture;
      return (null, null);
    }
    final age = ProfileRules.wholeYearsBetween(dateOfBirth, today);
    if (age < ProfileRules.minAge || age > ProfileRules.maxAge) {
      errors[ProfileField.dateOfBirth] = ProfileProblem.outOfRange;
      return (null, null);
    }
    return (dateOfBirth, null);
  }

  static bool _isWithin(double value, double min, double max) =>
      value >= min && value <= max;

  static Map<ProfileField, ProfileProblem> _inFormOrder(
    Map<ProfileField, ProfileProblem> errors,
  ) => {for (final field in ProfileField.values) field: ?errors[field]};
}
