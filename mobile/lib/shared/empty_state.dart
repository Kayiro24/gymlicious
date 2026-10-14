import 'package:flutter/material.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';

/// A line illustration, one line of text and at most one action.
class EmptyState extends StatelessWidget {
  const new({
    required this.icon,
    required this.message,
    super.key,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final label = actionLabel;
    return Padding(
      padding: const EdgeInsets.all(TokenSpace.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExcludeSemantics(
            child: Container(
              width: TokenSpace.xxxl * 2,
              height: TokenSpace.xxxl * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: colors.hairline, width: 1.5),
              ),
              child: Icon(
                icon,
                size: TokenSpace.xxxl,
                color: colors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: TokenSpace.lg),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.textStyles.bodyLarge?.copyWith(
              color: colors.textSecondary,
            ),
          ),
          if (label != null && onAction != null) ...[
            const SizedBox(height: TokenSpace.lg),
            AppButton(
              label: label,
              onPressed: onAction,
              variant: AppButtonVariant.secondary,
            ),
          ],
        ],
      ),
    );
  }
}
