import 'package:flutter/material.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// A milestone badge. Earned: gold medallion and the date. Locked: muted,
/// with a lock mark and progress towards it.
class BadgeTile extends StatelessWidget {
  const new({
    required this.icon,
    required this.title,
    required this.detail,
    required this.isEarned,
    super.key,
    this.progress = 0,
    this.onTap,
  });

  final IconData icon;
  final String title;

  /// "Earned 14 Oct" or "7 of 10 workouts".
  final String detail;
  final bool isEarned;
  final double progress;
  final VoidCallback? onTap;

  static const double _medallion = TokenSpace.xxxl + TokenSpace.sm;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    return Semantics(
      label: isEarned
          ? '$title, $detail'
          : '$title, ${l10n.badgeLocked}, $detail',
      container: true,
      child: ExcludeSemantics(
        child: AppCard(
          onTap: onTap,
          padding: const EdgeInsets.all(TokenSpace.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: _medallion,
                    height: _medallion,
                    decoration: ShapeDecoration(
                      shape: const CircleBorder(),
                      gradient: isEarned
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [colors.gold, colors.ember],
                            )
                          : null,
                      color: isEarned ? null : colors.surfaceMuted,
                    ),
                    child: Icon(
                      icon,
                      size: _medallion / 2,
                      color: isEarned ? colors.onGold : colors.textSecondary,
                    ),
                  ),
                  if (!isEarned)
                    Positioned(
                      right: -TokenSpace.xxs,
                      bottom: -TokenSpace.xxs,
                      child: Icon(
                        LucideIcons.lock,
                        size: TokenSpace.lg,
                        color: colors.textSecondary,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: TokenSpace.md),
              Text(
                title,
                textAlign: TextAlign.center,
                style: context.textStyles.titleMedium,
              ),
              const SizedBox(height: TokenSpace.xs),
              Text(
                detail,
                textAlign: TextAlign.center,
                style: context.textStyles.bodySmall,
              ),
              if (!isEarned && progress > 0) ...[
                const SizedBox(height: TokenSpace.sm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(TokenRadius.pill),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0, 1).toDouble(),
                    minHeight: TokenSpace.xs + TokenSpace.xxs,
                    color: colors.gold,
                    backgroundColor: colors.surfaceMuted,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
