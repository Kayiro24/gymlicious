import 'dart:isolate';
import 'dart:typed_data';

import 'package:gym_tracker/core/storage/file_gateway.dart';
import 'package:image/image.dart' as img;

/// The profile photo lives in its own file, never inlined in the data file.
class PhotoStore {
  const new(this.files);

  static const fileName = 'profile_photo.jpg';
  static const maxSize = 512;
  static const jpegQuality = 80;

  final FileGateway files;

  Future<Uint8List?> read() => files.readBytes(fileName);

  Future<void> write(Uint8List jpegBytes) =>
      files.writeBytes(fileName, jpegBytes);

  Future<void> delete() => files.delete(fileName);

  /// Centre-crops to a square and resizes to at most [maxSize] as JPEG.
  /// Returns null when [source] is not a decodable image.
  static Future<Uint8List?> prepare(Uint8List source) =>
      Isolate.run(() => _squareJpeg(source));
}

Uint8List? _squareJpeg(Uint8List source) {
  final decoded = img.decodeImage(source);
  if (decoded == null) {
    return null;
  }
  final oriented = img.bakeOrientation(decoded);
  final side = oriented.width < oriented.height
      ? oriented.width
      : oriented.height;
  final target = side < PhotoStore.maxSize ? side : PhotoStore.maxSize;
  final square = img.copyResizeCropSquare(oriented, size: target);
  return img.encodeJpg(square, quality: PhotoStore.jpegQuality);
}
