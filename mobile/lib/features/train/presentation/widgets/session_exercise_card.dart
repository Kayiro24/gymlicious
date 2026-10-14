import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/app_card.dart';
import 'package:gym_tracker/design_system/app_sheet.dart';
import 'package:gym_tracker/design_system/app_toast.dart';
import 'package:gym_tracker/features/workouts/workouts.dart';
import 'package:gym_tracker/shared/set_row.dart';
import 'package:gym_tracker/shared/stat_pill.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum _EntryAction { moveUp, moveDown, note, remove }

/// One exercise in the active session: Last/Max, set rows and Add set.
class SessionExerciseCard extends ConsumerWidget {
  const new({
    required this.entryIndex,
    required this.entry,
    required this.entryCount,
    super.key,
  });

  final int entryIndex;
  final SessionEntry entry;
  final int entryCount;

  void _edit(WidgetRef ref, WorkoutSession Function(WorkoutSession) change) =>
      ref.read(workoutsControllerProvider.notifier).updateActiveSession(change);

  Future<void> _onAction(
    BuildContext context,
    WidgetRef ref,
    _EntryAction action,
  ) async {
    switch (action) {
      case _EntryAction.moveUp:
        _edit(ref, (session) => session.moveEntry(entryIndex, entryIndex - 1));
      case _EntryAction.moveDown:
        _edit(ref, (session) => session.moveEntry(entryIndex, entryIndex + 1));
      case _EntryAction.remove:
        _edit(ref, (session) => session.removeEntry(entryIndex));
      case _EntryAction.note:
        final note = await _askNote(context, entry.note);
        if (note != null) {
          _edit(ref, (session) => session.setEntryNote(entryIndex, note));
        }
    }
  }

  void _removeSet(BuildContext context, WidgetRef ref, int setIndex) {
    final l10n = AppLocalizations.of(context);
    final removed = entry.sets[setIndex];
    _edit(ref, (session) => session.removeSet(entryIndex, setIndex));
    showAppToast(
      context,
      l10n.sessionSetRemoved,
      actionLabel: l10n.commonUndo,
      onAction: () => _edit(
        ref,
        (session) => session.insertSet(entryIndex, setIndex, removed),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final format = WeightFormat.of(context, ref);
    final exercise = ref
        .watch(workoutsControllerProvider)
        .exerciseById(entry.exerciseId);
    final isBodyweight = exercise?.isBodyweight ?? false;
    final stats =
        ref.watch(exerciseStatsProvider)[entry.exerciseId] ??
        ExerciseStats.empty;
    final maxBefore = stats.maxKg;
    return AppCard(
      padding: const EdgeInsets.all(TokenSpace.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  entry.exerciseName,
                  style: context.textStyles.titleLarge,
                ),
              ),
              PopupMenuButton<_EntryAction>(
                icon: const Icon(LucideIcons.ellipsisVertical),
                onSelected: (action) => _onAction(context, ref, action),
                itemBuilder: (_) => [
                  if (entryIndex > 0)
                    PopupMenuItem(
                      value: _EntryAction.moveUp,
                      child: Text(l10n.sessionMoveUp),
                    ),
                  if (entryIndex < entryCount - 1)
                    PopupMenuItem(
                      value: _EntryAction.moveDown,
                      child: Text(l10n.sessionMoveDown),
                    ),
                  PopupMenuItem(
                    value: _EntryAction.note,
                    child: Text(l10n.sessionExerciseNote),
                  ),
                  PopupMenuItem(
                    value: _EntryAction.remove,
                    child: Text(l10n.sessionRemoveExercise),
                  ),
                ],
              ),
            ],
          ),
          Wrap(
            spacing: TokenSpace.sm,
            runSpacing: TokenSpace.xs,
            children: [
              StatPill(
                label: l10n.statLast,
                value: format.withUnit(
                  stats.lastKg,
                  isBodyweight: isBodyweight,
                ),
              ),
              StatPill(
                label: l10n.statMax,
                value: format.withUnit(maxBefore, isBodyweight: isBodyweight),
              ),
            ],
          ),
          if (entry.note.isNotEmpty) ...[
            const SizedBox(height: TokenSpace.sm),
            Text(entry.note, style: context.textStyles.bodySmall),
          ],
          const SizedBox(height: TokenSpace.md),
          for (final (setIndex, set) in entry.sets.indexed) ...[
            SetRow(
              key: ValueKey(
                '${entry.exerciseId}-$setIndex-${entry.sets.length}',
              ),
              number: setIndex + 1,
              weightText: format.input(set.weightKg),
              repsText: set.reps?.toString() ?? '',
              unitLabel: format.unit.name,
              isWarmup: set.isWarmup,
              isDone: set.isDone,
              isNewMax:
                  set.countsForStats &&
                  SessionSummary.isNewMax(set.weightKg, maxBefore),
              onWeightChanged: (text) {
                final kilograms = format.parse(text);
                if (kilograms != null) {
                  _edit(
                    ref,
                    (s) => s.replaceSet(
                      entryIndex,
                      setIndex,
                      set.copyWith(weightKg: kilograms),
                    ),
                  );
                }
              },
              onRepsChanged: (text) => _edit(
                ref,
                (s) => s.replaceSet(
                  entryIndex,
                  setIndex,
                  set.copyWith(reps: int.tryParse(text)),
                ),
              ),
              onIncrement: () => _edit(
                ref,
                (s) => s.replaceSet(
                  entryIndex,
                  setIndex,
                  set.copyWith(weightKg: format.step(set.weightKg, isUp: true)),
                ),
              ),
              onDecrement: () => _edit(
                ref,
                (s) => s.replaceSet(
                  entryIndex,
                  setIndex,
                  set.copyWith(
                    weightKg: format.step(set.weightKg, isUp: false),
                  ),
                ),
              ),
              onWarmupToggled: () => _edit(
                ref,
                (s) => s.replaceSet(
                  entryIndex,
                  setIndex,
                  set.copyWith(isWarmup: !set.isWarmup),
                ),
              ),
              onDoneToggled: () {
                final isNowDone = !set.isDone;
                if (isNowDone &&
                    !set.isWarmup &&
                    SessionSummary.isNewMax(set.weightKg, maxBefore)) {
                  unawaited(HapticFeedback.mediumImpact());
                }
                _edit(
                  ref,
                  (s) => s.replaceSet(
                    entryIndex,
                    setIndex,
                    set.copyWith(isDone: isNowDone),
                  ),
                );
              },
              onRemove: () => _removeSet(context, ref, setIndex),
            ),
            const SizedBox(height: TokenSpace.sm),
          ],
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: AppButton(
              label: l10n.sessionAddSet,
              icon: LucideIcons.plus,
              variant: AppButtonVariant.quiet,
              onPressed: () => _edit(ref, (s) => s.addSet(entryIndex, stats)),
            ),
          ),
        ],
      ),
    );
  }
}

Future<String?> _askNote(BuildContext context, String current) {
  final l10n = AppLocalizations.of(context);
  final controller = TextEditingController(text: current);
  return showAppSheet<String>(
    context: context,
    title: l10n.sessionExerciseNote,
    builder: (sheetContext) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller,
          autofocus: true,
          minLines: 2,
          maxLines: 5,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: TokenSpace.lg),
        AppButton(
          label: l10n.commonSave,
          onPressed: () =>
              Navigator.of(sheetContext).pop(controller.text.trim()),
        ),
      ],
    ),
  ).whenComplete(controller.dispose);
}
