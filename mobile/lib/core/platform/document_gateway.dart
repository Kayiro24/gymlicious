import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

typedef PickedDocument = ({String name, Uint8List bytes});

/// System "create document" / "open document" pickers (SAF on Android,
/// Files on iOS); no storage permissions needed.
abstract interface class DocumentGateway {
  /// Returns false when the user cancels.
  Future<bool> saveDocument({
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
  });

  /// Returns null when the user cancels.
  Future<PickedDocument?> pickDocument();
}

class FilePickerDocumentGateway implements DocumentGateway {
  const new();

  @override
  Future<bool> saveDocument({
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
  }) async {
    final uri = await FilePicker.saveFile(
      fileName: fileName,
      bytes: bytes,
      mimeType: mimeType,
    );
    return uri != null;
  }

  @override
  Future<PickedDocument?> pickDocument() async {
    final file = await FilePicker.pickFile();
    if (file == null) {
      return null;
    }
    return (name: file.name, bytes: await file.readAsBytes());
  }
}
