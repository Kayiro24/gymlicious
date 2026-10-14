import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/core/logging/app_logger.dart';
import 'package:gym_tracker/core/storage/atomic_json_store.dart';
import 'package:gym_tracker/core/storage/data_section.dart';
import 'package:gym_tracker/core/storage/document_store.dart';
import 'package:gym_tracker/core/storage/schema_migrator.dart';

import '../../fakes/memory_file_gateway.dart';

class _ListSection implements DataSection {
  const new(this.key);

  @override
  final String key;

  @override
  Object? get emptyValue => const <Object?>[];

  @override
  bool get isBackedUp => true;

  @override
  String? validate(Object? value) => value is List ? null : 'expected a list';
}

void main() {
  late MemoryFileGateway files;

  DocumentStore buildStore({
    SchemaMigrator? migrator,
    Duration debounce = const Duration(milliseconds: 500),
  }) => DocumentStore(
    dataStore: AtomicJsonStore(files: files),
    sections: const [_ListSection('items'), _ListSection('other')],
    migrator: migrator ?? SchemaMigrator(currentVersion: 1, migrations: []),
    logger: const SilentLogger(),
    debounce: debounce,
  );

  setUp(() => files = MemoryFileGateway());

  test('fresh install starts with empty sections', () async {
    final store = buildStore();

    expect(await store.load(), DocumentLoadStatus.fresh);
    expect(store.read('items'), isEmpty);
  });

  test('writes are debounced and land on disk after the delay', () async {
    final store = buildStore(debounce: const Duration(milliseconds: 100));
    await store.load();

    store
      ..write('items', [1])
      ..write('items', [1, 2]);
    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(files.text(AtomicJsonStore.defaultFileName), isNull);

    await Future<void>.delayed(const Duration(milliseconds: 400));
    expect(files.text(AtomicJsonStore.defaultFileName), contains('[1,2]'));
  });

  test('flush saves immediately and a reload sees the data', () async {
    final store = buildStore();
    await store.load();
    store.write('items', ['a']);
    await store.flush();

    final reloaded = buildStore();
    expect(await reloaded.load(), DocumentLoadStatus.loaded);
    expect(reloaded.read('items'), ['a']);
  });

  test('an invalid section makes the file unloadable and uses .bak', () async {
    final store = buildStore();
    await store.load();
    store.write('items', ['good']);
    await store.flush();
    store.write('items', 'not a list');
    await store.flush();

    final reloaded = buildStore();
    expect(await reloaded.load(), DocumentLoadStatus.recoveredFromBackup);
    expect(reloaded.read('items'), ['good']);
  });

  test('a newer schema on disk is treated as unloadable', () async {
    await files.writeString(
      AtomicJsonStore.defaultFileName,
      '{"schemaVersion": 99, "items": []}',
    );

    expect(await buildStore().load(), DocumentLoadStatus.corrupted);
  });

  test('missing sections are filled with defaults on load', () async {
    await files.writeString(
      AtomicJsonStore.defaultFileName,
      '{"schemaVersion": 1, "items": [1]}',
    );
    final store = buildStore();
    await store.load();

    expect(store.read('other'), isEmpty);
    expect(store.snapshot()['schemaVersion'], 1);
  });

  test('unregistered sections are rejected', () async {
    final store = buildStore();
    await store.load();

    expect(() => store.write('unknown', 1), throwsArgumentError);
  });

  test('save failures are reported, not thrown', () async {
    final store = buildStore();
    await store.load();
    final failures = <Object>[];
    store.saveFailures.listen(failures.add);
    files.crashOn = 'write';

    store.write('items', [1]);
    await store.flush();
    await Future<void>.delayed(Duration.zero);

    expect(failures, hasLength(1));
  });

  test('clear wipes memory and disk', () async {
    final store = buildStore();
    await store.load();
    store.write('items', [1]);
    await store.flush();
    await store.clear();

    expect(store.read('items'), isEmpty);
    expect(files.files, isEmpty);
  });
}
