import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/motion.dart';

/// Determinate ring (ember into gold) with an optional centre label. The
/// fill animates on change; the caller's [semanticLabel] carries the value.
class ProgressRing extends StatelessWidget {
  const new({
    required this.value,
    required this.semanticLabel,
    super.key,
    this.size = TokenSpace.xxxl * 2,
    this.strokeWidth = TokenSpace.sm + TokenSpace.xxs,
    this.child,
  });

  /// 0 to 1; values outside are clamped.
  final double value;
  final String semanticLabel;
  final double size;
  final double strokeWidth;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      label: semanticLabel,
      container: true,
      child: ExcludeSemantics(
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: value.clamp(0, 1).toDouble()),
          duration: AppMotion.of(context, TokenMotion.slow),
          curve: AppMotion.curve,
          builder: (context, progress, child) => CustomPaint(
            painter: _RingPainter(
              progress: progress,
              track: colors.surfaceMuted,
              fire: colors.fireColors,
              strokeWidth: strokeWidth,
            ),
            child: child,
          ),
          child: SizedBox.square(
            dimension: size,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(strokeWidth + TokenSpace.xs),
                child: FittedBox(fit: BoxFit.scaleDown, child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  new({
    required this.progress,
    required this.track,
    required this.fire,
    required this.strokeWidth,
  });

  final double progress;
  final Color track;
  final List<Color> fire;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(strokeWidth / 2);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    canvas.drawArc(rect, 0, math.pi * 2, false, base..color = track);
    if (progress <= 0) {
      return;
    }
    const start = -math.pi / 2;
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..shader = SweepGradient(
        colors: fire,
        transform: const GradientRotation(start),
      ).createShader(rect);
    canvas.drawArc(rect, start, math.pi * 2 * progress, false, arc);
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.track != track ||
      oldDelegate.fire != fire;
}
