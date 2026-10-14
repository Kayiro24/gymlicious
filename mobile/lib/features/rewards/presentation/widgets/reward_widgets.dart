import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_card.dart';
import 'package:gym_tracker/features/rewards/domain/badges.dart';
import 'package:gym_tracker/features/rewards/domain/rewards_record.dart';
import 'package:gym_tracker/features/rewards/presentation/badge_text.dart';
import 'package:gym_tracker/features/rewards/presentation/state/rewards_providers.dart';
import 'package:gym_tracker/shared/badge_tile.dart';
import 'package:gym_tracker/shared/xp_bar.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Current level and progress, from derived XP.
class LevelBar extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final level = ref.watch(rewardsSummaryProvider.select((s) => s.level));
    return XpBar(
      level: level.level,
      xpIntoLevel: level.xpIntoLevel,
      xpForLevel: level.xpForLevel,
    );
  }
}

/// "3 more workouts to earn 10 workouts", or a quiet note when everything
/// is earned.
class NextBadgeTeaser extends ConsumerWidget {
  const new({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final next = ref.watch(nextBadgeProvider);
    final progress = next == null ? 1.0 : next.current / next.kind.threshold;
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(TokenSpace.lg),
      child: Row(
        children: [
          Container(
            width: TokenSpace.xxxl,
            height: TokenSpace.xxxl,
            decoration: ShapeDecoration(
              shape: const CircleBorder(),
              color: next == null ? colors.gold : colors.surfaceMuted,
            ),
            child: Icon(
              next == null ? LucideIcons.crown : BadgeText.icon(next.kind),
              color: next == null ? colors.onGold : colors.textSecondary,
            ),
          ),
          const SizedBox(width: TokenSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.homeNextBadge, style: context.textStyles.labelMedium),
                const SizedBox(height: TokenSpace.xxs),
                Text(
                  next == null
                      ? l10n.homeAllBadges
                      : BadgeText.next(l10n, next),
                  style: context.textStyles.bodyMedium,
                ),
                const SizedBox(height: TokenSpace.sm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(TokenRadius.pill),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: TokenSpace.xs + TokenSpace.xxs,
                    color: colors.gold,
                    backgroundColor: colors.surfaceMuted,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: TokenSpace.sm),
            Icon(LucideIcons.chevronRight, color: colors.textSecondary),
          ],
        ],
      ),
    );
  }
}

/// All badges as tiles, earned first in catalogue order.
class BadgeGrid extends ConsumerWidget {
  const new({super.key, this.limit});

  /// Shows only the first few (earned first) when set.
  final int? limit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final record = ref.watch(rewardsControllerProvider);
    final metrics = ref.watch(rewardsSummaryProvider.select((s) => s.metrics));
    final kinds = [
      ...BadgeKind.values.where((kind) => record.earnedIds.contains(kind.id)),
      ...BadgeKind.values.where((kind) => !record.earnedIds.contains(kind.id)),
    ].take(limit ?? BadgeKind.values.length).toList();
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = (constraints.maxWidth / _tileWidth).floor().clamp(2, 4);
        final width =
            (constraints.maxWidth - (columns - 1) * TokenSpace.md) / columns;
        return Wrap(
          spacing: TokenSpace.md,
          runSpacing: TokenSpace.md,
          children: [
            for (final kind in kinds)
              SizedBox(
                width: width,
                child: _tile(
                  l10n,
                  locale,
                  kind,
                  record.badge(kind.id),
                  metrics,
                ),
              ),
          ],
        );
      },
    );
  }

  static const double _tileWidth = 160;

  static Widget _tile(
    AppLocalizations l10n,
    String locale,
    BadgeKind kind,
    EarnedBadge? earned,
    BadgeMetrics metrics,
  ) {
    final title = BadgeText.title(l10n, kind);
    final icon = BadgeText.icon(kind);
    if (earned != null) {
      final date = DateFormat.MMMd(locale)
          .format(earned.earnedAt.toLocalDateTime());
      return BadgeTile(
        icon: icon,
        title: title,
        detail: l10n.badgeEarnedOn(date),
        isEarned: true,
      );
    }
    final progress = Badges.progressOf(kind, metrics);
    return BadgeTile(
      icon: icon,
      title: title,
      detail: l10n.badgeProgress(progress.current, kind.threshold),
      isEarned: false,
      progress: progress.current / kind.threshold,
    );
  }
}
