import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/platform/document_gateway.dart';
import 'package:gym_tracker/core/platform/notification_gateway.dart';
import 'package:gym_tracker/core/platform/photo_gateway.dart';
import 'package:gym_tracker/core/platform/share_gateway.dart';
import 'package:gym_tracker/core/platform/wallpaper_gateway.dart';

final documentGatewayProvider = Provider<DocumentGateway>(
  (ref) => const FilePickerDocumentGateway(),
);

final shareGatewayProvider = Provider<ShareGateway>(
  (ref) => const SystemShareGateway(),
);

final photoGatewayProvider = Provider<PhotoGateway>(
  (ref) => ImagePickerPhotoGateway(),
);

final wallpaperGatewayProvider = Provider<WallpaperGateway>(
  (ref) => const NativeWallpaperGateway(),
);

final notificationGatewayProvider = Provider<NotificationGateway>(
  (ref) => LocalNotificationGateway(),
);
