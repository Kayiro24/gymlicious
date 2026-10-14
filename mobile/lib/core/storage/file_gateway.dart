import 'dart:typed_data';

/// File access inside the app's private documents directory.
abstract interface class FileGateway {
  Future<String?> readString(String name);

  Future<Uint8List?> readBytes(String name);

  /// Writes and flushes to disk before completing.
  Future<void> writeString(String name, String contents);

  Future<void> writeBytes(String name, List<int> bytes);

  Future<bool> exists(String name);

  Future<void> copy(String from, String to);

  /// Atomically replaces [to] with [from] where the platform allows.
  Future<void> rename(String from, String to);

  Future<void> delete(String name);

  String absolutePath(String name);
}
