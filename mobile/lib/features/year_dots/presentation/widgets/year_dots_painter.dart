import 'package:flutter/rendering.dart';
import 'package:gym_tracker/core/theme/app_theme.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/features/year_dots/domain/dot_layout.dart';
import 'package:gym_tracker/features/year_dots/domain/year_progress.dart';
import 'package:gym_tracker/features/year_dots/presentation/widgets/year_dots_palette.dart';

/// Draws a computed [DotLayout]. Today is filled with the accent and ringed
/// so it reads without colour (spec 5.10 A3). Same rules as the Kotlin
/// wallpaper renderer.
class YearDotsPainter extends CustomPainter {
  new({
    required this.layout,
    required this.progress,
    required this.palette,
    this.monthInitials = const [],
    this.dotLabel,
    this.origin = Offset.zero,
  });

  static const _labelSizeRatio = 0.8;

  final DotLayout layout;
  final YearProgress progress;
  final YearDotsPalette palette;
  final List<String> monthInitials;
  final String Function(int dayIndex)? dotLabel;
  final Offset origin;

  Rect _rect(DotRect cell) => Rect.fromLTWH(
    origin.dx + cell.left,
    origin.dy + cell.top,
    cell.width,
    cell.height,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final radius = Radius.circular(
      layout.cellWidth * TokenYearDots.cornerRatio,
    );
    final fill = Paint()..isAntiAlias = true;
    for (final (index, cell) in layout.cells.indexed) {
      final state = progress.stateOf(index);
      fill.color = switch (state) {
        DotState.done => palette.done,
        DotState.today => palette.today,
        DotState.left => palette.left,
      };
      final rect = _rect(cell);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), fill);
      if (state == DotState.today) {
        final ringWidth = layout.cellWidth * TokenYearDots.todayOutlineRatio;
        final ring = Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.stroke
          ..strokeWidth = ringWidth
          ..color = palette.today;
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect.inflate(ringWidth * 1.5), radius),
          ring,
        );
      }
    }
    _paintMonthInitials(canvas);
  }

  void _paintMonthInitials(Canvas canvas) {
    if (monthInitials.length != layout.monthLabels.length) {
      return;
    }
    for (final (index, label) in layout.monthLabels.indexed) {
      final rect = _rect(label);
      final painter = TextPainter(
        text: TextSpan(
          text: monthInitials[index],
          style: TextStyle(
            color: palette.text,
            fontSize: rect.height * _labelSizeRatio,
            fontFamily: AppTheme.fontFamily,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter
        ..paint(
          canvas,
          Offset(rect.left, rect.top + (rect.height - painter.height) / 2),
        )
        ..dispose();
    }
  }

  @override
  SemanticsBuilderCallback? get semanticsBuilder {
    final label = dotLabel;
    if (label == null) {
      return null;
    }
    return (size) => [
      for (final (index, cell) in layout.cells.indexed)
        CustomPainterSemantics(
          rect: _rect(cell),
          properties: SemanticsProperties(
            label: label(index),
            textDirection: TextDirection.ltr,
          ),
        ),
    ];
  }

  @override
  bool shouldRepaint(YearDotsPainter oldDelegate) =>
      oldDelegate.layout != layout ||
      oldDelegate.progress.today != progress.today ||
      oldDelegate.palette != palette ||
      oldDelegate.origin != origin;

  @override
  bool shouldRebuildSemantics(YearDotsPainter oldDelegate) =>
      shouldRepaint(oldDelegate);
}
