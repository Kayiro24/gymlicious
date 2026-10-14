import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/platform/photo_gateway.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_avatar.dart';
import 'package:gym_tracker/design_system/app_list_tile.dart';
import 'package:gym_tracker/design_system/app_sheet.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Avatar with an optional photo; tapping offers camera, gallery or remove.
class PhotoPicker extends StatelessWidget {
  const new({
    required this.name,
    required this.photoBytes,
    required this.onPick,
    required this.onRemove,
    super.key,
    this.isBusy = false,
  });

  static const double avatarSize = TokenSpace.xxxl * 2;

  final String name;
  final Uint8List? photoBytes;
  final ValueChanged<PhotoSource> onPick;
  final VoidCallback onRemove;
  final bool isBusy;

  Future<void> _showOptions(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    await showAppSheet<void>(
      context: context,
      builder: (sheetContext) {
        void choose(VoidCallback action) {
          Navigator.of(sheetContext).pop();
          action();
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppListTile(
              leadingIcon: LucideIcons.camera,
              title: l10n.photoPickerCamera,
              onTap: () => choose(() => onPick(PhotoSource.camera)),
            ),
            AppListTile(
              leadingIcon: LucideIcons.image,
              title: l10n.photoPickerGallery,
              onTap: () => choose(() => onPick(PhotoSource.gallery)),
            ),
            if (photoBytes != null)
              AppListTile(
                leadingIcon: LucideIcons.trash2,
                title: l10n.photoPickerRemove,
                isDestructive: true,
                onTap: () => choose(onRemove),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final label = photoBytes == null
        ? l10n.photoPickerAdd
        : l10n.photoPickerChange;
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: isBusy ? null : () => _showOptions(context),
        customBorder: const CircleBorder(),
        child: Stack(
          children: [
            AppAvatar(name: name, photoBytes: photoBytes, size: avatarSize),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(TokenSpace.xs + TokenSpace.xxs),
                decoration: BoxDecoration(
                  color: colors.accent,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.background, width: 2),
                ),
                child: Icon(
                  photoBytes == null ? LucideIcons.plus : LucideIcons.pencil,
                  size: TokenSpace.lg,
                  color: colors.onAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
