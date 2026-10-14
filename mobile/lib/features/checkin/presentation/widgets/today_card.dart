import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/clock/today_provider.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/app_card.dart';
import 'package:gym_tracker/design_system/motion.dart';
import 'package:gym_tracker/features/checkin/domain/training_week.dart';
import 'package:gym_tracker/features/checkin/presentation/state/check_in_providers.dart';
import 'package:gym_tracker/features/checkin/presentation/widgets/day_sheet.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// The one daily question with one big answer. [secondaryAction] is the
/// optional "Start workout" button supplied by the host screen.
class TodayCard extends ConsumerWidget {
  const new({super.key, this.secondaryAction});

  final Widget? secondaryAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final today = ref.watch(todayProvider);
    final record = ref.watch(dayRecordsProvider)[today];
    final isDone = record?.isDone ?? false;
    final note = record?.note ?? '';
    final controller = ref.read(checkInControllerProvider.notifier);

    void toggle() {
      unawaited(HapticFeedback.mediumImpact());
      controller.toggleDone(today);
    }

    final question = isDone
        ? l10n.todayDone
        : TrainingWeek.isBonusDay(today)
        ? l10n.todayRestDay
        : l10n.todayQuestion;
    return AppCard(
      semanticLabel: l10n.todayTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    l10n.todayTitle,
                    style: context.textStyles.titleLarge,
                  ),
                ),
              ),
              if (isDone) Icon(LucideIcons.circleCheck, color: colors.accent),
            ],
          ),
          const SizedBox(height: TokenSpace.xs),
          AnimatedSwitcher(
            duration: AppMotion.of(context),
            child: Semantics(
              liveRegion: true,
              child: Text(
                question,
                key: ValueKey(question),
                style: context.textStyles.bodyLarge,
              ),
            ),
          ),
          if (note.isNotEmpty) ...[
            const SizedBox(height: TokenSpace.xs),
            Text(
              l10n.todayPlanned(note),
              style: context.textStyles.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: TokenSpace.lg),
          if (isDone)
            Wrap(
              spacing: TokenSpace.sm,
              runSpacing: TokenSpace.sm,
              children: [
                AppButton(
                  label: l10n.todayAddDetails,
                  icon: LucideIcons.notebookPen,
                  variant: AppButtonVariant.secondary,
                  onPressed: () => showDaySheet(context, today),
                ),
                AppButton(
                  label: l10n.todayUndo,
                  icon: LucideIcons.undo2,
                  variant: AppButtonVariant.quiet,
                  onPressed: toggle,
                ),
              ],
            )
          else ...[
            AppButton(
              label: l10n.todayCheckIn,
              icon: LucideIcons.check,
              isExpanded: true,
              onPressed: toggle,
            ),
            AppButton(
              label: l10n.todayAddDetails,
              icon: LucideIcons.notebookPen,
              variant: AppButtonVariant.quiet,
              isExpanded: true,
              onPressed: () => showDaySheet(context, today),
            ),
          ],
          if (secondaryAction case final action?) ...[
            const SizedBox(height: TokenSpace.sm),
            action,
          ],
        ],
      ),
    );
  }
}
