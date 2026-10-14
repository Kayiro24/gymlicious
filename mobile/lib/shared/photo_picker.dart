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
    final bytes = photoBytes;
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: isBusy ? null : () => _showOptions(context),
        borderRadius: BorderRadius.circular(TokenRadius.card),
        child: Padding(
          padding: const EdgeInsets.all(TokenSpace.xs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  if (bytes == null)
                    const _Silhouette(size: avatarSize)
                  else
                    AppAvatar(name: name, photoBytes: bytes, size: avatarSize),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(
                        TokenSpace.xs + TokenSpace.xxs,
                      ),
                      decoration: BoxDecoration(
                        color: colors.accent,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.background, width: 2),
                      ),
                      child: Icon(
                        photoBytes == null
                            ? LucideIcons.plus
                            : LucideIcons.pencil,
                        size: TokenSpace.lg,
                        color: colors.onAccent,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TokenSpace.sm),
              ExcludeSemantics(
                child: Text(
                  label,
                  style: context.textStyles.labelLarge?.copyWith(
                    color: colors.accent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The default "no photo yet" person, so the picker never looks empty.
class _Silhouette extends StatelessWidget {
  const new({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: CustomPaint(painter: _SilhouettePainter(context.colors)),
  );
}

class _SilhouettePainter extends CustomPainter {
  new(this.colors);

  final AppColors colors;

  static const _headCentreY = 0.38;
  static const _headRadius = 0.19;
  static const _bodyCentreY = 1.0;
  static const _bodyWidth = 0.78;
  static const _bodyHeight = 0.62;
  static const _figureOpacity = 0.45;

  @override
  void paint(Canvas canvas, Size size) {
    final circle = Offset.zero & size;
    canvas
      ..save()
      ..clipPath(Path()..addOval(circle))
      ..drawRect(circle, Paint()..color = colors.surfaceMuted);
    final figure = Paint()
      ..color = colors.textSecondary.withValues(alpha: _figureOpacity);
    canvas
      ..drawCircle(
        Offset(size.width / 2, size.height * _headCentreY),
        size.width * _headRadius,
        figure,
      )
      ..drawOval(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height * _bodyCentreY),
          width: size.width * _bodyWidth,
          height: size.height * _bodyHeight,
        ),
        figure,
      )
      ..restore();
  }

  @override
  bool shouldRepaint(_SilhouettePainter oldDelegate) =>
      oldDelegate.colors != colors;
}
