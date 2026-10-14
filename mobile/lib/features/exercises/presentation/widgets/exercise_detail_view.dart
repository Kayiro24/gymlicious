import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/app_card.dart';
import 'package:gym_tracker/design_system/app_section_header.dart';
import 'package:gym_tracker/design_system/app_toast.dart';
import 'package:gym_tracker/features/exercises/presentation/widgets/exercise_form_sheet.dart';
import 'package:gym_tracker/features/exercises/presentation/widgets/progress_chart.dart';
import 'package:gym_tracker/features/workouts/workouts.dart';
import 'package:gym_tracker/shared/confirm_dialog.dart';
import 'package:gym_tracker/shared/empty_state.dart';
import 'package:gym_tracker/shared/stat_pill.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Max/last, progress chart, history, notes and archive for one exercise.
class ExerciseDetailView extends ConsumerWidget {
  const new({required this.exerciseId, super.key, this.onRemoved});

  final String exerciseId;
  final VoidCallback? onRemoved;

  Future<void> _remove(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(workoutsControllerProvider.notifier);
    final hasHistory = controller.hasHistory(exerciseId);
    final isConfirmed = await showConfirmDialog(
      context,
      title: hasHistory
          ? l10n.exerciseArchiveQuestion
          : l10n.exerciseDeleteQuestion,
      message: hasHistory
          ? l10n.exerciseArchiveExplain
          : l10n.exerciseDeleteExplain,
      confirmLabel: hasHistory ? l10n.exerciseArchive : l10n.exerciseDelete,
      isDestructive: !hasHistory,
    );
    if (!isConfirmed || !context.mounted) {
      return;
    }
    final wasArchived = controller.removeExercise(exerciseId);
    showAppToast(
      context,
      wasArchived ? l10n.exerciseArchived : l10n.exerciseDeleted,
    );
    if (!wasArchived) {
      onRemoved?.call();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final data = ref.watch(workoutsControllerProvider);
    final exercise = data.exerciseById(exerciseId);
    if (exercise == null) {
      return EmptyState(
        icon: LucideIcons.searchX,
        message: l10n.exerciseNotFound,
      );
    }
    final stats =
        ref.watch(exerciseStatsProvider)[exerciseId] ?? ExerciseStats.empty;
    final format = WeightFormat.of(context, ref);
    final locale = Localizations.localeOf(context).toLanguageTag();
    String date(CalendarDate? value) => value == null
        ? l10n.exerciseFromBaseline
        : DateFormat.yMMMd(locale).format(value.toLocalDateTime());
    final points = ProgressSeries.forExercise(exerciseId, data.sessions);
    final history = ProgressSeries.sessionsWith(exerciseId, data.sessions);
    final isBodyweight = exercise.isBodyweight;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      exercise.name,
                      style: context.textStyles.headlineSmall,
                    ),
                  ),
                  Text(
                    '${ExerciseLabels.muscle(l10n, exercise.muscleGroup)} · '
                    '${ExerciseLabels.equipment(l10n, exercise.equipment)}',
                    style: context.textStyles.bodySmall,
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: l10n.commonEdit,
              icon: const Icon(LucideIcons.pencil),
              onPressed: () =>
                  showExerciseFormSheet(context, existing: exercise),
            ),
          ],
        ),
        const SizedBox(height: TokenSpace.lg),
        AppCard(
          child: Wrap(
            spacing: TokenSpace.sm,
            runSpacing: TokenSpace.sm,
            children: [
              StatPill(
                label: stats.maxKg == null
                    ? l10n.statMax
                    : l10n.exerciseMaxOn(date(stats.maxDate)),
                value: format.withUnit(stats.maxKg, isBodyweight: isBodyweight),
                isHighlighted: true,
              ),
              StatPill(
                label: stats.lastKg == null
                    ? l10n.statLast
                    : l10n.exerciseLastOn(date(stats.lastDate)),
                value: format.withUnit(
                  stats.lastKg,
                  isBodyweight: isBodyweight,
                ),
              ),
            ],
          ),
        ),
        AppSectionHeader(l10n.exerciseProgress),
        AppCard(
          child: points.length < 2
              ? Text(
                  l10n.exerciseProgressEmpty,
                  style: context.textStyles.bodyMedium,
                )
              : ProgressChart(points: points, format: format),
        ),
        AppSectionHeader(l10n.exerciseNotes),
        _NotesField(exercise: exercise),
        AppSectionHeader(l10n.exerciseHistory),
        if (history.isEmpty)
          Text(l10n.exerciseHistoryEmpty, style: context.textStyles.bodyMedium)
        else
          for (final session in history)
            _HistoryRow(
              session: session,
              exerciseId: exerciseId,
              format: format,
              isBodyweight: isBodyweight,
            ),
        const SizedBox(height: TokenSpace.xl),
        if (exercise.isArchived)
          AppButton(
            label: l10n.exerciseUnarchive,
            icon: LucideIcons.archiveRestore,
            variant: AppButtonVariant.secondary,
            onPressed: () {
              final result = ref
                  .read(workoutsControllerProvider.notifier)
                  .unarchiveExercise(exerciseId);
              if (result.valueOrNull == null) {
                showAppToast(context, l10n.exerciseNameTaken);
              }
            },
          )
        else
          AppButton(
            label: data.sessions.any((s) => s.entryFor(exerciseId) != null)
                ? l10n.exerciseArchive
                : l10n.exerciseDelete,
            icon: LucideIcons.archive,
            variant: AppButtonVariant.quiet,
            onPressed: () => _remove(context, ref),
          ),
        const SizedBox(height: TokenSpace.xxl),
      ],
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const new({
    required this.session,
    required this.exerciseId,
    required this.format,
    required this.isBodyweight,
  });

  final WorkoutSession session;
  final String exerciseId;
  final WeightFormat format;
  final bool isBodyweight;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final entry = session.entryFor(exerciseId);
    final sets = [
      for (final set in entry?.sets ?? const <WorkoutSet>[])
        if (set.isDone)
          [
            l10n.exerciseSetSummary(
              format.withUnit(set.weightKg, isBodyweight: isBodyweight),
              set.reps == null ? '—' : '${set.reps}',
            ),
            if (set.isWarmup) '(${l10n.exerciseWarmupMark})',
          ].join(' '),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TokenSpace.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: TokenSpace.xxxl * 2,
            child: Text(
              DateFormat.MMMd(locale).format(session.startedAt),
              style: context.textStyles.labelMedium,
            ),
          ),
          Expanded(
            child: Text(
              sets.isEmpty ? '—' : sets.join(' · '),
              style: context.textStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotesField extends ConsumerStatefulWidget {
  const new({required this.exercise});

  final Exercise exercise;

  @override
  ConsumerState<_NotesField> createState() => _NotesFieldState();
}

class _NotesFieldState extends ConsumerState<_NotesField> {
  late final _notes = TextEditingController(text: widget.exercise.notes);

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  void _save() {
    final current = ref
        .read(workoutsControllerProvider)
        .exerciseById(widget.exercise.id);
    if (current != null && current.notes != _notes.text) {
      ref
          .read(workoutsControllerProvider.notifier)
          .updateExercise(current.copyWith(notes: _notes.text));
    }
  }

  @override
  Widget build(BuildContext context) => Focus(
    onFocusChange: (hasFocus) {
      if (!hasFocus) {
        _save();
      }
    },
    child: TextField(
      controller: _notes,
      minLines: 2,
      maxLines: 6,
      textCapitalization: TextCapitalization.sentences,
      style: context.textStyles.bodyLarge,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context).exerciseNotesHint,
      ),
      onSubmitted: (_) => _save(),
    ),
  );
}
