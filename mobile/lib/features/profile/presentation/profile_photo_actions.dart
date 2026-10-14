import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/failure/result.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/platform/photo_gateway.dart';
import 'package:gym_tracker/core/platform/platform_providers.dart';
import 'package:gym_tracker/design_system/app_toast.dart';
import 'package:gym_tracker/features/profile/presentation/screens/photo_crop_screen.dart';
import 'package:gym_tracker/features/profile/presentation/state/profile_controller.dart';

abstract final class ProfilePhotoActions {
  /// Picks a photo, lets the user frame it, then stores it; a kind toast
  /// explains any failure.
  static Future<void> pick(
    BuildContext context,
    WidgetRef ref,
    PhotoSource source,
  ) async {
    final l10n = AppLocalizations.of(context);
    final Uint8List? bytes;
    try {
      bytes = await ref.read(photoGatewayProvider).pick(source);
    } on Exception {
      if (context.mounted) {
        showAppToast(context, l10n.photoPickerFailed);
      }
      return;
    }
    if (bytes == null || !context.mounted) {
      return;
    }
    final crop = await PhotoCropScreen.open(context, bytes);
    if (crop == null) {
      return;
    }
    final result = await ref
        .read(profileControllerProvider.notifier)
        .setPhoto(bytes, crop: crop);
    if (result is Err && context.mounted) {
      showAppToast(context, l10n.profilePhotoFailed);
    }
  }

  static Future<void> remove(WidgetRef ref) =>
      ref.read(profileControllerProvider.notifier).removePhoto();
}
