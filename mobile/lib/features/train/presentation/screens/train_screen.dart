import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/layout/content_width.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/app_card.dart';
import 'package:gym_tracker/design_system/app_list_tile.dart';
import 'package:gym_tracker/design_system/app_section_header.dart';
import 'package:gym_tracker/features/exercises/exercises.dart';
import 'package:gym_tracker/features/history/history.dart';
import 'package:gym_tracker/features/settings/settings.dart';
import 'package:gym_tracker/features/train/presentation/train_actions.dart';
import 'package:gym_tracker/features/train/presentation/train_routes.dart';
import 'package:gym_tracker/features/workouts/workouts.dart';
import 'package:gym_tracker/shared/empty_state.dart';
import 'package:gym_tracker/shared/split_day_chip.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class TrainScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final data = ref.watch(workoutsControllerProvider);
    final active = ref.watch(activeSplitProvider);
    final upNext = ref.watch(upNextDayProvider);
    final hasDraft = data.activeSession != null;
    final sessions = data.sessionsNewestFirst;
    final last = sessions.isEmpty ? null : sessions.first;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.trainTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(TokenSpace.lg),
          children: [
            ContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: l10n.trainExercises,
                          icon: LucideIcons.dumbbell,
                          variant: AppButtonVariant.secondary,
                          isExpanded: true,
                          onPressed: () =>
                              unawaited(context.push(ExercisesRoutes.root)),
                        ),
                      ),
                      const SizedBox(width: TokenSpace.md),
                      Expanded(
                        child: AppButton(
                          label: l10n.trainPastWorkouts,
                          icon: LucideIcons.history,
                          variant: AppButtonVariant.secondary,
                          isExpanded: true,
                          onPressed: () =>
                              unawaited(context.push(HistoryRoutes.root)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TokenSpace.lg),
                  if (hasDraft) ...[
                    AppCard(
                      color: context.colors.accentSoft,
                      child: Row(
                        children: [
                          const Icon(LucideIcons.timer),
                          const SizedBox(width: TokenSpace.md),
                          Expanded(
                            child: Text(
                              l10n.trainDraftExists,
                              style: context.textStyles.titleMedium,
                            ),
                          ),
                          AppButton(
                            label: l10n.trainResume,
                            onPressed: () => context.push(TrainRoutes.session),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: TokenSpace.lg),
                  ],
                  if (active == null)
                    EmptyState(
                      icon: LucideIcons.calendarRange,
                      message: l10n.trainNoSplits,
                      actionLabel: l10n.trainNewSplit,
                      onAction: () => context.push(TrainRoutes.newSplit),
                    )
                  else ...[
                    AppSectionHeader(active.name),
                    for (final day in active.days) ...[
                      SplitDayChip(
                        name: day.isRest
                            ? '${day.name} · ${l10n.trainRestDay}'
                            : day.name,
                        detail: [
                          if (day.id == upNext?.id) l10n.trainUpNext,
                          l10n.trainExerciseCount(day.exerciseIds.length),
                        ].join(' · '),
                        isUpNext: day.id == upNext?.id,
                        isRest: day.isRest,
                        onTap: day.isRest
                            ? null
                            : () => TrainActions.start(
                                context,
                                ref,
                                split: active,
                                day: day,
                              ),
                      ),
                      const SizedBox(height: TokenSpace.sm),
                    ],
                  ],
                  const SizedBox(height: TokenSpace.sm),
                  SplitDayChip(
                    name: l10n.trainFreestyle,
                    detail: l10n.trainFreestyleSubtitle,
                    onTap: () => TrainActions.start(context, ref),
                  ),
                  if (last != null) ...[
                    AppSectionHeader(l10n.trainLastWorkout),
                    SessionCard(
                      session: last,
                      onTap: () => unawaited(
                        context.push(HistoryRoutes.detail(last.id)),
                      ),
                    ),
                  ],
                  AppSectionHeader(
                    l10n.trainSplits,
                    trailing: TextButton.icon(
                      onPressed: () =>
                          unawaited(context.push(TrainRoutes.newSplit)),
                      icon: const Icon(LucideIcons.plus),
                      label: Text(l10n.trainNewSplit),
                    ),
                  ),
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        for (final split in data.splits)
                          AppListTile(
                            leadingIcon: split.id == active?.id
                                ? LucideIcons.circleCheck
                                : LucideIcons.circle,
                            title: split.name,
                            subtitle: split.id == active?.id
                                ? l10n.splitIsActive
                                : l10n.splitStepDays(split.trainingDays.length),
                            trailing: IconButton(
                              tooltip: l10n.trainEditSplit,
                              icon: const Icon(LucideIcons.pencil),
                              onPressed: () => context.push(
                                TrainRoutes.splitEditor(split.id),
                              ),
                            ),
                            onTap: () => ref
                                .read(settingsControllerProvider.notifier)
                                .update(
                                  (settings) => settings.copyWith(
                                    activeSplitId: split.id,
                                  ),
                                ),
                          ),
                      ],
                    ),
                  ),
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
