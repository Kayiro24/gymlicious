import 'package:flutter/material.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/motion.dart';

/// Small spinning loader; a static muted ring when motion is reduced.
class AppLoadingRing extends StatelessWidget {
  const new({
    required this.semanticLabel,
    super.key,
    this.size = TokenSpace.xl - TokenSpace.xs,
    this.color,
  });

  final String semanticLabel;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isReduced = AppMotion.isReduced(context);
    return Semantics(
      label: semanticLabel,
      child: SizedBox.square(
        dimension: size,
        child: CircularProgressIndicator(
          value: isReduced ? 0.75 : null,
          strokeWidth: size / 8,
          strokeCap: StrokeCap.round,
          color: color ?? colors.accent,
          backgroundColor: colors.surfaceMuted,
        ),
      ),
    );
  }
}
