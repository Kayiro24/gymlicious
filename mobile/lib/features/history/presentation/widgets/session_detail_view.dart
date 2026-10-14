import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/app_card.dart';
import 'package:gym_tracker/design_system/app_toast.dart';
import 'package:gym_tracker/features/history/presentation/history_routes.dart';
import 'package:gym_tracker/features/workouts/workouts.dart';
import 'package:gym_tracker/shared/confirm_dialog.dart';
import 'package:gym_tracker/shared/empty_state.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// A finished session with its sets, plus edit and delete (with undo).
class SessionDetailView extends ConsumerWidget {
  const new({required this.sessionId, super.key, this.onDeleted});

  final String sessionId;
  final VoidCallback? onDeleted;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final isConfirmed = await showConfirmDialog(
      context,
      title: l10n.sessionDetailDeleteQuestion,
      message: l10n.sessionDetailDeleteExplain,
      confirmLabel: l10n.sessionDetailDelete,
      isDestructive: true,
    );
    if (!isConfirmed || !context.mounted) {
      return;
    }
    final controller = ref.read(workoutsControllerProvider.notifier);
    final removed = controller.deleteSession(sessionId);
    if (removed == null) {
      return;
    }
    showAppToast(
      context,
      l10n.sessionDetailDeleted,
      actionLabel: l10n.commonUndo,
      onAction: () => controller.restoreSession(removed),
    );
    onDeleted?.call();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final data = ref.watch(workoutsControllerProvider);
    final session = data.sessionById(sessionId);
    if (session == null) {
      return EmptyState(
        icon: LucideIcons.searchX,
        message: l10n.sessionDetailMissing,
      );
    }
    final format = WeightFormat.of(context, ref);
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          session.dayName ?? l10n.sessionFreestyle,
          style: context.textStyles.headlineSmall,
        ),
        Text(
          '${DateFormat.yMMMMEEEEd(locale).add_jm().format(session.startedAt)}'
          ' · ${l10n.summaryMinutes(session.duration.inMinutes)}',
          style: context.textStyles.bodySmall,
        ),
        const SizedBox(height: TokenSpace.lg),
        for (final entry in session.entries) ...[
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.exerciseName, style: context.textStyles.titleMedium),
                const SizedBox(height: TokenSpace.xs),
                for (final (index, set) in entry.sets.indexed)
                  Text(
                    [
                      '${index + 1}.',
                      l10n.exerciseSetSummary(
                        format.withUnit(
                          set.weightKg,
                          isBodyweight:
                              data
                                  .exerciseById(entry.exerciseId)
                                  ?.isBodyweight ??
                              false,
                        ),
                        set.reps == null ? '—' : '${set.reps}',
                      ),
                      if (set.isWarmup) '(${l10n.exerciseWarmupMark})',
                    ].join(' '),
                    style: context.textStyles.bodyMedium?.copyWith(
                      color: set.isDone ? null : context.colors.textSecondary,
                      decoration: set.isDone
                          ? null
                          : TextDecoration.lineThrough,
                    ),
                  ),
                if (entry.note.isNotEmpty) ...[
                  const SizedBox(height: TokenSpace.xs),
                  Text(entry.note, style: context.textStyles.bodySmall),
                ],
              ],
            ),
          ),
          const SizedBox(height: TokenSpace.sm),
        ],
        const SizedBox(height: TokenSpace.lg),
        Wrap(
          spacing: TokenSpace.sm,
          runSpacing: TokenSpace.sm,
          children: [
            AppButton(
              label: l10n.sessionDetailEdit,
              icon: LucideIcons.pencil,
              variant: AppButtonVariant.secondary,
              onPressed: () => context.push(HistoryRoutes.edit(sessionId)),
            ),
            AppButton(
              label: l10n.sessionDetailDelete,
              icon: LucideIcons.trash2,
              variant: AppButtonVariant.quiet,
              onPressed: () => _delete(context, ref),
            ),
          ],
        ),
      ],
    );
  }
}
