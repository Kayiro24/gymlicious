import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/providers.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/app_card.dart';
import 'package:gym_tracker/features/backup/presentation/backup_routes.dart';
import 'package:gym_tracker/features/backup/presentation/state/backup_providers.dart';
import 'package:gym_tracker/features/settings/settings.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Dismissible nudge on Home; renders nothing when no reminder is due.
class BackupReminderBanner extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(backupReminderDueProvider)) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    return AppCard(
      color: colors.highlight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(LucideIcons.archive, color: colors.textPrimary),
              const SizedBox(width: TokenSpace.md),
              Expanded(
                child: Text(
                  l10n.backupBannerText,
                  style: context.textStyles.bodyLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: TokenSpace.md),
          Wrap(
            spacing: TokenSpace.sm,
            runSpacing: TokenSpace.xs,
            children: [
              AppButton(
                label: l10n.backupBannerAction,
                variant: AppButtonVariant.secondary,
                onPressed: () => context.push(BackupRoutes.backup),
              ),
              AppButton(
                label: l10n.backupBannerDismiss,
                variant: AppButtonVariant.quiet,
                onPressed: () => ref
                    .read(settingsControllerProvider.notifier)
                    .update(
                      (settings) => settings.copyWith(
                        backupBannerDismissedAt: ref.read(clockProvider).now(),
                      ),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
