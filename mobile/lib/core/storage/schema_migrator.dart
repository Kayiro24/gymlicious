import 'package:gym_tracker/core/storage/data_store.dart';

const schemaVersionKey = 'schemaVersion';

/// Upgrades a document from [fromVersion] to `fromVersion + 1`.
abstract interface class SchemaMigration {
  int get fromVersion;

  JsonMap migrate(JsonMap document);
}

class UnsupportedSchemaException implements Exception {
  const new(this.found, this.supported);

  final int found;
  final int supported;

  @override
  String toString() =>
      'Schema $found is newer than the supported version $supported';
}

/// Applies ordered migrations to data files and backup payloads alike.
class SchemaMigrator {
  new({required this.currentVersion, required this.migrations}) {
    for (var version = 1; version < currentVersion; version++) {
      if (!migrations.any((migration) => migration.fromVersion == version)) {
        throw StateError('Missing migration from schema $version');
      }
    }
  }

  final int currentVersion;
  final List<SchemaMigration> migrations;

  static int? versionOf(JsonMap document) {
    final version = document[schemaVersionKey];
    return version is int ? version : null;
  }

  JsonMap migrate(JsonMap document) {
    var version = versionOf(document) ?? 1;
    if (version > currentVersion) {
      throw UnsupportedSchemaException(version, currentVersion);
    }
    var migrated = Map<String, Object?>.of(document);
    while (version < currentVersion) {
      final from = version;
      final migration = migrations.firstWhere(
        (item) => item.fromVersion == from,
      );
      migrated = migration.migrate(migrated);
      version += 1;
    }
    return migrated..[schemaVersionKey] = currentVersion;
  }
}
