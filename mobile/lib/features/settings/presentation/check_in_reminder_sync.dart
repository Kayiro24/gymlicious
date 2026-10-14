import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/platform/platform_providers.dart';
import 'package:gym_tracker/core/providers.dart';
import 'package:gym_tracker/features/checkin/checkin.dart';
import 'package:gym_tracker/features/settings/presentation/state/settings_controller.dart';

typedef _ReminderPlan = ({bool isOn, int minutes, Set<DateTime> times});

/// Keeps the scheduled "Ready for today?" reminders in step with the setting
/// and with check-ins, so a ticked-off day is never reminded.
class CheckInReminderSync extends ConsumerStatefulWidget {
  const new({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<CheckInReminderSync> createState() =>
      _CheckInReminderSyncState();
}

class _CheckInReminderSyncState extends ConsumerState<CheckInReminderSync> {
  _ReminderPlan? _applied;

  _ReminderPlan _plan() {
    final settings = ref.read(settingsControllerProvider);
    final doneDays = DayRecords.workoutDays(ref.read(dayRecordsProvider));
    return (
      isOn: settings.isCheckInReminderOn,
      minutes: settings.checkInReminderMinutes,
      times: settings.isCheckInReminderOn
          ? CheckInReminders.upcoming(
              now: ref.read(clockProvider).now(),
              minutesOfDay: settings.checkInReminderMinutes,
              doneDays: doneDays,
            ).toSet()
          : const {},
    );
  }

  Future<void> _sync() async {
    if (!mounted) {
      return;
    }
    final plan = _plan();
    final applied = _applied;
    if (applied != null &&
        applied.isOn == plan.isOn &&
        applied.times.length == plan.times.length &&
        applied.times.containsAll(plan.times)) {
      return;
    }
    _applied = plan;
    final gateway = ref.read(notificationGatewayProvider);
    if (!plan.isOn) {
      await gateway.cancelCheckInReminders();
      return;
    }
    final l10n = AppLocalizations.of(context);
    await gateway.scheduleCheckInReminders(
      times: plan.times.toList()..sort(),
      title: l10n.reminderTitle,
      body: l10n.reminderBody,
      channelName: l10n.reminderChannel,
    );
  }

  @override
  void initState() {
    super.initState();
    void schedule() => scheduleMicrotask(() => unawaited(_sync()));
    ref
      ..listenManual(settingsControllerProvider, (_, _) => schedule())
      ..listenManual(dayRecordsProvider, (_, _) => schedule());
    WidgetsBinding.instance.addPostFrameCallback((_) => schedule());
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
