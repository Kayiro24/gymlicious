import 'dart:typed_data';

import 'package:gym_tracker/core/clock/clock.dart';
import 'package:gym_tracker/core/platform/document_gateway.dart';
import 'package:gym_tracker/core/platform/notification_gateway.dart';
import 'package:gym_tracker/core/platform/photo_gateway.dart';
import 'package:gym_tracker/core/platform/share_gateway.dart';
import 'package:gym_tracker/core/platform/wallpaper_gateway.dart';
import 'package:gym_tracker/core/storage/data_store.dart';

class FixedClock implements Clock {
  new(this.current);

  DateTime current;

  @override
  DateTime now() => current;
}

/// Keeps the document in memory, with no isolates, so widget tests stay
/// inside fake async.
class MemoryDataStore implements DataStore {
  new([this.document]);

  JsonMap? document;
  bool isCorrupted = false;

  @override
  Future<StoreLoadResult> load({
    required bool Function(JsonMap) isValid,
  }) async {
    if (isCorrupted) {
      return const StoreCorrupted('test');
    }
    final current = document;
    return current == null
        ? const StoreEmpty()
        : StoreLoaded(current, isRecoveredFromBackup: false);
  }

  @override
  Future<void> save(JsonMap document) async => this.document = document;

  @override
  Future<void> deleteAll() async {
    document = null;
    isCorrupted = false;
  }
}

class FakeWallpaperGateway implements WallpaperGateway {
  final List<Map<String, Object?>> pushed = [];

  @override
  Future<bool> isLiveWallpaperSupported() async => false;

  @override
  Future<bool> openLiveWallpaperPicker() async => false;

  @override
  Future<void> pushConfig(Map<String, Object?> config) async =>
      pushed.add(config);

  @override
  Future<bool> saveImageToPhotos(Uint8List pngBytes) async => true;
}

class FakeShareGateway implements ShareGateway {
  final List<String> shared = [];

  @override
  bool get supportsWhatsAppDirect => false;

  @override
  Future<bool> shareFile({
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
    String? text,
  }) async {
    shared.add(fileName);
    return true;
  }

  @override
  Future<bool> shareToWhatsApp({
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
  }) async => false;
}

class FakeDocumentGateway implements DocumentGateway {
  final Map<String, Uint8List> saved = {};
  PickedDocument? toPick;

  @override
  Future<PickedDocument?> pickDocument() async => toPick;

  @override
  Future<bool> saveDocument({
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
  }) async {
    saved[fileName] = bytes;
    return true;
  }
}

class FakePhotoGateway implements PhotoGateway {
  @override
  Future<Uint8List?> pick(PhotoSource source) async => null;
}

class FakeNotificationGateway implements NotificationGateway {
  bool isEnabled = false;
  bool isPermissionGranted = true;
  List<DateTime> checkInReminders = [];

  @override
  Future<bool> scheduleCheckInReminders({
    required List<DateTime> times,
    required String title,
    required String body,
    required String channelName,
  }) async {
    if (!isPermissionGranted) {
      return false;
    }
    checkInReminders = times;
    return true;
  }

  @override
  Future<void> cancelCheckInReminders() async => checkInReminders = [];

  @override
  Future<void> disableWeeklyReminder() async => isEnabled = false;

  @override
  Future<bool> enableWeeklyReminder({
    required String title,
    required String body,
    required String channelName,
  }) async => isEnabled = true;
}
