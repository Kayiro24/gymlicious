import 'package:flutter/material.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_loading_ring.dart';

enum AppButtonVariant { primary, secondary, quiet, danger }

/// Pill button; primary is 56 dp tall so the main action is unmistakable.
/// While [isLoading] the label becomes a spinner, the width is kept and taps
/// are ignored.
class AppButton extends StatelessWidget {
  const new({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (background, foreground) = switch (variant) {
      AppButtonVariant.primary => (colors.accent, colors.onAccent),
      AppButtonVariant.secondary => (colors.accentSoft, colors.textPrimary),
      AppButtonVariant.quiet => (Colors.transparent, colors.accent),
      AppButtonVariant.danger => (colors.danger, colors.onDanger),
    };
    final labelStyle = context.textStyles.labelLarge?.copyWith(
      color: foreground,
      fontWeight: FontWeight.w700,
    );
    final height = variant == AppButtonVariant.quiet
        ? TokenLayout.minTouchTarget
        : TokenLayout.primaryButtonHeight;
    final content = Row(
      mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: TokenSpace.xl - TokenSpace.xs, color: foreground),
          const SizedBox(width: TokenSpace.sm),
        ],
        Flexible(
          child: Text(label, style: labelStyle, textAlign: TextAlign.center),
        ),
      ],
    );
    return Semantics(
      button: true,
      enabled: onPressed != null && !isLoading,
      label: isLoading ? AppLocalizations.of(context).commonLoading : null,
      child: TextButton(
        onPressed: isLoading ? () {} : onPressed,
        style: TextButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          disabledBackgroundColor: colors.surfaceMuted,
          disabledForegroundColor: colors.textSecondary,
          minimumSize: Size(TokenLayout.minTouchTarget * 2, height),
          padding: const EdgeInsets.symmetric(
            horizontal: TokenSpace.xl,
            vertical: TokenSpace.md,
          ),
          shape: const StadiumBorder(),
          splashFactory: isLoading ? NoSplash.splashFactory : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Visibility.maintain(visible: !isLoading, child: content),
            if (isLoading)
              AppLoadingRing(
                semanticLabel: AppLocalizations.of(context).commonLoading,
                color: foreground,
              ),
          ],
        ),
      ),
    );
  }
}
