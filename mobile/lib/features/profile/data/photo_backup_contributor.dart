import 'dart:convert';
import 'dart:typed_data';

import 'package:gym_tracker/core/backup/backup_contributor.dart';
import 'package:gym_tracker/features/profile/data/photo_store.dart';

/// Embeds the stored JPEG bytes unchanged, so restore is lossless (D5).
class PhotoBackupContributor implements BackupContributor {
  const new(this.photos);

  static const key = 'photoBase64';

  final PhotoStore photos;

  @override
  String get payloadKey => key;

  @override
  bool get isOptional => true;

  @override
  Future<Object?> export() async {
    final bytes = await photos.read();
    return bytes == null ? null : base64Encode(bytes);
  }

  @override
  String? validate(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is! String) {
      return 'photo must be base64 text';
    }
    try {
      base64Decode(value);
      return null;
    } on FormatException {
      return 'photo is not valid base64';
    }
  }

  @override
  Future<void> restore(Object? value) async {
    if (value is String) {
      await photos.write(Uint8List.fromList(base64Decode(value)));
    } else {
      await photos.delete();
    }
  }
}
