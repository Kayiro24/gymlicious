import 'package:flutter/material.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/features/checkin/domain/day_record.dart';
import 'package:gym_tracker/features/checkin/domain/streak_snapshot.dart';
import 'package:gym_tracker/features/checkin/domain/training_week.dart';
import 'package:gym_tracker/shared/day_chip.dart';
import 'package:intl/intl.dart';

/// Plain, positive words and chip states for check-in data.
abstract final class CheckInText {
  static String status(
    AppLocalizations l10n,
    StreakSnapshot streak, {
    required bool isTodayDone,
  }) {
    final week = streak.currentWeek;
    return switch (week.status) {
      WeekStatus.met => l10n.statusMet,
      WeekStatus.onTrack => l10n.statusMoreToGo(week.needed),
      WeekStatus.lastChance when isTodayDone => l10n.statusMoreToGo(
        week.needed,
      ),
      WeekStatus.lastChance when week.needed == 1 => l10n.statusLastChanceToday,
      WeekStatus.lastChance => l10n.statusTrainToday,
      WeekStatus.freshStart when streak.currentDays > 0 => l10n.statusNewStreak(
        streak.currentDays,
      ),
      WeekStatus.freshStart => l10n.statusFreshStartToday,
    };
  }

  static DayChipState chipState(
    CalendarDate date,
    DayRecord? record,
    CalendarDate today,
  ) {
    if (record?.isDone ?? false) {
      return DayChipState.done;
    }
    final hasPlan = record?.note.isNotEmpty ?? false;
    final isPast = date.isBefore(today);
    if (hasPlan && !isPast) {
      return DayChipState.planned;
    }
    if (TrainingWeek.isBonusDay(date)) {
      return DayChipState.rest;
    }
    return isPast ? DayChipState.noWorkout : DayChipState.upcoming;
  }

  static String stateLabel(AppLocalizations l10n, DayChipState state) =>
      switch (state) {
        DayChipState.done => l10n.dayStateDone,
        DayChipState.noWorkout => l10n.dayStateNoWorkout,
        DayChipState.rest => l10n.dayStateRest,
        DayChipState.planned => l10n.dayStatePlanned,
        DayChipState.upcoming => l10n.dayStateUpcoming,
      };

  static DayChipData chipData(
    BuildContext context,
    CalendarDate date,
    DayRecord? record,
    CalendarDate today,
  ) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final state = chipState(date, record, today);
    final isToday = date == today;
    final stateText = [
      stateLabel(l10n, state),
      if (isToday) l10n.dayStateToday,
    ].join(', ');
    return (
      dayNumber: '${date.day}',
      state: state,
      isToday: isToday,
      semanticLabel: l10n.dayLabel(
        DateFormat.MMMMEEEEd(locale).format(date.toLocalDateTime()),
        stateText,
      ),
    );
  }

  /// Monday-first one-letter weekday names (D52).
  static List<String> weekdayLabels(BuildContext context) {
    final narrow = MaterialLocalizations.of(context).narrowWeekdays;
    return [
      for (var index = 1; index <= DateTime.daysPerWeek; index++)
        narrow[index % DateTime.daysPerWeek],
    ];
  }
}
