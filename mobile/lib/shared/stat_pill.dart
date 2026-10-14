import 'package:flutter/material.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/app_theme.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';

/// Soft pill such as "Last 80 kg" or "Max 100 kg".
class StatPill extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    super.key,
    this.isHighlighted = false,
  });

  final String label;
  final String value;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.textStyles;
    return Semantics(
      label: '$label $value',
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          shape: const StadiumBorder(),
          color: isHighlighted ? colors.highlight : colors.surfaceMuted,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: TokenSpace.md,
            vertical: TokenSpace.xs + TokenSpace.xxs,
          ),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$label  ',
                  style: text.labelSmall?.copyWith(color: colors.textPrimary),
                ),
                TextSpan(
                  text: value,
                  style: text.labelMedium?.copyWith(
                    fontFeatures: AppTheme.tabularFigures,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
