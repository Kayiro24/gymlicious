import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/layout/content_width.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/features/backup/backup.dart';
import 'package:gym_tracker/shared/confirm_dialog.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Shown when both the data file and its .bak are unreadable (spec 4.1).
class RecoveryScreen extends ConsumerWidget {
  const new({super.key});

  static const path = '/recovery';

  Future<void> _startFresh(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final isConfirmed = await showConfirmDialog(
      context,
      title: l10n.recoveryStartFreshQuestion,
      message: l10n.recoveryStartFreshExplain,
      confirmLabel: l10n.recoveryStartFresh,
      isDestructive: true,
    );
    if (isConfirmed) {
      await BackupActions.resetAllData(ref);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(TokenSpace.xl),
            children: [
              ContentWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: TokenSpace.xxl),
                    Icon(
                      LucideIcons.fileWarning,
                      size: TokenSpace.xxxl,
                      color: context.colors.danger,
                    ),
                    const SizedBox(height: TokenSpace.lg),
                    Text(
                      l10n.recoveryTitle,
                      style: context.textStyles.headlineSmall,
                    ),
                    const SizedBox(height: TokenSpace.sm),
                    Text(
                      l10n.recoveryBody,
                      style: context.textStyles.bodyLarge,
                    ),
                    const SizedBox(height: TokenSpace.xxl),
                    AppButton(
                      label: l10n.recoveryRestore,
                      icon: LucideIcons.upload,
                      isExpanded: true,
                      onPressed: () =>
                          BackupActions.restoreFromFile(context, ref),
                    ),
                    const SizedBox(height: TokenSpace.sm),
                    AppButton(
                      label: l10n.recoveryStartFresh,
                      variant: AppButtonVariant.quiet,
                      isExpanded: true,
                      onPressed: () => _startFresh(context, ref),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
