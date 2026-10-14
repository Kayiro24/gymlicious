import 'package:flutter/material.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// A day of a split; "up next" is marked by an icon as well as colour.
class SplitDayChip extends StatelessWidget {
  const new({
    required this.name,
    required this.detail,
    super.key,
    this.isUpNext = false,
    this.isRest = false,
    this.onTap,
  });

  final String name;
  final String detail;
  final bool isUpNext;
  final bool isRest;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final background = isUpNext ? colors.accentSoft : colors.surfaceMuted;
    return Semantics(
      button: onTap != null,
      selected: isUpNext,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(TokenRadius.input),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(TokenRadius.input),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: TokenLayout.minTouchTarget + TokenSpace.lg,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TokenSpace.lg,
                vertical: TokenSpace.md,
              ),
              child: Row(
                children: [
                  Icon(
                    isRest
                        ? LucideIcons.moon
                        : isUpNext
                        ? LucideIcons.circlePlay
                        : LucideIcons.dumbbell,
                    color: isUpNext ? colors.accent : colors.textSecondary,
                  ),
                  const SizedBox(width: TokenSpace.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: context.textStyles.titleMedium),
                        Text(detail, style: context.textStyles.bodySmall),
                      ],
                    ),
                  ),
                  if (onTap != null)
                    Icon(LucideIcons.chevronRight, color: colors.textSecondary),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
