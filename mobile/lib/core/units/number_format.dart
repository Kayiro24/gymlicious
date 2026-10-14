abstract final class NumberText {
  /// Rounds to [step] and trims trailing zeros: 82.50 -> "82.5", 80.0 -> "80".
  static String trimmed(double value, {double step = 0.1}) {
    final rounded = (value / step).round() * step;
    final fixed = rounded.toStringAsFixed(2);
    return fixed.replaceFirst(RegExp(r'\.?0+$'), '');
  }

  /// Parses user input, accepting a comma as the decimal separator.
  static double? parseDecimal(String input) {
    final normalised = input.trim().replaceAll(',', '.');
    if (normalised.isEmpty) {
      return null;
    }
    final value = double.tryParse(normalised);
    return value != null && value.isFinite ? value : null;
  }
}
