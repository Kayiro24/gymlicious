import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/app_sheet.dart';
import 'package:gym_tracker/features/train/presentation/train_routes.dart';
import 'package:gym_tracker/features/workouts/workouts.dart';
import 'package:gym_tracker/shared/confirm_dialog.dart';

enum _DraftChoice { resume, discard }

abstract final class TrainActions {
  /// Starts a session for [day] (or freestyle). An unfinished draft is never
  /// silently replaced: the user resumes it or discards it first.
  static Future<void> start(
    BuildContext context,
    WidgetRef ref, {
    WorkoutSplit? split,
    SplitDay? day,
  }) async {
    final controller = ref.read(workoutsControllerProvider.notifier);
    if (ref.read(workoutsControllerProvider).activeSession != null) {
      final choice = await _askAboutDraft(context);
      if (!context.mounted || choice == null) {
        return;
      }
      if (choice == _DraftChoice.resume) {
        await context.push(TrainRoutes.session);
        return;
      }
      controller.discardActiveSession();
    }
    controller.startSession(split: split, day: day);
    if (context.mounted) {
      await context.push(TrainRoutes.session);
    }
  }

  static Future<bool> confirmDiscard(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return showConfirmDialog(
      context,
      title: l10n.trainDiscardQuestion,
      message: l10n.trainDiscardExplain,
      confirmLabel: l10n.trainDiscard,
      isDestructive: true,
    );
  }

  static Future<_DraftChoice?> _askAboutDraft(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return showAppSheet<_DraftChoice>(
      context: context,
      title: l10n.trainDraftExists,
      builder: (sheetContext) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppButton(
            label: l10n.trainResume,
            isExpanded: true,
            onPressed: () =>
                Navigator.of(sheetContext).pop(_DraftChoice.resume),
          ),
          const SizedBox(height: TokenSpace.sm),
          AppButton(
            label: l10n.trainDiscard,
            isExpanded: true,
            variant: AppButtonVariant.quiet,
            onPressed: () async {
              final isConfirmed = await confirmDiscard(sheetContext);
              if (isConfirmed && sheetContext.mounted) {
                Navigator.of(sheetContext).pop(_DraftChoice.discard);
              }
            },
          ),
        ],
      ),
    );
  }
}
