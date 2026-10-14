import 'package:flutter/material.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';

/// The one prominent card on a screen: a restrained warm gradient, larger
/// radius and a soft shadow (a faint glow in dark mode).
class HeroCard extends StatelessWidget {
  const new({
    required this.child,
    super.key,
    this.onTap,
    this.padding = const EdgeInsets.all(TokenSpace.xl),
    this.semanticLabel,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = BorderRadius.circular(TokenRadius.hero);
    return Semantics(
      label: semanticLabel,
      button: onTap != null,
      container: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          gradient: colors.heroGradient,
          boxShadow: [
            BoxShadow(
              color: (colors.isDark ? colors.ember : colors.shadow).withValues(
                alpha: TokenElevation.shadowOpacity,
              ),
              blurRadius: TokenElevation.shadowBlur,
              offset: const Offset(0, TokenElevation.shadowOffsetY),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          borderRadius: radius,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}
