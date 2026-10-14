import 'package:gym_tracker/core/failure/failure.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';

abstract final class BackupMessages {
  /// Specific, kind wording for each restore failure (spec 5.9).
  static String restoreFailure(
    AppLocalizations l10n,
    Failure failure,
  ) => switch (failure) {
    BackupFailure(kind: BackupFailureKind.notABackup) => l10n.restoreNotABackup,
    BackupFailure(kind: BackupFailureKind.damaged) => l10n.restoreDamaged,
    BackupFailure(kind: BackupFailureKind.newerSchema) => l10n.restoreNewerApp,
    BackupFailure(kind: BackupFailureKind.invalidStructure) =>
      l10n.restoreInvalid,
    _ => l10n.restoreFailed,
  };
}
