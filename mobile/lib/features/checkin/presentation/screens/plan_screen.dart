import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/clock/today_provider.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/layout/content_width.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_card.dart';
import 'package:gym_tracker/features/checkin/domain/training_week.dart';
import 'package:gym_tracker/features/checkin/presentation/check_in_text.dart';
import 'package:gym_tracker/features/checkin/presentation/state/check_in_providers.dart';
import 'package:gym_tracker/features/checkin/presentation/widgets/day_sheet.dart';
import 'package:gym_tracker/shared/day_chip.dart';
import 'package:gym_tracker/shared/month_calendar.dart';
import 'package:gym_tracker/shared/week_strip.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// A week strip on top and a month below; tapping any day opens its sheet.
class PlanScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends ConsumerState<PlanScreen> {
  int _weekOffset = 0;
  int _monthOffset = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final today = ref.watch(todayProvider);
    final records = ref.watch(dayRecordsProvider);
    final streak = ref.watch(streakSnapshotProvider);
    final weekdays = CheckInText.weekdayLabels(context);
    final monday = TrainingWeek.mondayOf(today)
        .addDays(_weekOffset * TrainingWeek.length);
    final firstOfMonth = DateTime(today.year, today.month + _monthOffset);
    DayChipData chip(CalendarDate date) =>
        CheckInText.chipData(context, date, records[date], today);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.planTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(TokenSpace.lg),
          children: [
            ContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.weekRingLabel(
                      streak.currentWeek.done,
                      streak.currentWeek.goal,
                    ),
                    style: context.textStyles.titleMedium,
                  ),
                  const SizedBox(height: TokenSpace.xs),
                  Text(
                    l10n.planHint,
                    style: context.textStyles.bodyMedium?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: TokenSpace.lg),
                  AppCard(
                    padding: const EdgeInsets.all(TokenSpace.md),
                    child: Column(
                      children: [
                        _Navigator(
                          title: _weekTitle(locale, monday),
                          previousLabel: l10n.planPreviousWeek,
                          nextLabel: l10n.planNextWeek,
                          onPrevious: () => setState(() => _weekOffset--),
                          onNext: () => setState(() => _weekOffset++),
                          resetLabel: _weekOffset == 0
                              ? null
                              : l10n.planThisWeek,
                          onReset: () => setState(() => _weekOffset = 0),
                        ),
                        const SizedBox(height: TokenSpace.sm),
                        WeekStrip(
                          weekdayLabels: weekdays,
                          days: [
                            for (final date in TrainingWeek.daysOf(monday))
                              chip(date),
                          ],
                          onDayTap: (index) =>
                              showDaySheet(context, monday.addDays(index)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: TokenSpace.lg),
                  AppCard(
                    padding: const EdgeInsets.all(TokenSpace.md),
                    child: Column(
                      children: [
                        _Navigator(
                          title: DateFormat.yMMMM(locale).format(firstOfMonth),
                          previousLabel: l10n.planPreviousMonth,
                          nextLabel: l10n.planNextMonth,
                          onPrevious: () => setState(() => _monthOffset--),
                          onNext: () => setState(() => _monthOffset++),
                        ),
                        const SizedBox(height: TokenSpace.sm),
                        MonthCalendar(
                          year: firstOfMonth.year,
                          month: firstOfMonth.month,
                          weekdayLabels: weekdays,
                          dayData: chip,
                          onDayTap: (date) => showDaySheet(context, date),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: TokenSpace.lg),
                  const _Legend(),
                  const SizedBox(height: TokenSpace.xxl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _weekTitle(String locale, CalendarDate monday) {
    final format = DateFormat.MMMd(locale);
    final sunday = monday.addDays(TrainingWeek.length - 1);
    return '${format.format(monday.toLocalDateTime())} – '
        '${format.format(sunday.toLocalDateTime())}';
  }
}

class _Navigator extends StatelessWidget {
  const new({
    required this.title,
    required this.previousLabel,
    required this.nextLabel,
    required this.onPrevious,
    required this.onNext,
    this.resetLabel,
    this.onReset,
  });

  final String title;
  final String previousLabel;
  final String nextLabel;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final String? resetLabel;
  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      IconButton(
        tooltip: previousLabel,
        onPressed: onPrevious,
        icon: const Icon(LucideIcons.chevronLeft),
      ),
      Expanded(
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.textStyles.titleMedium,
            ),
            if (resetLabel case final label?)
              TextButton(onPressed: onReset, child: Text(label)),
          ],
        ),
      ),
      IconButton(
        tooltip: nextLabel,
        onPressed: onNext,
        icon: const Icon(LucideIcons.chevronRight),
      ),
    ],
  );
}

class _Legend extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = [
      (DayChipState.done, l10n.planLegendDone),
      (DayChipState.planned, l10n.planLegendPlanned),
      (DayChipState.noWorkout, l10n.planLegendNoWorkout),
      (DayChipState.rest, l10n.planLegendRest),
      (DayChipState.upcoming, l10n.planLegendUpcoming),
    ];
    return ExcludeSemantics(
      child: Wrap(
        spacing: TokenSpace.lg,
        runSpacing: TokenSpace.sm,
        children: [
          for (final (state, label) in items)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                DayChip(
                  data: (
                    dayNumber: '',
                    state: state,
                    isToday: false,
                    semanticLabel: label,
                  ),
                  diameter: TokenSpace.xl,
                ),
                const SizedBox(width: TokenSpace.xs),
                Text(label, style: context.textStyles.bodySmall),
              ],
            ),
        ],
      ),
    );
  }
}
