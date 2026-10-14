import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// The system share sheet, plus Android's direct-to-WhatsApp intent.
abstract interface class ShareGateway {
  bool get supportsWhatsAppDirect;

  /// Returns false when sharing was dismissed or is unavailable.
  Future<bool> shareFile({
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
    String? text,
  });

  /// Opens WhatsApp (or WhatsApp Business) with the file attached; false
  /// when neither is installed so the caller can fall back to the sheet.
  Future<bool> shareToWhatsApp({
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
  });
}

class SystemShareGateway implements ShareGateway {
  const new();

  static const channel = MethodChannel('gymtracker/share');
  static const _exportFolder = 'exports';

  @override
  bool get supportsWhatsAppDirect => Platform.isAndroid;

  /// Shared files live in the cache's exports folder, replaced on each share
  /// so old backups don't pile up.
  Future<File> _writeExport(String fileName, Uint8List bytes) async {
    final directory = Directory(
      p.join((await getTemporaryDirectory()).path, _exportFolder),
    );
    if (directory.existsSync()) {
      await directory.delete(recursive: true);
    }
    await directory.create(recursive: true);
    final file = File(p.join(directory.path, fileName));
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  @override
  Future<bool> shareFile({
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
    String? text,
  }) async {
    final file = await _writeExport(fileName, bytes);
    final result = await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: mimeType)],
        text: text,
      ),
    );
    return result.status != ShareResultStatus.dismissed &&
        result.status != ShareResultStatus.unavailable;
  }

  @override
  Future<bool> shareToWhatsApp({
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
  }) async {
    if (!supportsWhatsAppDirect) {
      return false;
    }
    final file = await _writeExport(fileName, bytes);
    try {
      final opened = await channel.invokeMethod<bool>('shareToWhatsApp', {
        'path': file.path,
        'mimeType': mimeType,
      });
      return opened ?? false;
    } on PlatformException {
      return false;
    }
  }
}
