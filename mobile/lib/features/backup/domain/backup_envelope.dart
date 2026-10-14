import 'dart:convert';

import 'package:gym_tracker/core/clock/iso_date_time.dart';
import 'package:gym_tracker/core/failure/failure.dart';
import 'package:gym_tracker/core/failure/result.dart';
import 'package:gym_tracker/core/storage/data_store.dart';
import 'package:gym_tracker/features/backup/domain/canonical_json.dart';

class BackupEnvelope {
  const new({
    required this.schemaVersion,
    required this.appVersion,
    required this.createdAt,
    required this.payload,
  });

  static const appId = 'gymtracker';
  static const formatVersion = 1;

  final int schemaVersion;
  final String appVersion;
  final DateTime createdAt;
  final JsonMap payload;

  String get checksum => CanonicalJson.sha256Hex(payload);

  String encode() => const JsonEncoder.withIndent('  ').convert({
    'app': appId,
    'formatVersion': formatVersion,
    'schemaVersion': schemaVersion,
    'appVersion': appVersion,
    'createdAt': IsoDateTime.format(createdAt),
    'checksum': checksum,
    'payload': payload,
  });

  /// Parses and verifies a backup file. Schema migration is the caller's job.
  static Result<BackupEnvelope> decode(String text, {required int maxSchema}) {
    final Object? json;
    try {
      json = jsonDecode(text);
    } on FormatException {
      return const Err(BackupFailure(BackupFailureKind.notABackup, 'Not JSON'));
    }
    if (json is! Map<String, dynamic> || json['app'] != appId) {
      return const Err(
        BackupFailure(BackupFailureKind.notABackup, 'Missing app marker'),
      );
    }
    final payload = json['payload'];
    final schemaVersion = json['schemaVersion'];
    final createdAt = json['createdAt'];
    if (payload is! Map<String, dynamic> ||
        schemaVersion is! int ||
        createdAt is! String ||
        json['checksum'] is! String) {
      return const Err(
        BackupFailure(BackupFailureKind.damaged, 'Envelope fields missing'),
      );
    }
    if (CanonicalJson.sha256Hex(payload) != json['checksum']) {
      return const Err(
        BackupFailure(BackupFailureKind.damaged, 'Checksum mismatch'),
      );
    }
    if (schemaVersion > maxSchema) {
      return Err(
        BackupFailure(
          BackupFailureKind.newerSchema,
          'Schema $schemaVersion > $maxSchema',
        ),
      );
    }
    final parsedCreatedAt = IsoDateTime.tryParse(createdAt);
    if (parsedCreatedAt == null) {
      return const Err(
        BackupFailure(BackupFailureKind.damaged, 'Bad createdAt'),
      );
    }
    return Ok(
      BackupEnvelope(
        schemaVersion: schemaVersion,
        appVersion: '${json['appVersion'] ?? ''}',
        createdAt: parsedCreatedAt,
        payload: payload,
      ),
    );
  }

  /// `gymlicious-backup-YYYY-MM-DD-HHmm.json`. The envelope keeps
  /// `"app": "gymtracker"` so backups from before the rename still restore.
  static String fileNameFor(DateTime at) {
    String two(int value) => value.toString().padLeft(2, '0');
    return 'gymlicious-backup-${at.year}-${two(at.month)}-${two(at.day)}-'
        '${two(at.hour)}${two(at.minute)}.json';
  }
}
