import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/layout/content_width.dart';
import 'package:gym_tracker/core/layout/window_size_class.dart';
import 'package:gym_tracker/core/providers.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/app_toast.dart';
import 'package:gym_tracker/features/train/presentation/train_actions.dart';
import 'package:gym_tracker/features/train/presentation/widgets/exercise_picker_sheet.dart';
import 'package:gym_tracker/features/train/presentation/widgets/session_exercise_card.dart';
import 'package:gym_tracker/features/train/presentation/widgets/session_summary_sheet.dart';
import 'package:gym_tracker/features/workouts/workouts.dart';
import 'package:gym_tracker/shared/confirm_dialog.dart';
import 'package:gym_tracker/shared/empty_state.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// The in-progress workout. Every edit is saved to the draft immediately.
class SessionScreen extends ConsumerStatefulWidget {
  const new({super.key});

  static const exerciseListWidth = 320.0;

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen> {
  int _selectedEntry = 0;

  Future<void> _addExercise() async {
    final active = ref.read(workoutsControllerProvider).activeSession;
    if (active == null) {
      return;
    }
    final exercise = await showExercisePicker(
      context,
      exclude: {for (final entry in active.entries) entry.exerciseId},
    );
    if (exercise == null) {
      return;
    }
    final data = ref.read(workoutsControllerProvider);
    final stats =
        ref.read(exerciseStatsProvider)[exercise.id] ?? ExerciseStats.empty;
    ref
        .read(workoutsControllerProvider.notifier)
        .updateActiveSession(
          (session) => session.addEntry(
            SessionFactory.entryFor(exercise, data.sessions, stats),
          ),
        );
    setState(() => _selectedEntry = active.entries.length);
  }

  Future<void> _finish() async {
    final l10n = AppLocalizations.of(context);
    final active = ref.read(workoutsControllerProvider).activeSession;
    if (active == null) {
      return;
    }
    final undone = active.entries.fold<int>(
      0,
      (count, entry) => count + entry.sets.where((set) => !set.isDone).length,
    );
    if (undone > 0) {
      final isConfirmed = await showConfirmDialog(
        context,
        title: l10n.sessionFinishQuestion,
        message: l10n.sessionFinishUndone(undone),
        confirmLabel: l10n.sessionFinish,
      );
      if (!isConfirmed) {
        return;
      }
    }
    final summary = ref
        .read(workoutsControllerProvider.notifier)
        .finishActiveSession();
    if (!mounted) {
      return;
    }
    if (summary == null) {
      showAppToast(context, l10n.sessionFinishNothingDone);
    } else {
      await showSessionSummary(context, ref, summary);
    }
    if (mounted) {
      context.pop();
    }
  }

  Future<void> _discard() async {
    if (!await TrainActions.confirmDiscard(context)) {
      return;
    }
    ref.read(workoutsControllerProvider.notifier).discardActiveSession();
    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final active = ref.watch(
      workoutsControllerProvider.select((data) => data.activeSession),
    );
    if (active == null) {
      return Scaffold(
        appBar: AppBar(),
        body: EmptyState(
          icon: LucideIcons.dumbbell,
          message: l10n.sessionNoActive,
        ),
      );
    }
    final isTwoPane =
        !WindowSizeClass.of(context).isCompact && active.entries.isNotEmpty;
    final selected = _selectedEntry.clamp(
      0,
      active.entries.isEmpty ? 0 : active.entries.length - 1,
    );
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(active.dayName ?? l10n.sessionFreestyle),
            _ElapsedText(startedAt: active.startedAt),
          ],
        ),
        actions: [
          IconButton(
            tooltip: l10n.sessionDiscard,
            icon: const Icon(LucideIcons.trash2),
            onPressed: _discard,
          ),
        ],
      ),
      body: SafeArea(
        child: active.entries.isEmpty
            ? Center(
                child: EmptyState(
                  icon: LucideIcons.listPlus,
                  message: l10n.sessionEmpty,
                  actionLabel: l10n.sessionAddExercise,
                  onAction: _addExercise,
                ),
              )
            : isTwoPane
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: SessionScreen.exerciseListWidth,
                    child: ListView(
                      padding: const EdgeInsets.all(TokenSpace.md),
                      children: [
                        for (final (index, entry) in active.entries.indexed)
                          ListTile(
                            selected: index == selected,
                            selectedTileColor: context.colors.accentSoft,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                TokenRadius.input,
                              ),
                            ),
                            title: Text(entry.exerciseName),
                            subtitle: Text(
                              '${entry.countedSets.length}/${entry.sets.length}',
                            ),
                            onTap: () => setState(() => _selectedEntry = index),
                          ),
                      ],
                    ),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(TokenSpace.lg),
                      child: SessionExerciseCard(
                        key: ValueKey(active.entries[selected].exerciseId),
                        entryIndex: selected,
                        entry: active.entries[selected],
                        entryCount: active.entries.length,
                      ),
                    ),
                  ),
                ],
              )
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  TokenSpace.md,
                  TokenSpace.md,
                  TokenSpace.md,
                  TokenSpace.xxxl,
                ),
                itemCount: active.entries.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: TokenSpace.md),
                itemBuilder: (context, index) => ContentWidth(
                  child: SessionExerciseCard(
                    key: ValueKey(active.entries[index].exerciseId),
                    entryIndex: index,
                    entry: active.entries[index],
                    entryCount: active.entries.length,
                  ),
                ),
              ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TokenSpace.md),
          child: Row(
            children: [
              Expanded(
                child: AppButton(
                  label: l10n.sessionAddExercise,
                  icon: LucideIcons.plus,
                  variant: AppButtonVariant.secondary,
                  isExpanded: true,
                  onPressed: _addExercise,
                ),
              ),
              const SizedBox(width: TokenSpace.sm),
              Expanded(
                child: AppButton(
                  label: l10n.sessionFinish,
                  icon: LucideIcons.check,
                  isExpanded: true,
                  onPressed: _finish,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ElapsedText extends ConsumerStatefulWidget {
  const new({required this.startedAt});

  final DateTime startedAt;

  @override
  ConsumerState<_ElapsedText> createState() => _ElapsedTextState();
}

class _ElapsedTextState extends ConsumerState<_ElapsedText> {
  static const _tick = Duration(seconds: 30);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(_tick, (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = ref
        .read(clockProvider)
        .now()
        .difference(widget.startedAt)
        .inMinutes;
    return Text(
      AppLocalizations.of(context).sessionElapsed(minutes < 0 ? 0 : minutes),
      style: context.textStyles.bodySmall,
    );
  }
}
