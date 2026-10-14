import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/clock/today_provider.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/layout/content_width.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/app_card.dart';
import 'package:gym_tracker/design_system/app_section_header.dart';
import 'package:gym_tracker/features/checkin/checkin.dart';
import 'package:gym_tracker/features/rewards/rewards.dart';
import 'package:gym_tracker/features/stats/domain/training_stats.dart';
import 'package:gym_tracker/features/stats/presentation/widgets/stats_charts.dart';
import 'package:gym_tracker/features/year_dots/year_dots.dart';
import 'package:gym_tracker/shared/empty_state.dart';
import 'package:gym_tracker/shared/month_calendar.dart';
import 'package:gym_tracker/shared/stat_tile.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class StatsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final streak = ref.watch(streakSnapshotProvider);
    const gap = SizedBox(height: TokenSpace.lg);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.statsTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(TokenSpace.lg),
          children: [
            ContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (streak.totalWorkouts == 0) ...[
                    EmptyState(
                      icon: LucideIcons.flame,
                      message: l10n.statsEmpty,
                      actionLabel: l10n.tabPlan,
                      onAction: () => context.go(CheckInRoutes.plan),
                    ),
                  ] else ...[
                    const _Numbers(),
                    gap,
                    const _MonthCard(),
                    gap,
                    const _WeeksCard(),
                    gap,
                    const _TimeOfDayCard(),
                  ],
                  AppSectionHeader(l10n.statsBadges),
                  const BadgeGrid(limit: 4),
                  const SizedBox(height: TokenSpace.sm),
                  AppButton(
                    label: l10n.statsSeeAllBadges,
                    icon: LucideIcons.award,
                    variant: AppButtonVariant.secondary,
                    isExpanded: true,
                    onPressed: () =>
                        unawaited(context.push(RewardsRoutes.badges)),
                  ),
                  gap,
                  const _YourYearCard(),
                  const SizedBox(height: TokenSpace.xxl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Numbers extends ConsumerWidget {
  const new();

  static const double _tileWidth = 150;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final streak = ref.watch(streakSnapshotProvider);
    final records = ref.watch(dayRecordsProvider);
    final today = ref.watch(todayProvider);
    final prs = ref.watch(
      rewardsSummaryProvider.select((s) => s.metrics.personalRecords),
    );
    final consistency = TrainingStats.consistency(streak);
    final monthCount = TrainingStats.workoutsInMonth(
      records,
      today.year,
      today.month,
    );
    final tiles = [
      StatTile(
        value: '${streak.currentDays}',
        label: l10n.statsCurrentStreak,
        icon: LucideIcons.flame,
      ),
      StatTile(
        value: '${streak.bestDays}',
        label: l10n.statsBestStreak,
        icon: LucideIcons.trophy,
      ),
      StatTile(
        value: '${streak.totalWorkouts}',
        label: l10n.statsTotalWorkouts,
        icon: LucideIcons.dumbbell,
      ),
      StatTile(
        value: '${streak.weeksOnTrack}',
        label: l10n.statsWeeksOnTrack,
        icon: LucideIcons.calendarCheck,
      ),
      StatTile(
        value: '${streak.currentWeek.done}/${streak.currentWeek.goal}',
        label: l10n.statsThisWeek,
        icon: LucideIcons.calendarDays,
      ),
      StatTile(
        value: '$monthCount',
        label: l10n.statsThisMonth,
        icon: LucideIcons.calendar,
      ),
      StatTile(
        value: consistency == null
            ? '–'
            : '${(consistency.met * 100 / consistency.total).round()}%',
        label: l10n.statsConsistency,
        icon: LucideIcons.target,
      ),
      StatTile(
        value: '$prs',
        label: l10n.statsPersonalRecords,
        icon: LucideIcons.medal,
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = (constraints.maxWidth / _tileWidth).floor().clamp(2, 4);
        final width =
            (constraints.maxWidth - (columns - 1) * TokenSpace.md) / columns;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: TokenSpace.md,
              runSpacing: TokenSpace.md,
              children: [
                for (final tile in tiles) SizedBox(width: width, child: tile),
              ],
            ),
            if (consistency != null) ...[
              const SizedBox(height: TokenSpace.sm),
              Text(
                '${l10n.statsConsistency}: '
                '${l10n.statsConsistencyHelp(consistency.total)}',
                style: context.textStyles.bodySmall,
              ),
            ],
          ],
        );
      },
    );
  }
}

class _MonthCard extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final today = ref.watch(todayProvider);
    final records = ref.watch(dayRecordsProvider);
    return AppCard(
      padding: const EdgeInsets.all(TokenSpace.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.statsThisMonth, style: context.textStyles.titleMedium),
          const SizedBox(height: TokenSpace.sm),
          MonthCalendar(
            year: today.year,
            month: today.month,
            weekdayLabels: CheckInText.weekdayLabels(context),
            dayData: (date) =>
                CheckInText.chipData(context, date, records[date], today),
            onDayTap: (date) => unawaited(showDaySheet(context, date)),
          ),
        ],
      ),
    );
  }
}

class _WeeksCard extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final streak = ref.watch(streakSnapshotProvider);
    final goals = ref.watch(checkInControllerProvider.select((l) => l.goals));
    final weeks = TrainingStats.recentWeeks(streak, goals);
    final format = DateFormat.Md(locale);
    final bars = [
      for (final week in weeks)
        (label: format.format(week.monday.toLocalDateTime()), value: week.done),
    ];
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.statsLastWeeks, style: context.textStyles.titleMedium),
          Text(l10n.statsLastWeeksHelp, style: context.textStyles.bodySmall),
          const SizedBox(height: TokenSpace.lg),
          WarmBarChart(
            bars: bars,
            goal: streak.currentWeek.goal,
            highlightLast: true,
            semanticLabel: [
              l10n.statsLastWeeks,
              for (final bar in bars)
                '${bar.label}: ${l10n.statsWorkoutCount(bar.value)}',
            ].join(', '),
          ),
        ],
      ),
    );
  }
}

class _TimeOfDayCard extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final counts = TrainingStats.timeOfDay(ref.watch(dayRecordsProvider));
    final typical = TrainingStats.typicalPeriod(counts);
    String name(TrainingPeriod period) => switch (period) {
      TrainingPeriod.morning => l10n.statsMorning,
      TrainingPeriod.afternoon => l10n.statsAfternoon,
      TrainingPeriod.evening => l10n.statsEvening,
      TrainingPeriod.night => l10n.statsNight,
    };
    final bars = [
      for (final period in TrainingPeriod.values)
        (label: name(period), value: counts[period]!),
    ];
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.statsTimeOfDay, style: context.textStyles.titleMedium),
          const SizedBox(height: TokenSpace.xs),
          if (typical == null)
            Text(
              l10n.statsTimeOfDayEmpty,
              style: context.textStyles.bodyMedium?.copyWith(
                color: context.colors.textSecondary,
              ),
            )
          else ...[
            Text(
              l10n.statsTypicalTime(name(typical)),
              style: context.textStyles.bodyMedium,
            ),
            const SizedBox(height: TokenSpace.lg),
            WarmBarChart(
              bars: bars,
              semanticLabel: [
                l10n.statsTimeOfDay,
                for (final bar in bars)
                  '${bar.label}: ${l10n.statsWorkoutCount(bar.value)}',
              ].join(', '),
            ),
          ],
        ],
      ),
    );
  }
}

class _YourYearCard extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    return AppCard(
      onTap: () => unawaited(context.push(YearDotsRoutes.root)),
      child: Row(
        children: [
          Icon(LucideIcons.grid3x3, color: colors.accent),
          const SizedBox(width: TokenSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.statsYourYear, style: context.textStyles.titleMedium),
                Text(
                  l10n.statsYourYearHelp,
                  style: context.textStyles.bodySmall,
                ),
              ],
            ),
          ),
          Icon(LucideIcons.chevronRight, color: colors.textSecondary),
        ],
      ),
    );
  }
}
