import 'dart:io';
import 'dart:typed_data';

import 'package:gym_tracker/core/storage/file_gateway.dart';
import 'package:path/path.dart' as p;

class IoFileGateway implements FileGateway {
  new(this.directory);

  final Directory directory;

  File _file(String name) => File(p.join(directory.path, name));

  @override
  String absolutePath(String name) => _file(name).path;

  @override
  Future<String?> readString(String name) async {
    final file = _file(name);
    return file.existsSync() ? await file.readAsString() : null;
  }

  @override
  Future<Uint8List?> readBytes(String name) async {
    final file = _file(name);
    return file.existsSync() ? await file.readAsBytes() : null;
  }

  @override
  Future<void> writeString(String name, String contents) async {
    await _file(name).writeAsString(contents, flush: true);
  }

  @override
  Future<void> writeBytes(String name, List<int> bytes) async {
    await _file(name).writeAsBytes(bytes, flush: true);
  }

  @override
  Future<bool> exists(String name) async => _file(name).existsSync();

  @override
  Future<void> copy(String from, String to) async {
    await _file(from).copy(_file(to).path);
  }

  @override
  Future<void> rename(String from, String to) async {
    await _file(from).rename(_file(to).path);
  }

  @override
  Future<void> delete(String name) async {
    final file = _file(name);
    if (file.existsSync()) {
      await file.delete();
    }
  }
}
