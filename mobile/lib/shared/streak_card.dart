import 'package:flutter/material.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/flame_icon.dart';
import 'package:gym_tracker/design_system/hero_card.dart';
import 'package:gym_tracker/design_system/progress_ring.dart';

/// Home's hero: flame, big streak number, weekly ring, status line and an
/// optional footer (the XP bar).
class StreakCard extends StatelessWidget {
  const new({
    required this.streakDays,
    required this.bestDays,
    required this.weeksOnTrack,
    required this.weekDone,
    required this.weekGoal,
    required this.statusText,
    super.key,
    this.footer,
    this.onTap,
  });

  final int streakDays;
  final int bestDays;
  final int weeksOnTrack;
  final int weekDone;
  final int weekGoal;
  final String statusText;
  final Widget? footer;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ringLabel = l10n.weekRingLabel(weekDone, weekGoal);
    final summary = [
      l10n.streakSemantics(streakDays),
      l10n.streakWeeksOnTrack(weeksOnTrack),
      ringLabel,
      statusText,
    ].join(', ');
    return HeroCard(
      onTap: onTap,
      semanticLabel: summary,
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: TokenSpace.lg,
              runSpacing: TokenSpace.lg,
              children: [
                _StreakNumber(streakDays: streakDays),
                _WeekRing(done: weekDone, goal: weekGoal, label: ringLabel),
              ],
            ),
            const SizedBox(height: TokenSpace.sm),
            Text(
              '${l10n.streakWeeksOnTrack(weeksOnTrack)} · '
              '${l10n.streakBest(bestDays)}',
              style: context.textStyles.bodySmall,
            ),
            const SizedBox(height: TokenSpace.md),
            Text(statusText, style: context.textStyles.titleMedium),
            if (footer case final footer?) ...[
              const SizedBox(height: TokenSpace.lg),
              footer,
            ],
          ],
        ),
      ),
    );
  }
}

class _StreakNumber extends StatelessWidget {
  const new({required this.streakDays});

  final int streakDays;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final styles = context.textStyles;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FlameIcon(streakDays: streakDays),
        const SizedBox(width: TokenSpace.md),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MediaQuery.withClampedTextScaling(
                maxScaleFactor: TokenLayout.heroTextScaleCap,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text('$streakDays', style: styles.displayLarge),
                ),
              ),
              Text(l10n.streakDayLabel(streakDays), style: styles.titleMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _WeekRing extends StatelessWidget {
  const new({required this.done, required this.goal, required this.label});

  final int done;
  final int goal;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ProgressRing(
        value: goal == 0 ? 0 : done / goal,
        semanticLabel: label,
        child: Text('$done/$goal', style: context.textStyles.titleLarge),
      ),
      const SizedBox(height: TokenSpace.xs),
      Text(label, style: context.textStyles.bodySmall),
    ],
  );
}
