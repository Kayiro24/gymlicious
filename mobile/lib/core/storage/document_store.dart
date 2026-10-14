import 'dart:async';

import 'package:gym_tracker/core/failure/failure.dart';
import 'package:gym_tracker/core/logging/app_logger.dart';
import 'package:gym_tracker/core/storage/data_section.dart';
import 'package:gym_tracker/core/storage/data_store.dart';
import 'package:gym_tracker/core/storage/schema_migrator.dart';

enum DocumentLoadStatus { fresh, loaded, recoveredFromBackup, corrupted }

/// In-memory app document split into feature-owned sections, persisted with
/// debounced saves through a [DataStore].
class DocumentStore {
  new({
    required this.dataStore,
    required List<DataSection> sections,
    required this.migrator,
    required this.logger,
    this.debounce = const Duration(milliseconds: 500),
  }) : _sections = {for (final section in sections) section.key: section};

  final DataStore dataStore;
  final SchemaMigrator migrator;
  final AppLogger logger;
  final Duration debounce;
  final Map<String, DataSection> _sections;
  final _saveFailures = StreamController<Failure>.broadcast();

  JsonMap _values = {};
  Timer? _pendingSave;

  Iterable<DataSection> get sections => _sections.values;

  Stream<Failure> get saveFailures => _saveFailures.stream;

  Future<DocumentLoadStatus> load() async {
    final result = await dataStore.load(isValid: _isLoadable);
    switch (result) {
      case StoreEmpty():
        _values = _emptyValues();
        return DocumentLoadStatus.fresh;
      case StoreCorrupted(:final reason):
        logger.log(LogLevel.error, 'Data file corrupted: $reason');
        _values = _emptyValues();
        return DocumentLoadStatus.corrupted;
      case StoreLoaded(:final document, :final isRecoveredFromBackup):
        _values = _withDefaults(migrator.migrate(document));
        return isRecoveredFromBackup
            ? DocumentLoadStatus.recoveredFromBackup
            : DocumentLoadStatus.loaded;
    }
  }

  Object? read(String key) {
    _requireSection(key);
    return _values[key];
  }

  void write(String key, Object? value) {
    _requireSection(key);
    _values[key] = value;
    _scheduleSave();
  }

  /// Validates [document] the same way a loaded file is validated.
  String? validateDocument(JsonMap document) {
    for (final section in _sections.values) {
      if (!document.containsKey(section.key)) {
        continue;
      }
      final reason = section.validate(document[section.key]);
      if (reason != null) {
        return '${section.key}: $reason';
      }
    }
    return null;
  }

  /// The full document as it would be written to disk.
  JsonMap snapshot() => {schemaVersionKey: migrator.currentVersion, ..._values};

  /// Replaces every section at once and saves immediately.
  Future<void> replaceAll(JsonMap sections) async {
    _values = _withDefaults(sections);
    await flush();
  }

  /// Empties sections that are not part of backups (e.g. a draft session),
  /// so restored data never mixes with leftovers from before.
  void resetTransientSections() {
    for (final section in _sections.values.where((item) => !item.isBackedUp)) {
      _values[section.key] = section.emptyValue;
    }
    _scheduleSave();
  }

  Future<void> clear() async {
    _pendingSave?.cancel();
    _values = _emptyValues();
    await dataStore.deleteAll();
  }

  Future<void> flush() async {
    _pendingSave?.cancel();
    _pendingSave = null;
    try {
      await dataStore.save(snapshot());
    } on Object catch (error) {
      logger.log(LogLevel.error, 'Saving data failed', error);
      _saveFailures.add(
        StorageFailure(StorageFailureKind.writeFailed, '$error'),
      );
    }
  }

  Future<void> dispose() async {
    await flush();
    await _saveFailures.close();
  }

  void _scheduleSave() {
    _pendingSave?.cancel();
    _pendingSave = Timer(debounce, flush);
  }

  bool _isLoadable(JsonMap document) {
    try {
      final migrated = migrator.migrate(document);
      return validateDocument(migrated) == null;
    } on UnsupportedSchemaException {
      return false;
    }
  }

  JsonMap _emptyValues() => {
    for (final section in _sections.values) section.key: section.emptyValue,
  };

  JsonMap _withDefaults(JsonMap document) => {
    for (final section in _sections.values)
      section.key: document.containsKey(section.key)
          ? document[section.key]
          : section.emptyValue,
  };

  void _requireSection(String key) {
    if (!_sections.containsKey(key)) {
      throw ArgumentError.value(key, 'key', 'Unregistered data section');
    }
  }
}
