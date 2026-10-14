import 'package:flutter/material.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ErrorState extends StatelessWidget {
  const new({required this.message, super.key, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.all(TokenSpace.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.cloudAlert,
            size: TokenSpace.xxxl,
            color: colors.danger,
          ),
          const SizedBox(height: TokenSpace.md),
          Text(l10n.errorStateTitle, style: context.textStyles.titleMedium),
          const SizedBox(height: TokenSpace.xs),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.textStyles.bodyMedium?.copyWith(
              color: colors.textSecondary,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: TokenSpace.lg),
            AppButton(
              label: l10n.commonRetry,
              onPressed: onRetry,
              variant: AppButtonVariant.secondary,
            ),
          ],
        ],
      ),
    );
  }
}
