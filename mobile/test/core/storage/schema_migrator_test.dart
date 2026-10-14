import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/core/storage/data_store.dart';
import 'package:gym_tracker/core/storage/schema_migrations.dart';
import 'package:gym_tracker/core/storage/schema_migrator.dart';

class _RenameField implements SchemaMigration {
  const new(this.fromVersion, this.from, this.to);

  @override
  final int fromVersion;
  final String from;
  final String to;

  @override
  JsonMap migrate(JsonMap document) => Map.of(document)..[to] = document[from];
}

void main() {
  final migrator = SchemaMigrator(
    currentVersion: 3,
    migrations: const [_RenameField(2, 'b', 'c'), _RenameField(1, 'a', 'b')],
  );

  test('applies migrations in version order', () {
    final migrated = migrator.migrate({'schemaVersion': 1, 'a': 'x'});

    expect(migrated['c'], 'x');
    expect(migrated['schemaVersion'], 3);
  });

  test('a document without a version is treated as version 1', () {
    expect(migrator.migrate({'a': 'x'})['c'], 'x');
  });

  test('a current document is unchanged apart from the version', () {
    expect(migrator.migrate({'schemaVersion': 3, 'c': 'y'}), {
      'schemaVersion': 3,
      'c': 'y',
    });
  });

  test('a newer document is refused', () {
    expect(
      () => migrator.migrate({'schemaVersion': 4}),
      throwsA(isA<UnsupportedSchemaException>()),
    );
  });

  test('a gap in the migration chain fails fast', () {
    expect(
      () => SchemaMigrator(currentVersion: 3, migrations: const []),
      throwsStateError,
    );
  });

  test('the app migrator is consistent with the current schema', () {
    expect(appSchemaMigrator.currentVersion, currentSchemaVersion);
  });
}
