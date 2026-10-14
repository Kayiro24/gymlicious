import 'package:flutter/material.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/flame_shape.dart';
import 'package:gym_tracker/design_system/motion.dart';

enum FlameTier {
  none,
  spark,
  steady,
  blazing,
  legendary;

  static FlameTier forStreak(int days) => switch (days) {
    >= TokenFlame.tier4Days => legendary,
    >= TokenFlame.tier3Days => blazing,
    >= TokenFlame.tier2Days => steady,
    >= TokenFlame.tier1Days => spark,
    _ => none,
  };
}

/// Streak flame that grows a little per tier and pulses when the streak
/// goes up. Decorative: the caller labels the streak for screen readers.
class FlameIcon extends StatefulWidget {
  const new({required this.streakDays, super.key, this.size});

  final int streakDays;

  /// Overrides the tier-based size.
  final double? size;

  @override
  State<FlameIcon> createState() => _FlameIconState();
}

class _FlameIconState extends State<FlameIcon>
    with SingleTickerProviderStateMixin {
  late final _pulse = AnimationController(
    vsync: this,
    duration: TokenMotion.pulse,
  );
  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween<double>(begin: 1, end: TokenFlame.pulseScale),
      weight: 40,
    ),
    TweenSequenceItem(
      tween: Tween<double>(begin: TokenFlame.pulseScale, end: 1),
      weight: 60,
    ),
  ]).animate(CurvedAnimation(parent: _pulse, curve: AppMotion.curve));

  @override
  void didUpdateWidget(FlameIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.streakDays > oldWidget.streakDays &&
        !AppMotion.isReduced(context)) {
      _pulse.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tier = FlameTier.forStreak(widget.streakDays);
    final size =
        widget.size ??
        TokenFlame.baseSize * (1 + TokenFlame.growthPerTier * tier.index);
    return ExcludeSemantics(
      child: ScaleTransition(
        scale: _scale,
        child: SizedBox.square(
          dimension: size,
          child: CustomPaint(
            painter: _FlamePainter(tier: tier, colors: context.colors),
          ),
        ),
      ),
    );
  }
}

class _FlamePainter extends CustomPainter {
  new({required this.tier, required this.colors});

  final FlameTier tier;
  final AppColors colors;

  static const _outlineRatio = 0.06;
  static const _glowOpacity = 0.45;

  @override
  void paint(Canvas canvas, Size size) {
    final outer = FlameShape.path(Offset.zero & size, FlameShape.outer);
    if (tier == FlameTier.none) {
      canvas.drawPath(
        outer,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * _outlineRatio
          ..strokeJoin = StrokeJoin.round
          ..color = colors.textSecondary
          ..isAntiAlias = true,
      );
      return;
    }
    if (tier.index >= FlameTier.blazing.index) {
      final glow = tier == FlameTier.legendary ? colors.gold : colors.ember;
      canvas.drawPath(
        outer,
        Paint()
          ..color = glow.withValues(alpha: _glowOpacity)
          ..maskFilter = MaskFilter.blur(
            BlurStyle.normal,
            TokenElevation.glowBlur * size.width / TokenFlame.baseSize / 2,
          ),
      );
    }
    final rect = Offset.zero & size;
    canvas.drawPath(
      outer,
      Paint()
        ..isAntiAlias = true
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: tier == FlameTier.spark
              ? [colors.ember, colors.ember]
              : [colors.ember, colors.gold],
        ).createShader(rect),
    );
    if (tier.index >= FlameTier.steady.index) {
      canvas.drawPath(
        FlameShape.path(Offset.zero & size, FlameShape.core),
        Paint()
          ..isAntiAlias = true
          ..color = switch (tier) {
            FlameTier.legendary when colors.isDark => colors.textPrimary,
            FlameTier.legendary => colors.surface,
            _ => colors.gold,
          },
      );
    }
  }

  @override
  bool shouldRepaint(_FlamePainter oldDelegate) =>
      oldDelegate.tier != tier || oldDelegate.colors != colors;
}
