import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/features/profile/domain/profile.dart';

abstract final class ProfileRules {
  static const nameMaxLength = 40;
  static const minWeightKg = 20.0;
  static const maxWeightKg = 400.0;
  static const minHeightCm = 90.0;
  static const maxHeightCm = 250.0;
  static const minAge = 13;
  static const maxAge = 100;
  static const _centimetresPerMetre = 100;

  /// Whole years from [from] to [to], counting a birthday only once reached.
  static int wholeYearsBetween(CalendarDate from, CalendarDate to) {
    var years = to.year - from.year;
    final hasReachedAnniversary =
        to.month > from.month || (to.month == from.month && to.day >= from.day);
    if (!hasReachedAnniversary) {
      years -= 1;
    }
    return years;
  }

  /// Age from the date of birth, or the entered age plus the years elapsed
  /// since it was entered.
  static int? ageOf(Profile profile, CalendarDate today) {
    final dateOfBirth = profile.dateOfBirth;
    if (dateOfBirth != null) {
      return wholeYearsBetween(dateOfBirth, today);
    }
    final age = profile.age;
    final ageSetOn = profile.ageSetOn;
    if (age == null || ageSetOn == null) {
      return null;
    }
    return age + wholeYearsBetween(ageSetOn, today);
  }

  static double bodyMassIndex(double weightKg, double heightCm) {
    final metres = heightCm / _centimetresPerMetre;
    return weightKg / (metres * metres);
  }

  static bool isValid(Profile profile, CalendarDate today) {
    final age = ageOf(profile, today);
    final name = profile.name.trim();
    return name.isNotEmpty &&
        name.length <= nameMaxLength &&
        profile.weightKg >= minWeightKg &&
        profile.weightKg <= maxWeightKg &&
        profile.heightCm >= minHeightCm &&
        profile.heightCm <= maxHeightCm &&
        age != null &&
        age >= minAge &&
        age <= maxAge;
  }
}
