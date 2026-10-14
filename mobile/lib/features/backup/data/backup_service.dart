import 'package:gym_tracker/core/backup/backup_contributor.dart';
import 'package:gym_tracker/core/clock/clock.dart';
import 'package:gym_tracker/core/failure/failure.dart';
import 'package:gym_tracker/core/failure/result.dart';
import 'package:gym_tracker/core/storage/data_store.dart';
import 'package:gym_tracker/core/storage/document_store.dart';
import 'package:gym_tracker/core/storage/file_gateway.dart';
import 'package:gym_tracker/core/storage/schema_migrator.dart';
import 'package:gym_tracker/features/backup/domain/backup_envelope.dart';
import 'package:gym_tracker/features/backup/domain/restore_plan.dart';

/// Builds backups from registered contributors and restores them with a
/// one-step undo snapshot.
class BackupService {
  const new({
    required this.contributors,
    required this.store,
    required this.files,
    required this.migrator,
    required this.clock,
    required this.appVersion,
  });

  static const preRestoreFileName = 'pre_restore.json';
  static const _profileKey = 'profile';
  static const _exercisesKey = 'exercises';
  static const _sessionsKey = 'sessions';
  static const _photoKey = 'photoBase64';

  final List<BackupContributor> contributors;
  final DocumentStore store;
  final FileGateway files;
  final SchemaMigrator migrator;
  final Clock clock;
  final String appVersion;

  Future<BackupEnvelope> createBackup() async {
    final payload = <String, Object?>{};
    for (final contributor in contributors) {
      final value = await contributor.export();
      if (value != null || !contributor.isOptional) {
        payload[contributor.payloadKey] = value;
      }
    }
    return BackupEnvelope(
      schemaVersion: migrator.currentVersion,
      appVersion: appVersion,
      createdAt: clock.now(),
      payload: payload,
    );
  }

  /// Parses, verifies, migrates and validates a backup file's text.
  Result<RestorePlan> prepareRestore(String text) {
    final decoded = BackupEnvelope.decode(
      text,
      maxSchema: migrator.currentVersion,
    );
    if (decoded case Err(:final failure)) {
      return Err(failure);
    }
    final envelope = (decoded as Ok<BackupEnvelope>).value;
    final JsonMap migrated;
    try {
      migrated = migrator.migrate({
        ...envelope.payload,
        schemaVersionKey: envelope.schemaVersion,
      })..remove(schemaVersionKey);
    } on Object catch (error) {
      return Err(BackupFailure(BackupFailureKind.damaged, '$error'));
    }
    for (final contributor in contributors) {
      final key = contributor.payloadKey;
      if (!migrated.containsKey(key) && !contributor.isOptional) {
        return Err(
          BackupFailure(BackupFailureKind.invalidStructure, 'Missing $key'),
        );
      }
      final reason = contributor.validate(migrated[key]);
      if (reason != null) {
        return Err(
          BackupFailure(BackupFailureKind.invalidStructure, '$key: $reason'),
        );
      }
    }
    return Ok(
      RestorePlan(payload: migrated, preview: _preview(migrated, envelope)),
    );
  }

  /// Replaces all data with [plan]. Unless [isUndo], the current data is
  /// first saved as `pre_restore.json` so the restore can be undone once.
  Future<Result<void>> restore(RestorePlan plan, {bool isUndo = false}) async {
    try {
      if (!isUndo) {
        final snapshot = await createBackup();
        await files.writeString(preRestoreFileName, snapshot.encode());
      }
      for (final contributor in contributors) {
        await contributor.restore(plan.payload[contributor.payloadKey]);
      }
      store.resetTransientSections();
      await store.flush();
      return const Ok(null);
    } on Object catch (error) {
      return Err(BackupFailure(BackupFailureKind.writeFailed, '$error'));
    }
  }

  Future<bool> hasUndoSnapshot() => files.exists(preRestoreFileName);

  Future<Result<void>> undoLastRestore() async {
    final text = await files.readString(preRestoreFileName);
    if (text == null) {
      return const Err(
        BackupFailure(BackupFailureKind.notABackup, 'No snapshot'),
      );
    }
    final plan = prepareRestore(text);
    if (plan case Err(:final failure)) {
      return Err(failure);
    }
    final result = await restore(plan.valueOrNull!, isUndo: true);
    if (result is Ok) {
      await files.delete(preRestoreFileName);
    }
    return result;
  }

  Future<void> discardUndoSnapshot() => files.delete(preRestoreFileName);

  static BackupPreview _preview(JsonMap payload, BackupEnvelope envelope) {
    final profile = payload[_profileKey];
    final exercises = payload[_exercisesKey];
    final sessions = payload[_sessionsKey];
    return BackupPreview(
      profileName: profile is Map<String, dynamic>
          ? profile['name'] as String?
          : null,
      exerciseCount: exercises is List ? exercises.length : 0,
      sessionCount: sessions is List ? sessions.length : 0,
      createdAt: envelope.createdAt,
      hasPhoto: payload[_photoKey] is String,
    );
  }
}
