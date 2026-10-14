import 'package:flutter/material.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';

/// Settings-style row: icon, title, optional subtitle and trailing widget.
class AppListTile extends StatelessWidget {
  const new({
    required this.title,
    super.key,
    this.subtitle,
    this.leadingIcon,
    this.trailing,
    this.onTap,
    this.isDestructive = false,
  });

  final String title;
  final String? subtitle;
  final IconData? leadingIcon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground = isDestructive ? colors.danger : colors.textPrimary;
    final detail = subtitle;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TokenRadius.input),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: TokenLayout.minTouchTarget + TokenSpace.sm,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: TokenSpace.lg,
            vertical: TokenSpace.sm,
          ),
          child: Row(
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, color: foreground),
                const SizedBox(width: TokenSpace.lg),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: context.textStyles.bodyLarge?.copyWith(
                        color: foreground,
                      ),
                    ),
                    if (detail != null)
                      Text(detail, style: context.textStyles.bodySmall),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: TokenSpace.sm),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
