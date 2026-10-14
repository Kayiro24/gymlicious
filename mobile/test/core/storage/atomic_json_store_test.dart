import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/core/storage/atomic_json_store.dart';
import 'package:gym_tracker/core/storage/data_store.dart';

import '../../fakes/memory_file_gateway.dart';

bool _acceptAll(JsonMap _) => true;

void main() {
  late MemoryFileGateway files;
  late AtomicJsonStore store;

  setUp(() {
    files = MemoryFileGateway();
    store = AtomicJsonStore(files: files);
  });

  Future<JsonMap> loadDocument() async {
    final result = await store.load(isValid: _acceptAll);
    return (result as StoreLoaded).document;
  }

  test('empty directory loads as empty', () async {
    expect(await store.load(isValid: _acceptAll), isA<StoreEmpty>());
  });

  test(
    'save then load round-trips and keeps the previous file as .bak',
    () async {
      await store.save({'value': 1});
      await store.save({'value': 2});

      expect(await loadDocument(), {'value': 2});
      expect(jsonDecode(files.text(store.backupName)!), {'value': 1});
      expect(files.files.containsKey('gymtracker_data.json.tmp'), isFalse);
    },
  );

  for (final operation in ['write', 'copy', 'rename']) {
    test('a crash during $operation never loses the last saved data', () async {
      await store.save({'value': 1});
      files.crashOn = operation;

      await expectLater(
        store.save({'value': 2}),
        throwsA(isA<SimulatedCrash>()),
      );

      expect(await loadDocument(), {'value': 1});
    });
  }

  test('a corrupted primary falls back to the backup copy', () async {
    await store.save({'value': 1});
    await store.save({'value': 2});
    await files.writeString(AtomicJsonStore.defaultFileName, '{broken');

    final result = await store.load(isValid: _acceptAll);

    expect(result, isA<StoreLoaded>());
    final loaded = result as StoreLoaded;
    expect(loaded.document, {'value': 1});
    expect(loaded.isRecoveredFromBackup, isTrue);
  });

  test('a primary rejected by validation falls back to the backup', () async {
    await store.save({'value': 1});
    await store.save({'value': 'bad'});

    final result = await store.load(isValid: (json) => json['value'] is int);

    expect((result as StoreLoaded).document, {'value': 1});
  });

  test('both files unreadable reports corruption', () async {
    await files.writeString(AtomicJsonStore.defaultFileName, 'nope');
    await files.writeString(store.backupName, '[]');

    expect(await store.load(isValid: _acceptAll), isA<StoreCorrupted>());
  });

  test('saves are serialised in submission order', () async {
    final saves = [
      for (var i = 0; i < 20; i++) store.save({'value': i}),
    ];
    await Future.wait(saves);

    expect(await loadDocument(), {'value': 19});
  });

  test('deleteAll removes every data file', () async {
    await store.save({'value': 1});
    await store.save({'value': 2});
    await store.deleteAll();

    expect(files.files, isEmpty);
  });
}
