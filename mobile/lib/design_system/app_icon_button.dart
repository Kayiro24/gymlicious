import 'package:flutter/material.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';

/// Icon button with a guaranteed 48dp target and a required tooltip label.
class AppIconButton extends StatelessWidget {
  const new({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    super.key,
    this.isFilled = false,
    this.color,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool isFilled;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon),
      color: color ?? colors.textPrimary,
      iconSize: TokenSpace.xl,
      constraints: const BoxConstraints.tightFor(
        width: TokenLayout.minTouchTarget,
        height: TokenLayout.minTouchTarget,
      ),
      style: IconButton.styleFrom(
        backgroundColor: isFilled ? colors.surfaceMuted : null,
        disabledForegroundColor: colors.hairline,
      ),
    );
  }
}
