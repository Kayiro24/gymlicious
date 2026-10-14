import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/providers.dart';
import 'package:gym_tracker/core/storage/schema_migrations.dart';
import 'package:gym_tracker/features/backup/data/backup_service.dart';
import 'package:gym_tracker/features/backup/domain/backup_reminder.dart';
import 'package:gym_tracker/features/settings/settings.dart';
import 'package:gym_tracker/features/workouts/workouts.dart';

final backupServiceProvider = Provider<BackupService>(
  (ref) => BackupService(
    contributors: ref.watch(backupContributorsProvider),
    store: ref.watch(documentStoreProvider),
    files: ref.watch(fileGatewayProvider),
    migrator: appSchemaMigrator,
    clock: ref.watch(clockProvider),
    appVersion: ref.watch(appVersionProvider),
  ),
);

final undoSnapshotAvailableProvider = FutureProvider<bool>((ref) {
  ref.watch(dataVersionProvider);
  return ref.watch(backupServiceProvider).hasUndoSnapshot();
});

/// Whether Home should show the gentle backup banner (spec 5.9).
final backupReminderDueProvider = Provider<bool>((ref) {
  final settings = ref.watch(settingsControllerProvider);
  final sessions = ref.watch(
    workoutsControllerProvider.select((data) => data.sessions),
  );
  return BackupReminder.isDue(
    now: ref.watch(clockProvider).now(),
    lastBackupAt: settings.lastBackupAt,
    dismissedAt: settings.backupBannerDismissedAt,
    sessionStarts: [for (final session in sessions) session.startedAt],
    isEnabled: settings.isBackupReminderOn,
  );
});
