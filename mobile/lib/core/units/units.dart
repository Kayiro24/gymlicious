enum WeightUnit {
  kg,
  lb;

  static WeightUnit fromName(String? name) =>
      WeightUnit.values.asNameMap()[name] ?? WeightUnit.kg;

  double get defaultIncrement => switch (this) {
    WeightUnit.kg => 2.5,
    WeightUnit.lb => 5,
  };
}

enum HeightUnit {
  cm,
  ftIn;

  static HeightUnit fromName(String? name) =>
      HeightUnit.values.asNameMap()[name] ?? HeightUnit.cm;
}

/// Feet and whole-or-fractional inches, e.g. 5 ft 10.5 in.
typedef FeetInches = ({int feet, double inches});

abstract final class UnitConversion {
  static const kilogramsPerPound = 0.45359237;
  static const centimetresPerInch = 2.54;
  static const inchesPerFoot = 12;

  static double kgToLb(double kilograms) => kilograms / kilogramsPerPound;

  static double lbToKg(double pounds) => pounds * kilogramsPerPound;

  static double toDisplayWeight(double kilograms, WeightUnit unit) =>
      unit == WeightUnit.kg ? kilograms : kgToLb(kilograms);

  static double fromDisplayWeight(double value, WeightUnit unit) =>
      unit == WeightUnit.kg ? value : lbToKg(value);

  static FeetInches cmToFeetInches(double centimetres) {
    final totalInches = centimetres / centimetresPerInch;
    var feet = totalInches ~/ inchesPerFoot;
    var inches = _roundTo(totalInches - feet * inchesPerFoot, 0.5);
    if (inches >= inchesPerFoot) {
      feet += 1;
      inches -= inchesPerFoot;
    }
    return (feet: feet, inches: inches);
  }

  static double feetInchesToCm(int feet, double inches) =>
      (feet * inchesPerFoot + inches) * centimetresPerInch;

  static double _roundTo(double value, double step) =>
      (value / step).round() * step;
}
