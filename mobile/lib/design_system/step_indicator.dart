import 'package:flutter/material.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/motion.dart';

/// "Step 2 of 4" with one segment per step; finished and current steps are
/// filled.
class StepIndicator extends StatelessWidget {
  const new({required this.current, required this.total, super.key});

  /// 1-based.
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final label = AppLocalizations.of(context)
        .stepIndicatorLabel(current, total);
    return Semantics(
      label: label,
      container: true,
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: context.textStyles.labelMedium?.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: TokenSpace.sm),
            Row(
              children: [
                for (var step = 1; step <= total; step++) ...[
                  if (step > 1) const SizedBox(width: TokenSpace.xs),
                  Expanded(
                    child: AnimatedContainer(
                      duration: AppMotion.of(context),
                      curve: AppMotion.curve,
                      height: TokenSpace.sm - TokenSpace.xxs,
                      decoration: ShapeDecoration(
                        shape: const StadiumBorder(),
                        color: step <= current
                            ? colors.accent
                            : colors.surfaceMuted,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
