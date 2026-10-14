import 'dart:isolate';
import 'dart:typed_data';

import 'package:gym_tracker/core/storage/file_gateway.dart';
import 'package:gym_tracker/features/profile/domain/photo_crop.dart';
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

  /// Crops to [crop] (or the centre square when null) and resizes to at
  /// most [maxSize] as JPEG. Returns null when [source] isn't an image.
  static Future<Uint8List?> prepare(Uint8List source, {PhotoCrop? crop}) =>
      Isolate.run(() => _squareJpeg(source, crop));
}

Uint8List? _squareJpeg(Uint8List source, PhotoCrop? crop) {
  final decoded = img.decodeImage(source);
  if (decoded == null) {
    return null;
  }
  final oriented = img.bakeOrientation(decoded);
  final framed = crop == null ? oriented : _cropTo(oriented, crop);
  final side = framed.width < framed.height ? framed.width : framed.height;
  final target = side < PhotoStore.maxSize ? side : PhotoStore.maxSize;
  final square = img.copyResizeCropSquare(framed, size: target);
  return img.encodeJpg(square, quality: PhotoStore.jpegQuality);
}

img.Image _cropTo(img.Image image, PhotoCrop crop) {
  int clampTo(double value, int limit) => value.round().clamp(0, limit);
  final x = clampTo(crop.left * image.width, image.width - 1);
  final y = clampTo(crop.top * image.height, image.height - 1);
  return img.copyCrop(
    image,
    x: x,
    y: y,
    width: clampTo(
      crop.width * image.width,
      image.width - x,
    ).clamp(1, image.width),
    height: clampTo(
      crop.height * image.height,
      image.height - y,
    ).clamp(1, image.height),
  );
}
