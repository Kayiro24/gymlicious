import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/units/number_format.dart';
import 'package:gym_tracker/core/units/units.dart';
import 'package:gym_tracker/features/profile/domain/profile_rules.dart';
import 'package:gym_tracker/features/profile/domain/profile_validator.dart';

abstract final class ProfileErrorText {
  static String of(
    AppLocalizations l10n,
    ProfileField field,
    ProfileProblem problem, {
    required WeightUnit weightUnit,
    required HeightUnit heightUnit,
  }) => switch ((field, problem)) {
    (_, ProfileProblem.required) => l10n.profileErrorRequired,
    (_, ProfileProblem.tooLong) => l10n.profileErrorNameTooLong,
    (_, ProfileProblem.inFuture) => l10n.profileErrorFutureDate,
    (ProfileField.height, ProfileProblem.invalidNumber)
        when heightUnit == HeightUnit.ftIn =>
      l10n.profileErrorHeightInches,
    (_, ProfileProblem.invalidNumber) => l10n.profileErrorInvalidNumber,
    (ProfileField.weight, ProfileProblem.outOfRange) =>
      l10n.profileErrorWeightRange(
        _weight(ProfileRules.minWeightKg, weightUnit),
        _weight(ProfileRules.maxWeightKg, weightUnit),
        weightUnit.name,
      ),
    (ProfileField.height, ProfileProblem.outOfRange) =>
      heightUnit == HeightUnit.cm
          ? l10n.profileErrorHeightRangeCm
          : l10n.profileErrorHeightRangeImperial,
    (_, ProfileProblem.outOfRange) => l10n.profileErrorAgeRange,
  };

  static String _weight(double kilograms, WeightUnit unit) =>
      NumberText.trimmed(UnitConversion.toDisplayWeight(kilograms, unit));
}
