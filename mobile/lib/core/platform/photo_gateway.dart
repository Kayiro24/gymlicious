import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

enum PhotoSource { camera, gallery }

/// Camera or system photo picker; no broad storage permission needed.
abstract interface class PhotoGateway {
  /// Returns null when the user cancels.
  Future<Uint8List?> pick(PhotoSource source);
}

class ImagePickerPhotoGateway implements PhotoGateway {
  new([ImagePicker? picker]) : _picker = picker ?? ImagePicker();

  /// Downscaled at pick time so huge camera images never reach memory whole.
  static const _maxPickDimension = 1600.0;

  final ImagePicker _picker;

  @override
  Future<Uint8List?> pick(PhotoSource source) async {
    final file = await _picker.pickImage(
      source: source == PhotoSource.camera
          ? ImageSource.camera
          : ImageSource.gallery,
      maxWidth: _maxPickDimension,
      maxHeight: _maxPickDimension,
    );
    return file == null ? null : await file.readAsBytes();
  }
}
