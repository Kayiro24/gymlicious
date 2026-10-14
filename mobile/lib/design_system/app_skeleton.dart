import 'package:flutter/material.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/motion.dart';

/// Placeholder block with a soft shimmer, static when motion is reduced.
class AppSkeleton extends StatefulWidget {
  const new({
    super.key,
    this.width,
    this.height = TokenSpace.lg,
    this.radius = TokenSpace.sm,
  });

  /// A text-line placeholder at [widthFactor] of the available width.
  const new line({super.key, double widthFactor = 1})
    : width = widthFactor,
      height = TokenSpace.md,
      radius = TokenSpace.xs;

  static const shimmerPeriod = Duration(milliseconds: 1400);

  final double? width;
  final double height;
  final double radius;

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppSkeleton.shimmerPeriod,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.isReduced(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final width = widget.width;
    final block = AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          gradient: LinearGradient(
            begin: Alignment(-1 + 2 * _controller.value - 0.6, 0),
            end: Alignment(-1 + 2 * _controller.value + 0.6, 0),
            colors: [
              colors.surfaceMuted,
              Color.lerp(colors.surfaceMuted, colors.surface, 0.7)!,
              colors.surfaceMuted,
            ],
          ),
        ),
        child: SizedBox(height: widget.height),
      ),
    );
    final sized = width != null && width <= 1
        ? FractionallySizedBox(widthFactor: width, child: block)
        : SizedBox(width: width, child: block);
    return ExcludeSemantics(child: sized);
  }
}
