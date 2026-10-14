import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/layout/content_width.dart';
import 'package:gym_tracker/core/platform/platform_providers.dart';
import 'package:gym_tracker/core/providers.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/app_card.dart';
import 'package:gym_tracker/design_system/app_section_header.dart';
import 'package:gym_tracker/design_system/app_toast.dart';
import 'package:gym_tracker/features/backup/domain/backup_reminder.dart';
import 'package:gym_tracker/features/backup/presentation/backup_actions.dart';
import 'package:gym_tracker/features/backup/presentation/state/backup_providers.dart';
import 'package:gym_tracker/features/backup/presentation/widgets/backup_info_sheet.dart';
import 'package:gym_tracker/features/settings/settings.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class BackupScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  ExportTarget? _busyTarget;
  bool _isRestoring = false;

  Future<void> _export(ExportTarget target) async {
    setState(() => _busyTarget = target);
    await BackupActions.export(context, ref, target);
    if (mounted) {
      setState(() => _busyTarget = null);
    }
  }

  Future<void> _restore() async {
    setState(() => _isRestoring = true);
    await BackupActions.restoreFromFile(context, ref);
    if (mounted) {
      setState(() => _isRestoring = false);
    }
  }

  Future<void> _toggleNotification({required bool isOn}) async {
    final l10n = AppLocalizations.of(context);
    final gateway = ref.read(notificationGatewayProvider);
    var isEnabled = false;
    if (isOn) {
      isEnabled = await gateway.enableWeeklyReminder(
        title: l10n.backupNotificationTitle,
        body: l10n.backupNotificationBody,
        channelName: l10n.backupNotificationChannel,
      );
      if (!isEnabled && mounted) {
        showAppToast(context, l10n.backupNotificationDenied);
      }
    } else {
      await gateway.disableWeeklyReminder();
    }
    ref
        .read(settingsControllerProvider.notifier)
        .update(
          (settings) => settings.copyWith(isBackupNotificationOn: isEnabled),
        );
  }

  String _lastBackupText(AppLocalizations l10n, DateTime? lastBackupAt) {
    if (lastBackupAt == null) {
      return l10n.backupLastNever;
    }
    final today = CalendarDate.fromDateTime(ref.read(clockProvider).now());
    final days = CalendarDate.fromDateTime(lastBackupAt).daysUntil(today);
    return l10n.backupLastAt(l10n.backupDaysAgo(days));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final settings = ref.watch(settingsControllerProvider);
    final share = ref.watch(shareGatewayProvider);
    final hasUndo = ref.watch(undoSnapshotAvailableProvider).value ?? false;
    final isOld = BackupReminder.isOld(
      now: ref.watch(clockProvider).now(),
      lastBackupAt: settings.lastBackupAt,
    );
    final isBusy = _busyTarget != null || _isRestoring;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.backupTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(TokenSpace.lg),
          children: [
            ContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppCard(
                    color: isOld ? colors.highlight : colors.surface,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _lastBackupText(l10n, settings.lastBackupAt),
                          style: context.textStyles.titleMedium,
                        ),
                        if (isOld) ...[
                          const SizedBox(height: TokenSpace.xs),
                          Text(
                            l10n.backupOldWarning,
                            style: context.textStyles.bodyMedium,
                          ),
                        ],
                        AppButton(
                          label: l10n.backupInfoLink,
                          variant: AppButtonVariant.quiet,
                          icon: LucideIcons.info,
                          onPressed: () => showBackupInfoSheet(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: TokenSpace.xl),
                  AppButton(
                    label: l10n.backupSave,
                    icon: LucideIcons.download,
                    isExpanded: true,
                    isLoading: _busyTarget == ExportTarget.device,
                    onPressed: isBusy
                        ? null
                        : () => _export(ExportTarget.device),
                  ),
                  const SizedBox(height: TokenSpace.sm),
                  AppButton(
                    label: l10n.backupShare,
                    icon: LucideIcons.share2,
                    isExpanded: true,
                    variant: AppButtonVariant.secondary,
                    isLoading: _busyTarget == ExportTarget.shareSheet,
                    onPressed: isBusy
                        ? null
                        : () => _export(ExportTarget.shareSheet),
                  ),
                  if (share.supportsWhatsAppDirect) ...[
                    const SizedBox(height: TokenSpace.sm),
                    AppButton(
                      label: l10n.backupWhatsApp,
                      icon: LucideIcons.messageCircle,
                      isExpanded: true,
                      variant: AppButtonVariant.secondary,
                      isLoading: _busyTarget == ExportTarget.whatsApp,
                      onPressed: isBusy
                          ? null
                          : () => _export(ExportTarget.whatsApp),
                    ),
                  ],
                  const SizedBox(height: TokenSpace.sm),
                  Text(
                    l10n.backupWhatsAppTip,
                    style: context.textStyles.bodySmall,
                  ),
                  AppSectionHeader(l10n.backupRestore),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l10n.backupWhatsAppHelp,
                          style: context.textStyles.bodyMedium,
                        ),
                        const SizedBox(height: TokenSpace.lg),
                        AppButton(
                          label: l10n.backupRestore,
                          icon: LucideIcons.upload,
                          variant: AppButtonVariant.secondary,
                          isLoading: _isRestoring,
                          onPressed: isBusy ? null : _restore,
                        ),
                        if (hasUndo) ...[
                          const SizedBox(height: TokenSpace.md),
                          Text(
                            l10n.backupUndoRestoreHint,
                            style: context.textStyles.bodySmall,
                          ),
                          AppButton(
                            label: l10n.backupUndoRestore,
                            icon: LucideIcons.undo2,
                            variant: AppButtonVariant.quiet,
                            onPressed: isBusy
                                ? null
                                : () => BackupActions.undoRestore(context, ref),
                          ),
                        ],
                      ],
                    ),
                  ),
                  AppSectionHeader(l10n.backupReminderToggle),
                  AppCard(
                    padding: const EdgeInsets.symmetric(
                      vertical: TokenSpace.sm,
                    ),
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: Text(l10n.backupBannerToggle),
                          value: settings.isBackupReminderOn,
                          onChanged: (isOn) => ref
                              .read(settingsControllerProvider.notifier)
                              .update(
                                (current) =>
                                    current.copyWith(isBackupReminderOn: isOn),
                              ),
                        ),
                        SwitchListTile(
                          title: Text(l10n.backupReminderToggle),
                          subtitle: Text(l10n.backupReminderToggleHint),
                          value: settings.isBackupNotificationOn,
                          onChanged: (isOn) => _toggleNotification(isOn: isOn),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: TokenSpace.xxl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
