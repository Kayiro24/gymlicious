import 'package:flutter/material.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/core/units/units.dart';
import 'package:gym_tracker/shared/unit_field.dart';

/// Height in centimetres, or feet and inches side by side (wrapping on
/// narrow widths and large text).
class HeightField extends StatelessWidget {
  const new({
    required this.label,
    required this.unit,
    required this.centimetres,
    required this.feet,
    required this.inches,
    required this.onChanged,
    super.key,
    this.errorText,
    this.focusNode,
  });

  final String label;
  final HeightUnit unit;
  final TextEditingController centimetres;
  final TextEditingController feet;
  final TextEditingController inches;
  final VoidCallback onChanged;
  final String? errorText;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (unit == HeightUnit.cm) {
      return UnitField(
        label: label,
        unitLabel: l10n.unitCm,
        controller: centimetres,
        focusNode: focusNode,
        errorText: errorText,
        onChanged: (_) => onChanged(),
      );
    }
    final error = errorText;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final fieldWidth =
                constraints.maxWidth >= TokenLayout.compactMaxWidth / 2
                ? (constraints.maxWidth - TokenSpace.md) / 2
                : constraints.maxWidth;
            return Wrap(
              spacing: TokenSpace.md,
              runSpacing: TokenSpace.md,
              children: [
                SizedBox(
                  width: fieldWidth,
                  child: UnitField(
                    label: '$label · ${l10n.heightFeet}',
                    unitLabel: l10n.unitFt,
                    controller: feet,
                    focusNode: focusNode,
                    allowsDecimals: false,
                    onChanged: (_) => onChanged(),
                  ),
                ),
                SizedBox(
                  width: fieldWidth,
                  child: UnitField(
                    label: l10n.heightInches,
                    unitLabel: l10n.unitIn,
                    controller: inches,
                    isRequired: false,
                    onChanged: (_) => onChanged(),
                  ),
                ),
              ],
            );
          },
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(
              top: TokenSpace.xs,
              left: TokenSpace.lg,
            ),
            child: Text(
              error,
              style: context.textStyles.bodySmall?.copyWith(
                color: context.colors.danger,
              ),
            ),
          ),
      ],
    );
  }
}
