import 'package:flutter/material.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/app_sheet.dart';

/// The honest "what happens if you uninstall" explanation (spec 5.9).
Future<void> showBackupInfoSheet(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  return showAppSheet<void>(
    context: context,
    title: l10n.backupInfoTitle,
    builder: (sheetContext) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.backupInfoBody, style: sheetContext.textStyles.bodyLarge),
        const SizedBox(height: TokenSpace.xl),
        AppButton(
          label: l10n.commonDone,
          onPressed: () => Navigator.of(sheetContext).pop(),
        ),
      ],
    ),
  );
}
