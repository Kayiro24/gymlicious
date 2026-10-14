// Regenerates every icon, splash image and the in-app brand mark from the
// Gymlicious logo (branding/gymlicious-logo.png):
//   flutter test tool/app_icon/generate_app_icons_test.dart
// Not part of the normal test run; commit the files it writes.
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';

const _source = '../branding/gymlicious-logo.png';
const _ios = 'ios/Runner/Assets.xcassets';
const _res = 'android/app/src/main/res';

/// Logo width as a share of the icon: full tiles, and the adaptive-icon
/// foreground, which must keep the logo inside the 66 dp safe circle.
const _tileLogoRatio = 0.78;
const _adaptiveLogoRatio = 0.5;
const _legacyCornerRatio = 0.22;
const _alphaThreshold = 16;

const Color _background = LightTokenColors.background;

/// The logo cropped to its visible pixels.
class _Logo {
  new(this.image, this.crop);

  final ui.Image image;
  final Rect crop;

  static Future<_Logo> load() async {
    final codec = await ui.instantiateImageCodec(
      File(_source).readAsBytesSync(),
    );
    final image = (await codec.getNextFrame()).image;
    final pixels = (await image.toByteData())!;
    var (left, top, right, bottom) = (image.width, image.height, 0, 0);
    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        if (pixels.getUint8((y * image.width + x) * 4 + 3) > _alphaThreshold) {
          left = math.min(left, x);
          right = math.max(right, x);
          top = math.min(top, y);
          bottom = math.max(bottom, y);
        }
      }
    }
    return _Logo(
      image,
      Rect.fromLTRB(left.toDouble(), top.toDouble(), right + 1.0, bottom + 1.0),
    );
  }

  /// Draws the logo [width] wide, centred on [center]; [tint] recolours it
  /// (monochrome icons).
  void paint(Canvas canvas, Offset center, double width, {Color? tint}) {
    final height = width * crop.height / crop.width;
    final paint = Paint()..filterQuality = FilterQuality.high;
    if (tint != null) {
      paint.colorFilter = ColorFilter.mode(tint, BlendMode.srcIn);
    }
    canvas.drawImageRect(
      image,
      crop,
      Rect.fromCenter(center: center, width: width, height: height),
      paint,
    );
  }
}

Future<void> _write(
  String path,
  int width,
  int height,
  void Function(Canvas canvas, Size size) draw,
) async {
  final recorder = ui.PictureRecorder();
  draw(Canvas(recorder), Size(width.toDouble(), height.toDouble()));
  final image = await recorder.endRecording().toImage(width, height);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  File(path)
    ..createSync(recursive: true)
    ..writeAsBytesSync(Uint8List.view(bytes!.buffer));
}

/// A full app-icon tile: warm cream with the logo centred.
Future<void> _tile(
  _Logo logo,
  String path,
  int size, {
  bool isRounded = false,
}) => _write(path, size, size, (canvas, area) {
  final tile = Offset.zero & area;
  final fill = Paint()..color = _background;
  if (isRounded) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(tile, Radius.circular(size * _legacyCornerRatio)),
      fill,
    );
  } else {
    canvas.drawRect(tile, fill);
  }
  logo.paint(canvas, tile.center, size * _tileLogoRatio);
});

/// Transparent square with the logo sized for an adaptive-icon layer.
Future<void> _layer(_Logo logo, String path, int size, {Color? tint}) =>
    _write(path, size, size, (canvas, area) {
      logo.paint(
        canvas,
        area.center(Offset.zero),
        size * _adaptiveLogoRatio,
        tint: tint,
      );
    });

void main() {
  testWidgets('generate Gymlicious icons and brand assets', (tester) async {
    await tester.runAsync(() async {
      final logo = await _Logo.load();

      for (final (name, size) in [
        ('20x20@1x', 20),
        ('20x20@2x', 40),
        ('20x20@3x', 60),
        ('29x29@1x', 29),
        ('29x29@2x', 58),
        ('29x29@3x', 87),
        ('40x40@1x', 40),
        ('40x40@2x', 80),
        ('40x40@3x', 120),
        ('60x60@2x', 120),
        ('60x60@3x', 180),
        ('76x76@1x', 76),
        ('76x76@2x', 152),
        ('83.5x83.5@2x', 167),
        ('1024x1024@1x', 1024),
      ]) {
        await _tile(logo, '$_ios/AppIcon.appiconset/Icon-App-$name.png', size);
      }
      await _tile(logo, '../docs/store/icon-512.png', 512);

      for (final (density, scale) in [
        ('mdpi', 1.0),
        ('hdpi', 1.5),
        ('xhdpi', 2.0),
        ('xxhdpi', 3.0),
        ('xxxhdpi', 4.0),
      ]) {
        final folder = '$_res/mipmap-$density';
        await _tile(
          logo,
          '$folder/ic_launcher.png',
          (48 * scale).round(),
          isRounded: true,
        );
        final layer = (108 * scale).round();
        await _layer(logo, '$folder/ic_launcher_foreground.png', layer);
        await _layer(
          logo,
          '$folder/ic_launcher_monochrome.png',
          layer,
          tint: const Color(0xFF000000),
        );
      }

      const launchWidth = 200;
      final launchHeight = (launchWidth * logo.crop.height / logo.crop.width)
          .round();
      for (final (suffix, scale) in [('', 1), ('@2x', 2), ('@3x', 3)]) {
        await _write(
          '$_ios/LaunchImage.imageset/LaunchImage$suffix.png',
          launchWidth * scale,
          launchHeight * scale,
          (canvas, area) =>
              logo.paint(canvas, area.center(Offset.zero), area.width),
        );
      }

      const markWidth = 1024;
      await _write(
        'assets/brand/gymlicious_mark.png',
        markWidth,
        (markWidth * logo.crop.height / logo.crop.width).round(),
        (canvas, area) =>
            logo.paint(canvas, area.center(Offset.zero), area.width),
      );
    });
  });
}
