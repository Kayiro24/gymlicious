import 'package:flutter/material.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/motion.dart';

/// Selectable pill. Selection is shown by fill and a check icon, not colour
/// alone.
class AppChip extends StatelessWidget {
  const new({
    required this.label,
    required this.isSelected,
    required this.onSelected,
    super.key,
  });

  final String label;
  final bool isSelected;
  final ValueChanged<bool>? onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      selected: isSelected,
      button: true,
      child: InkWell(
        onTap: onSelected == null ? null : () => onSelected!(!isSelected),
        customBorder: const StadiumBorder(),
        child: AnimatedContainer(
          duration: AppMotion.of(context),
          curve: AppMotion.curve,
          constraints: const BoxConstraints(
            minHeight: TokenLayout.minTouchTarget,
          ),
          padding: const EdgeInsets.symmetric(horizontal: TokenSpace.lg),
          decoration: ShapeDecoration(
            shape: const StadiumBorder(),
            color: isSelected ? colors.accentSoft : colors.surfaceMuted,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected) ...[
                Icon(
                  Icons.check_rounded,
                  size: TokenSpace.lg,
                  color: colors.textPrimary,
                ),
                const SizedBox(width: TokenSpace.xs),
              ],
              Flexible(
                child: Text(
                  label,
                  style: context.textStyles.labelMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.w700 : null,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
