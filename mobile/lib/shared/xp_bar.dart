import 'package:flutter/material.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/motion.dart';

/// Level pill plus a slim ember-to-gold bar towards the next level.
class XpBar extends StatelessWidget {
  const new({
    required this.level,
    required this.xpIntoLevel,
    required this.xpForLevel,
    super.key,
  });

  final int level;
  final int xpIntoLevel;

  /// XP between this level and the next.
  final int xpForLevel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final remaining = (xpForLevel - xpIntoLevel).clamp(0, xpForLevel);
    final fraction = xpForLevel == 0 ? 0.0 : xpIntoLevel / xpForLevel;
    final remainingText = l10n.xpToNextLevel(remaining, level + 1);
    return Semantics(
      label: '${l10n.xpLevel(level)}, $remainingText',
      container: true,
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                DecoratedBox(
                  decoration: ShapeDecoration(
                    shape: const StadiumBorder(),
                    color: colors.gold,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TokenSpace.md,
                      vertical: TokenSpace.xs,
                    ),
                    child: Text(
                      l10n.xpLevel(level),
                      style: context.textStyles.labelMedium?.copyWith(
                        color: colors.onGold,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: TokenSpace.md),
                Expanded(child: _Bar(fraction: fraction)),
              ],
            ),
            const SizedBox(height: TokenSpace.xs),
            Text(remainingText, style: context.textStyles.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const new({required this.fraction});

  final double fraction;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ClipRRect(
      borderRadius: BorderRadius.circular(TokenRadius.pill),
      child: SizedBox(
        height: TokenSpace.sm + TokenSpace.xxs,
        child: ColoredBox(
          color: colors.surfaceMuted,
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: fraction.clamp(0, 1).toDouble()),
            duration: AppMotion.of(context, TokenMotion.slow),
            curve: AppMotion.curve,
            builder: (context, value, _) => FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: colors.fireColors),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
