import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:gym_tracker/core/theme/app_theme.dart';
import 'package:gym_tracker/features/settings/settings_domain.dart';
import 'package:gym_tracker/features/year_dots/domain/dot_layout.dart';
import 'package:gym_tracker/features/year_dots/domain/wallpaper_frame.dart';
import 'package:gym_tracker/features/year_dots/domain/year_progress.dart';
import 'package:gym_tracker/features/year_dots/presentation/widgets/year_dots_painter.dart';
import 'package:gym_tracker/features/year_dots/presentation/widgets/year_dots_palette.dart';

/// Draws the wallpaper at an exact pixel size; used for the exported PNG
/// and, scaled down, for the in-app preview.
abstract final class WallpaperImageRenderer {
  static void paint(
    Canvas canvas,
    Size size, {
    required YearDotsSettings settings,
    required YearProgress progress,
    required String? textLine,
    required List<String> monthInitials,
    required double pixelRatio,
  }) {
    final palette = YearDotsPalette.fromPreset(settings.colorPreset);
    canvas.drawRect(Offset.zero & size, Paint()..color = palette.background);
    final frame = WallpaperFrame.compute(
      width: size.width,
      height: size.height,
      topMarginPercent: settings.topMarginPercent,
      padding: settings.padding * pixelRatio,
      hasText: textLine != null,
    );
    final kind = settings.layout == YearDotsLayout.months
        ? DotLayoutKind.months
        : DotLayoutKind.continuous;
    final layout = DotLayout.compute(
      kind,
      progress.today.year,
      frame.gridWidth,
      frame.gridHeight,
    );
    YearDotsPainter(
      layout: layout,
      progress: progress,
      palette: palette,
      monthInitials: kind == DotLayoutKind.months ? monthInitials : const [],
      origin: Offset(frame.gridLeft, frame.gridTop),
    ).paint(canvas, size);
    if (textLine != null) {
      final text = TextPainter(
        text: TextSpan(
          text: textLine,
          style: TextStyle(
            color: palette.text,
            fontSize: frame.textSize,
            fontFamily: AppTheme.fontFamily,
            fontFeatures: AppTheme.tabularFigures,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: size.width);
      text
        ..paint(
          canvas,
          Offset(
            (size.width - text.width) / 2,
            frame.textCenterY - text.height / 2,
          ),
        )
        ..dispose();
    }
  }

  static Future<Uint8List> renderPng({
    required Size pixelSize,
    required double pixelRatio,
    required YearDotsSettings settings,
    required YearProgress progress,
    required String? textLine,
    required List<String> monthInitials,
  }) async {
    final recorder = ui.PictureRecorder();
    paint(
      Canvas(recorder),
      pixelSize,
      settings: settings,
      progress: progress,
      textLine: textLine,
      monthInitials: monthInitials,
      pixelRatio: pixelRatio,
    );
    final picture = recorder.endRecording();
    final image = await picture.toImage(
      pixelSize.width.round(),
      pixelSize.height.round(),
    );
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    picture.dispose();
    image.dispose();
    return data!.buffer.asUint8List();
  }
}
