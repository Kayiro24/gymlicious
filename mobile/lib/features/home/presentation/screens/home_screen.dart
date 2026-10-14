import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/clock/today_provider.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/layout/window_size_class.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/app_card.dart';
import 'package:gym_tracker/features/backup/backup.dart';
import 'package:gym_tracker/features/checkin/checkin.dart';
import 'package:gym_tracker/features/home/presentation/widgets/home_header.dart';
import 'package:gym_tracker/features/home/presentation/widgets/resume_workout_card.dart';
import 'package:gym_tracker/features/quotes/quotes.dart';
import 'package:gym_tracker/features/rewards/rewards.dart';
import 'package:gym_tracker/features/stats/stats.dart';
import 'package:gym_tracker/features/train/train.dart';
import 'package:gym_tracker/features/workouts/workouts.dart';
import 'package:gym_tracker/shared/streak_card.dart';
import 'package:gym_tracker/shared/week_strip.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Home: the quote first, then the streak hero, today's check-in, this
/// week, the next badge and the way to Plan and Stats. Two columns on wide
/// screens.
class HomeScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: TokenSpace.lg);
    final isWide = WindowSizeClass.of(context).isExpanded;
    const primary = [_StreakHero(), gap, ResumeWorkoutCard(), _Today()];
    const secondary = [_ThisWeek(), gap, _NextBadge(), gap, _Shortcuts()];
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(TokenSpace.lg),
          children: [
            const HomeHeader(),
            gap,
            const HomeQuoteCard(),
            gap,
            const BackupReminderBanner(),
            if (isWide)
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: primary,
                    ),
                  ),
                  SizedBox(width: TokenSpace.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: secondary,
                    ),
                  ),
                ],
              )
            else
              const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [...primary, gap, ...secondary],
              ),
            const SizedBox(height: TokenSpace.xxl),
          ],
        ),
      ),
    );
  }
}

class _StreakHero extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final streak = ref.watch(streakSnapshotProvider);
    return StreakCard(
      streakDays: streak.currentDays,
      bestDays: streak.bestDays,
      weeksOnTrack: streak.weeksOnTrack,
      weekDone: streak.currentWeek.done,
      weekGoal: streak.currentWeek.goal,
      statusText: CheckInText.status(
        l10n,
        streak,
        isTodayDone: ref.watch(isTodayDoneProvider),
      ),
      footer: const LevelBar(),
      onTap: () => context.go(StatsRoutes.root),
    );
  }
}

class _Today extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final hasDraft = ref.watch(
      workoutsControllerProvider.select((data) => data.activeSession != null),
    );
    final split = ref.watch(activeSplitProvider);
    final day = ref.watch(upNextDayProvider);
    return TodayCard(
      secondaryAction: hasDraft || split == null || day == null
          ? null
          : AppButton(
              label: l10n.todayStartWorkout(day.name),
              icon: LucideIcons.play,
              variant: AppButtonVariant.secondary,
              isExpanded: true,
              onPressed: () =>
                  TrainActions.start(context, ref, split: split, day: day),
            ),
    );
  }
}

class _ThisWeek extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(todayProvider);
    final records = ref.watch(dayRecordsProvider);
    final monday = TrainingWeek.mondayOf(today);
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: TokenSpace.xs,
        vertical: TokenSpace.md,
      ),
      child: WeekStrip(
        weekdayLabels: CheckInText.weekdayLabels(context),
        days: [
          for (final date in TrainingWeek.daysOf(monday))
            CheckInText.chipData(context, date, records[date], today),
        ],
        onDayTap: (index) =>
            unawaited(showDaySheet(context, monday.addDays(index))),
      ),
    );
  }
}

class _NextBadge extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => NextBadgeTeaser(
    onTap: () => unawaited(context.push(RewardsRoutes.badges)),
  );
}

class _Shortcuts extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: AppButton(
            label: l10n.tabPlan,
            icon: LucideIcons.calendar,
            variant: AppButtonVariant.secondary,
            isExpanded: true,
            onPressed: () => context.go(CheckInRoutes.plan),
          ),
        ),
        const SizedBox(width: TokenSpace.md),
        Expanded(
          child: AppButton(
            label: l10n.tabStats,
            icon: LucideIcons.chartColumn,
            variant: AppButtonVariant.secondary,
            isExpanded: true,
            onPressed: () => context.go(StatsRoutes.root),
          ),
        ),
      ],
    );
  }
}
