import 'dart:convert';
import 'dart:isolate';

import 'package:gym_tracker/core/storage/data_store.dart';
import 'package:gym_tracker/core/storage/file_gateway.dart';
import 'package:gym_tracker/core/storage/write_queue.dart';

/// JSON file store with crash-safe writes: tmp → flush → .bak → rename.
class AtomicJsonStore implements DataStore {
  new({required this.files, this.fileName = defaultFileName});

  static const defaultFileName = 'gymtracker_data.json';

  final FileGateway files;
  final String fileName;
  final WriteQueue _queue = WriteQueue();

  String get _tempName => '$fileName.tmp';
  String get backupName => '$fileName.bak';

  @override
  Future<StoreLoadResult> load({
    required bool Function(JsonMap) isValid,
  }) async {
    final primary = await _readDocument(fileName, isValid);
    if (primary != null) {
      return StoreLoaded(primary, isRecoveredFromBackup: false);
    }
    final backup = await _readDocument(backupName, isValid);
    if (backup != null) {
      return StoreLoaded(backup, isRecoveredFromBackup: true);
    }
    final hasAnyFile =
        await files.exists(fileName) || await files.exists(backupName);
    return hasAnyFile
        ? const StoreCorrupted('Primary and backup files are unreadable')
        : const StoreEmpty();
  }

  @override
  Future<void> save(JsonMap document) => _queue.enqueue(() async {
    final encoded = await _encodeInBackground(document);
    await files.writeString(_tempName, encoded);
    if (await files.exists(fileName)) {
      await files.copy(fileName, backupName);
    }
    await files.rename(_tempName, fileName);
  });

  @override
  Future<void> deleteAll() => _queue.enqueue(() async {
    for (final name in [fileName, backupName, _tempName]) {
      await files.delete(name);
    }
  });

  Future<JsonMap?> _readDocument(
    String name,
    bool Function(JsonMap) isValid,
  ) async {
    final String? contents;
    try {
      contents = await files.readString(name);
    } on Exception {
      return null;
    }
    if (contents == null || contents.isEmpty) {
      return null;
    }
    final decoded = await _decodeInBackground(contents);
    if (decoded == null) {
      return null;
    }
    return isValid(decoded) ? decoded : null;
  }
}

Future<String> _encodeInBackground(JsonMap document) =>
    Isolate.run(() => jsonEncode(document));

Future<JsonMap?> _decodeInBackground(String contents) =>
    Isolate.run(() => _tryDecode(contents));

JsonMap? _tryDecode(String contents) {
  try {
    final value = jsonDecode(contents);
    return value is Map<String, Object?> ? value : null;
  } on FormatException {
    return null;
  }
}
