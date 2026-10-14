import 'package:flutter/material.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/app_theme.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/app_sheet.dart';
import 'package:gym_tracker/features/backup/domain/restore_plan.dart';
import 'package:intl/intl.dart';

/// Shows what a backup contains; resolves to true when the user confirms.
Future<bool> showRestorePreview(
  BuildContext context,
  BackupPreview preview,
) async {
  final l10n = AppLocalizations.of(context);
  final locale = Localizations.localeOf(context).toLanguageTag();
  final rows = [
    (l10n.restorePreviewName, preview.profileName ?? '—'),
    (l10n.restorePreviewExercises, '${preview.exerciseCount}'),
    (l10n.restorePreviewSessions, '${preview.sessionCount}'),
    (
      l10n.restorePreviewDate,
      DateFormat.yMMMd(locale).add_jm().format(preview.createdAt),
    ),
    (
      l10n.restorePreviewPhoto,
      preview.hasPhoto
          ? l10n.restorePreviewPhotoYes
          : l10n.restorePreviewPhotoNo,
    ),
  ];
  final confirmed = await showAppSheet<bool>(
    context: context,
    title: l10n.restoreTitle,
    builder: (sheetContext) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (label, value) in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: TokenSpace.xs),
            child: Row(
              children: [
                Expanded(
                  child: Text(label, style: sheetContext.textStyles.bodyMedium),
                ),
                Flexible(
                  child: Text(
                    value,
                    textAlign: TextAlign.end,
                    style: sheetContext.textStyles.titleMedium?.copyWith(
                      fontFeatures: AppTheme.tabularFigures,
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: TokenSpace.lg),
        Text(
          l10n.restoreWarning,
          style: sheetContext.textStyles.bodyMedium?.copyWith(
            color: sheetContext.colors.danger,
          ),
        ),
        const SizedBox(height: TokenSpace.xl),
        AppButton(
          label: l10n.restoreConfirm,
          isExpanded: true,
          variant: AppButtonVariant.danger,
          onPressed: () => Navigator.of(sheetContext).pop(true),
        ),
        AppButton(
          label: l10n.commonCancel,
          isExpanded: true,
          variant: AppButtonVariant.quiet,
          onPressed: () => Navigator.of(sheetContext).pop(false),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
