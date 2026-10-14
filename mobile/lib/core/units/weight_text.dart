import 'package:gym_tracker/core/units/number_format.dart';
import 'package:gym_tracker/core/units/units.dart';

abstract final class WeightText {
  static const displayStep = 0.1;

  /// Display value without the unit, rounded to 0.1.
  static String value(double kilograms, WeightUnit unit) =>
      NumberText.trimmed(UnitConversion.toDisplayWeight(kilograms, unit));

  /// "82.5 kg", or [bodyweightLabel] for a bodyweight set with no added load.
  static String withUnit(
    double kilograms,
    WeightUnit unit, {
    required bool isBodyweight,
    required String bodyweightLabel,
  }) {
    if (isBodyweight && kilograms == 0) {
      return bodyweightLabel;
    }
    final prefix = isBodyweight ? '+' : '';
    return '$prefix${value(kilograms, unit)} ${unit.name}';
  }
}
