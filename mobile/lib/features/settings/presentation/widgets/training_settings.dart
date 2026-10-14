import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/platform/platform_providers.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/app_card.dart';
import 'package:gym_tracker/design_system/app_list_tile.dart';
import 'package:gym_tracker/design_system/app_sheet.dart';
import 'package:gym_tracker/design_system/app_toast.dart';
import 'package:gym_tracker/design_system/number_choice_chips.dart';
import 'package:gym_tracker/features/checkin/checkin.dart';
import 'package:gym_tracker/features/settings/presentation/state/settings_controller.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Me → Training: the weekly goal and the optional daily reminder.
class TrainingSettings extends ConsumerWidget {
  const new({super.key});

  Future<void> _editGoal(BuildContext context) => showAppSheet<void>(
    context: context,
    title: AppLocalizations.of(context).meGymDays,
    builder: (context) => const _GoalSheet(),
  );

  Future<void> _setReminder(
    BuildContext context,
    WidgetRef ref, {
    required bool isOn,
  }) async {
    final controller = ref.read(settingsControllerProvider.notifier);
    if (!isOn) {
      controller.update((s) => s.copyWith(isCheckInReminderOn: false));
      return;
    }
    final l10n = AppLocalizations.of(context);
    final isAllowed = await ref
        .read(notificationGatewayProvider)
        .scheduleCheckInReminders(
          times: const [],
          title: l10n.reminderTitle,
          body: l10n.reminderBody,
          channelName: l10n.reminderChannel,
        );
    if (!isAllowed) {
      if (context.mounted) {
        showAppToast(context, l10n.meReminderDenied);
      }
      return;
    }
    controller.update((s) => s.copyWith(isCheckInReminderOn: true));
  }

  Future<void> _pickTime(BuildContext context, WidgetRef ref) async {
    final minutes = ref.read(settingsControllerProvider).checkInReminderMinutes;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: minutes ~/ Duration.minutesPerHour,
        minute: minutes % Duration.minutesPerHour,
      ),
    );
    if (picked != null) {
      ref
          .read(settingsControllerProvider.notifier)
          .update(
            (s) => s.copyWith(
              checkInReminderMinutes:
                  picked.hour * Duration.minutesPerHour + picked.minute,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final goal = ref.watch(weeklyGoalProvider);
    final settings = ref.watch(settingsControllerProvider);
    final minutes = settings.checkInReminderMinutes;
    final time = TimeOfDay(
      hour: minutes ~/ Duration.minutesPerHour,
      minute: minutes % Duration.minutesPerHour,
    ).format(context);
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          AppListTile(
            leadingIcon: LucideIcons.target,
            title: l10n.meGymDays,
            subtitle: l10n.goalDaysPerWeek(goal),
            trailing: const Icon(LucideIcons.chevronRight),
            onTap: () => unawaited(_editGoal(context)),
          ),
          SwitchListTile(
            secondary: const Icon(LucideIcons.bellRing),
            title: Text(l10n.meReminder, style: context.textStyles.titleMedium),
            subtitle: Text(l10n.meReminderHelp),
            value: settings.isCheckInReminderOn,
            onChanged: (isOn) =>
                unawaited(_setReminder(context, ref, isOn: isOn)),
          ),
          if (settings.isCheckInReminderOn)
            AppListTile(
              leadingIcon: LucideIcons.clock,
              title: l10n.meReminderTime,
              subtitle: time,
              trailing: const Icon(LucideIcons.chevronRight),
              onTap: () => unawaited(_pickTime(context, ref)),
            ),
        ],
      ),
    );
  }
}

class _GoalSheet extends ConsumerStatefulWidget {
  const new();

  @override
  ConsumerState<_GoalSheet> createState() => _GoalSheetState();
}

class _GoalSheetState extends ConsumerState<_GoalSheet> {
  late int _goal = ref.read(weeklyGoalProvider);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.meGymDaysHelp,
          style: context.textStyles.bodyMedium?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        const SizedBox(height: TokenSpace.lg),
        NumberChoiceChips(
          values: [
            for (
              var days = WeeklyGoalHistory.minDays;
              days <= WeeklyGoalHistory.maxDays;
              days++
            )
              days,
          ],
          selected: _goal,
          onChanged: (value) => setState(() => _goal = value),
        ),
        const SizedBox(height: TokenSpace.sm),
        Text(
          l10n.goalDaysPerWeek(_goal),
          textAlign: TextAlign.center,
          style: context.textStyles.titleMedium,
        ),
        const SizedBox(height: TokenSpace.xl),
        AppButton(
          label: l10n.daySheetSave,
          isExpanded: true,
          onPressed: () {
            ref.read(checkInControllerProvider.notifier).setWeeklyGoal(_goal);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
