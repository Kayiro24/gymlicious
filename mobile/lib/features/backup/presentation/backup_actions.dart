import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/failure/failure.dart';
import 'package:gym_tracker/core/failure/result.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/platform/document_gateway.dart';
import 'package:gym_tracker/core/platform/platform_providers.dart';
import 'package:gym_tracker/core/providers.dart';
import 'package:gym_tracker/design_system/app_progress_sheet.dart';
import 'package:gym_tracker/design_system/app_toast.dart';
import 'package:gym_tracker/features/backup/domain/backup_envelope.dart';
import 'package:gym_tracker/features/backup/domain/restore_plan.dart';
import 'package:gym_tracker/features/backup/presentation/backup_messages.dart';
import 'package:gym_tracker/features/backup/presentation/state/backup_providers.dart';
import 'package:gym_tracker/features/backup/presentation/widgets/restore_preview_sheet.dart';
import 'package:gym_tracker/features/settings/settings.dart';

enum ExportTarget { device, shareSheet, whatsApp }

typedef _Export = ({String fileName, Uint8List bytes});

abstract final class BackupActions {
  static const mimeType = 'application/json';

  static Future<Result<_Export>> _build(WidgetRef ref) async {
    try {
      final envelope = await ref.read(backupServiceProvider).createBackup();
      return Ok((
        fileName: BackupEnvelope.fileNameFor(envelope.createdAt),
        bytes: Uint8List.fromList(utf8.encode(envelope.encode())),
      ));
    } on Object catch (error) {
      return Err(BackupFailure(BackupFailureKind.writeFailed, '$error'));
    }
  }

  static Future<Result<bool>> _deliver(
    WidgetRef ref,
    _Export export,
    ExportTarget target,
  ) async {
    final share = ref.read(shareGatewayProvider);
    try {
      final isDone = switch (target) {
        ExportTarget.device =>
          await ref
              .read(documentGatewayProvider)
              .saveDocument(
                fileName: export.fileName,
                bytes: export.bytes,
                mimeType: mimeType,
              ),
        ExportTarget.shareSheet => await share.shareFile(
          fileName: export.fileName,
          bytes: export.bytes,
          mimeType: mimeType,
        ),
        ExportTarget.whatsApp =>
          await share.shareToWhatsApp(
                fileName: export.fileName,
                bytes: export.bytes,
                mimeType: mimeType,
              ) ||
              await share.shareFile(
                fileName: export.fileName,
                bytes: export.bytes,
                mimeType: mimeType,
              ),
      };
      return Ok(isDone);
    } on Object catch (error) {
      return Err(BackupFailure(BackupFailureKind.writeFailed, '$error'));
    }
  }

  /// Builds a backup and saves or shares it; marks `lastBackupAt` on success.
  static Future<void> export(
    BuildContext context,
    WidgetRef ref,
    ExportTarget target,
  ) async {
    final l10n = AppLocalizations.of(context);
    final built = await _build(ref);
    if (!context.mounted) {
      return;
    }
    final export = switch (built) {
      Ok(:final value) => value,
      Err() => null,
    };
    if (export == null) {
      showAppToast(context, l10n.backupFailed);
      return;
    }
    final delivered = await _deliver(ref, export, target);
    if (!context.mounted) {
      return;
    }
    switch (delivered) {
      case Ok(value: true):
        ref
            .read(settingsControllerProvider.notifier)
            .update(
              (settings) => settings.copyWith(
                lastBackupAt: ref.read(clockProvider).now(),
              ),
            );
        showAppToast(
          context,
          target == ExportTarget.device ? l10n.backupSaved : l10n.backupShared,
        );
      case Ok(value: false):
        showAppToast(context, l10n.backupCancelled);
      case Err():
        showAppToast(context, l10n.backupFailed);
    }
  }

  /// Picks a file, shows the preview, and replaces all data on confirm.
  /// Returns true when data was restored.
  static Future<bool> restoreFromFile(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final l10n = AppLocalizations.of(context);
    final PickedDocument? picked;
    try {
      picked = await ref.read(documentGatewayProvider).pickDocument();
    } on Object {
      if (context.mounted) {
        showAppToast(context, l10n.restoreNotABackup);
      }
      return false;
    }
    if (picked == null || !context.mounted) {
      return false;
    }
    final String text;
    try {
      text = utf8.decode(picked.bytes);
    } on FormatException {
      showAppToast(context, l10n.restoreNotABackup);
      return false;
    }
    final prepared = ref.read(backupServiceProvider).prepareRestore(text);
    final RestorePlan plan;
    switch (prepared) {
      case Err(:final failure):
        showAppToast(context, BackupMessages.restoreFailure(l10n, failure));
        return false;
      case Ok(:final value):
        plan = value;
    }
    final isConfirmed = await showRestorePreview(context, plan.preview);
    if (!isConfirmed || !context.mounted) {
      return false;
    }
    final isRestored = await runWithProgressSheet<void>(
      context: context,
      workingText: l10n.restoreWorking,
      successText: l10n.restoreDone,
      failureText: (_) => l10n.restoreFailed,
      task: () => ref.read(backupServiceProvider).restore(plan),
    );
    _reloadEverything(ref);
    return isRestored;
  }

  static Future<void> undoRestore(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final result = await ref.read(backupServiceProvider).undoLastRestore();
    _reloadEverything(ref);
    if (!context.mounted) {
      return;
    }
    showAppToast(
      context,
      result is Ok ? l10n.undoRestoreDone : l10n.restoreFailed,
    );
  }

  /// Wipes every section and feature file, then returns to the gate.
  static Future<void> resetAllData(WidgetRef ref) async {
    await ref.read(documentStoreProvider).clear();
    for (final module in ref.read(featureModulesProvider)) {
      await module.clearLocalData(ref.read);
    }
    await ref.read(backupServiceProvider).discardUndoSnapshot();
    await ref.read(notificationGatewayProvider).disableWeeklyReminder();
    _reloadEverything(ref);
  }

  static void _reloadEverything(WidgetRef ref) {
    ref.read(storageStatusProvider.notifier).markHealthy();
    ref.read(dataVersionProvider.notifier).bump();
  }
}
