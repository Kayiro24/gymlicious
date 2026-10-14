import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/units/number_format.dart';
import 'package:gym_tracker/core/units/units.dart';
import 'package:gym_tracker/core/units/weight_stepper.dart';
import 'package:gym_tracker/core/units/weight_text.dart';
import 'package:gym_tracker/features/settings/settings.dart';

/// Weights in the user's display unit; stored values are always kg.
class WeightFormat {
  const new({
    required this.unit,
    required this.increment,
    required this.bodyweightLabel,
    required this.noneLabel,
  });

  factory of(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsControllerProvider);
    return WeightFormat(
      unit: settings.weightUnit,
      increment: settings.weightIncrement,
      bodyweightLabel: l10n.commonBodyweight,
      noneLabel: l10n.statNone,
    );
  }

  final WeightUnit unit;

  /// Stepper size in [unit].
  final double increment;
  final String bodyweightLabel;
  final String noneLabel;

  String withUnit(double? kilograms, {bool isBodyweight = false}) =>
      kilograms == null
      ? noneLabel
      : WeightText.withUnit(
          kilograms,
          unit,
          isBodyweight: isBodyweight,
          bodyweightLabel: bodyweightLabel,
        );

  /// Plain number for an input field.
  String input(double kilograms) => WeightText.value(kilograms, unit);

  double? parse(String text) {
    final value = NumberText.parseDecimal(text);
    return value == null || value < 0
        ? null
        : UnitConversion.fromDisplayWeight(value, unit);
  }

  /// One stepper press from [kilograms] in the user's increment.
  double step(double kilograms, {required bool isUp}) => WeightStepper.step(
    kilograms,
    unit: unit,
    increment: increment,
    isUp: isUp,
  );
}
