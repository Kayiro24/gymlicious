import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/app_theme.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/app_sheet.dart';
import 'package:gym_tracker/features/workouts/workouts.dart';
import 'package:gym_tracker/shared/stat_pill.dart';

/// Brief post-workout summary: duration, exercises, sets and new maxes.
Future<void> showSessionSummary(
  BuildContext context,
  WidgetRef ref,
  SessionSummary summary,
) {
  final l10n = AppLocalizations.of(context);
  final format = WeightFormat.of(context, ref);
  final stats = [
    (l10n.summaryDuration, l10n.summaryMinutes(summary.duration.inMinutes)),
    (l10n.summaryExercises, '${summary.exerciseCount}'),
    (l10n.summarySets, '${summary.completedSetCount}'),
  ];
  return showAppSheet<void>(
    context: context,
    title: l10n.summaryTitle,
    builder: (sheetContext) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: TokenSpace.xl,
          runSpacing: TokenSpace.md,
          children: [
            for (final (label, value) in stats)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: sheetContext.textStyles.bodySmall),
                  Text(
                    value,
                    style: sheetContext.textStyles.headlineSmall?.copyWith(
                      fontFeatures: AppTheme.tabularFigures,
                    ),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: TokenSpace.xl),
        Text(l10n.summaryNewMaxes, style: sheetContext.textStyles.titleMedium),
        const SizedBox(height: TokenSpace.sm),
        if (summary.newMaxes.isEmpty)
          Text(l10n.summaryNoNewMax, style: sheetContext.textStyles.bodyMedium)
        else
          Wrap(
            spacing: TokenSpace.sm,
            runSpacing: TokenSpace.sm,
            children: [
              for (final max in summary.newMaxes)
                StatPill(
                  label: max.exerciseName,
                  value: format.withUnit(max.weightKg),
                  isHighlighted: true,
                ),
            ],
          ),
        const SizedBox(height: TokenSpace.xl),
        AppButton(
          label: l10n.summaryDone,
          isExpanded: true,
          onPressed: () => Navigator.of(sheetContext).pop(),
        ),
      ],
    ),
  );
}
