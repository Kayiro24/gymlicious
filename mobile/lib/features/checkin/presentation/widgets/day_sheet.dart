import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/clock/today_provider.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/app_segmented.dart';
import 'package:gym_tracker/design_system/app_sheet.dart';
import 'package:gym_tracker/design_system/app_text_field.dart';
import 'package:gym_tracker/features/checkin/domain/check_in_rules.dart';
import 'package:gym_tracker/features/checkin/domain/day_time.dart';
import 'package:gym_tracker/features/checkin/presentation/state/check_in_providers.dart';
import 'package:gym_tracker/features/history/history.dart';
import 'package:gym_tracker/features/workouts/workouts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Done toggle, note, time and duration for one day. Future days can only
/// be planned.
Future<void> showDaySheet(BuildContext context, CalendarDate date) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  return showAppSheet<void>(
    context: context,
    title: DateFormat.MMMMEEEEd(locale).format(date.toLocalDateTime()),
    builder: (context) => _DaySheet(date: date),
  );
}

class _DaySheet extends ConsumerStatefulWidget {
  const new({required this.date});

  final CalendarDate date;

  @override
  ConsumerState<_DaySheet> createState() => _DaySheetState();
}

class _DaySheetState extends ConsumerState<_DaySheet> {
  late final TextEditingController _note;
  late bool _isDone;
  DayTime? _time;
  int? _duration;

  @override
  void initState() {
    super.initState();
    final record = ref.read(dayRecordsProvider)[widget.date];
    final entry = ref.read(checkInControllerProvider).entryFor(widget.date);
    _note = TextEditingController(text: entry.note);
    _isDone = record?.isDone ?? false;
    _time = entry.time;
    _duration = entry.durationMinutes;
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final initial = _time ?? ref.read(dayRecordsProvider)[widget.date]?.time;
    final picked = await showTimePicker(
      context: context,
      initialTime: initial == null
          ? TimeOfDay.now()
          : TimeOfDay(hour: initial.hour, minute: initial.minute),
    );
    if (picked != null) {
      setState(() => _time = DayTime(picked.hour, picked.minute));
    }
  }

  void _save() {
    final controller = ref.read(checkInControllerProvider.notifier);
    final wasDone = ref.read(dayRecordsProvider)[widget.date]?.isDone ?? false;
    if (_isDone != wasDone) {
      controller.setDone(widget.date, isDone: _isDone);
    }
    controller.saveDetails(
      widget.date,
      note: _note.text,
      time: _time,
      durationMinutes: _duration,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final today = ref.watch(todayProvider);
    final isFuture = widget.date.isAfter(today);
    final record = ref.watch(dayRecordsProvider)[widget.date];
    final sessionTime = record?.hasSession ?? false ? record?.time : null;
    final session = ref
        .watch(workoutsControllerProvider)
        .sessions
        .where(
          (session) =>
              CalendarDate.fromDateTime(session.startedAt) == widget.date,
        )
        .firstOrNull;
    final shownTime = _time ?? (isFuture ? null : record?.time);
    final durations = [
      ...CheckInRules.durationChoices,
      if (_duration case final custom?
          when !CheckInRules.durationChoices.contains(custom))
        custom,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _isDone,
          onChanged: isFuture
              ? null
              : (value) {
                  unawaited(HapticFeedback.lightImpact());
                  setState(() => _isDone = value);
                },
          secondary: Icon(
            _isDone ? LucideIcons.circleCheck : LucideIcons.circle,
            color: _isDone ? colors.accent : colors.textSecondary,
          ),
          title: Text(l10n.daySheetDone, style: context.textStyles.titleMedium),
          subtitle: Text(
            isFuture ? l10n.daySheetFutureHint : l10n.daySheetDoneHint,
          ),
        ),
        if (session != null && sessionTime != null) ...[
          const SizedBox(height: TokenSpace.sm),
          Row(
            children: [
              Icon(LucideIcons.dumbbell, color: colors.textSecondary),
              const SizedBox(width: TokenSpace.sm),
              Expanded(
                child: Text(
                  l10n.daySheetSessionLogged(
                    TimeOfDay(
                      hour: sessionTime.hour,
                      minute: sessionTime.minute,
                    ).format(context),
                  ),
                  style: context.textStyles.bodyMedium,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  unawaited(context.push(HistoryRoutes.detail(session.id)));
                },
                child: Text(l10n.daySheetViewWorkout),
              ),
            ],
          ),
        ],
        const SizedBox(height: TokenSpace.lg),
        AppTextField(
          label: l10n.daySheetNote,
          controller: _note,
          hintText: l10n.daySheetNoteHint,
          maxLength: CheckInRules.maxNoteLength,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: TokenSpace.lg),
        Text(
          isFuture ? l10n.daySheetPlannedTime : l10n.daySheetTime,
          style: context.textStyles.labelLarge,
        ),
        const SizedBox(height: TokenSpace.sm),
        Wrap(
          spacing: TokenSpace.sm,
          runSpacing: TokenSpace.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            AppButton(
              label: shownTime == null
                  ? l10n.daySheetAddTime
                  : TimeOfDay(
                      hour: shownTime.hour,
                      minute: shownTime.minute,
                    ).format(context),
              icon: LucideIcons.clock,
              variant: AppButtonVariant.secondary,
              onPressed: _pickTime,
            ),
            if (_time != null)
              AppButton(
                label: l10n.daySheetClearTime,
                variant: AppButtonVariant.quiet,
                onPressed: () => setState(() => _time = null),
              ),
          ],
        ),
        if (!isFuture) ...[
          const SizedBox(height: TokenSpace.lg),
          Text(l10n.daySheetDuration, style: context.textStyles.labelLarge),
          const SizedBox(height: TokenSpace.sm),
          AppSegmented<int?>(
            semanticLabel: l10n.daySheetDuration,
            options: [
              AppSegmentOption(null, l10n.daySheetNoDuration),
              for (final minutes in durations)
                AppSegmentOption(minutes, l10n.daySheetMinutes(minutes)),
            ],
            selected: _duration,
            onChanged: (value) => setState(() => _duration = value),
          ),
        ],
        const SizedBox(height: TokenSpace.xl),
        AppButton(label: l10n.daySheetSave, isExpanded: true, onPressed: _save),
      ],
    );
  }
}
