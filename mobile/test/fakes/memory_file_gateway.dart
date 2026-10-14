import 'dart:convert';
import 'dart:typed_data';

import 'package:gym_tracker/core/storage/file_gateway.dart';

class SimulatedCrash implements Exception {
  const new(this.operation);

  final String operation;
}

/// In-memory files; [crashOn] makes the named operation throw once, before
/// it has any effect, to simulate the app dying mid-save.
class MemoryFileGateway implements FileGateway {
  final Map<String, Uint8List> files = {};
  String? crashOn;

  void _maybeCrash(String operation) {
    if (crashOn == operation) {
      crashOn = null;
      throw SimulatedCrash(operation);
    }
  }

  String? text(String name) {
    final bytes = files[name];
    return bytes == null ? null : utf8.decode(bytes);
  }

  @override
  String absolutePath(String name) => '/memory/$name';

  @override
  Future<String?> readString(String name) async => text(name);

  @override
  Future<Uint8List?> readBytes(String name) async => files[name];

  @override
  Future<void> writeString(String name, String contents) async {
    _maybeCrash('write');
    files[name] = Uint8List.fromList(utf8.encode(contents));
  }

  @override
  Future<void> writeBytes(String name, List<int> bytes) async {
    _maybeCrash('write');
    files[name] = Uint8List.fromList(bytes);
  }

  @override
  Future<bool> exists(String name) async => files.containsKey(name);

  @override
  Future<void> copy(String from, String to) async {
    _maybeCrash('copy');
    files[to] = Uint8List.fromList(files[from]!);
  }

  @override
  Future<void> rename(String from, String to) async {
    _maybeCrash('rename');
    files[to] = files.remove(from)!;
  }

  @override
  Future<void> delete(String name) async {
    files.remove(name);
  }
}
