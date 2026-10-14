import 'package:gym_tracker/core/units/units.dart';

abstract final class WeightStepper {
  static const _epsilon = 1e-6;

  /// One +/− press in the display unit: moves one [increment] when already
  /// on the increment grid, otherwise snaps to the nearest grid point in that
  /// direction. Never goes below zero. Input and output are kilograms.
  static double step(
    double kilograms, {
    required WeightUnit unit,
    required double increment,
    required bool isUp,
  }) {
    final grid = UnitConversion.toDisplayWeight(kilograms, unit) / increment;
    final isOnGrid = (grid - grid.round()).abs() < _epsilon;
    final steps = isOnGrid
        ? grid.round() + (isUp ? 1 : -1)
        : (isUp ? grid.ceil() : grid.floor());
    final display = steps < 0 ? 0.0 : steps * increment;
    return UnitConversion.fromDisplayWeight(display, unit);
  }
}
