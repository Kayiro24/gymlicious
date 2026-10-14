import 'package:flutter/material.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/app_theme.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Month grid with a dot under each trained day (spec 5.8).
class TrainingCalendarView extends StatelessWidget {
  const new({
    required this.month,
    required this.trainedDates,
    required this.selectedDate,
    required this.onMonthChanged,
    required this.onDateSelected,
    super.key,
  });

  static const _daysPerWeek = 7;

  /// Any date in the month to show.
  final CalendarDate month;
  final Set<CalendarDate> trainedDates;
  final CalendarDate? selectedDate;
  final ValueChanged<CalendarDate> onMonthChanged;
  final ValueChanged<CalendarDate> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final materialL10n = MaterialLocalizations.of(context);
    final firstWeekday = materialL10n.firstDayOfWeekIndex == 0
        ? DateTime.sunday
        : materialL10n.firstDayOfWeekIndex;
    final first = CalendarDate(month.year, month.month, 1);
    final leading = (first.weekday - firstWeekday) % _daysPerWeek;
    final dayCount = CalendarDate.daysInMonth(month.year, month.month);
    final weekdayNames = [
      for (var i = 0; i < _daysPerWeek; i++)
        materialL10n.narrowWeekdays[(firstWeekday + i) % _daysPerWeek],
    ];
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              tooltip: l10n.historyPreviousMonth,
              icon: const Icon(LucideIcons.chevronLeft),
              onPressed: () => onMonthChanged(first.addDays(-1)),
            ),
            Expanded(
              child: Text(
                DateFormat.yMMMM(locale).format(first.toLocalDateTime()),
                textAlign: TextAlign.center,
                style: context.textStyles.titleMedium,
              ),
            ),
            IconButton(
              tooltip: l10n.historyNextMonth,
              icon: const Icon(LucideIcons.chevronRight),
              onPressed: () => onMonthChanged(first.addDays(dayCount)),
            ),
          ],
        ),
        GridView.count(
          crossAxisCount: _daysPerWeek,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (final name in weekdayNames)
              Center(child: Text(name, style: context.textStyles.labelSmall)),
            for (var i = 0; i < leading; i++) const SizedBox.shrink(),
            for (var day = 1; day <= dayCount; day++)
              _DayCell(
                date: CalendarDate(month.year, month.month, day),
                isTrained: trainedDates.contains(
                  CalendarDate(month.year, month.month, day),
                ),
                isSelected:
                    selectedDate == CalendarDate(month.year, month.month, day),
                colors: colors,
                onTap: onDateSelected,
              ),
          ],
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const new({
    required this.date,
    required this.isTrained,
    required this.isSelected,
    required this.colors,
    required this.onTap,
  });

  final CalendarDate date;
  final bool isTrained;
  final bool isSelected;
  final AppColors colors;
  final ValueChanged<CalendarDate> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final label = DateFormat.MMMMd(
      Localizations.localeOf(context).toLanguageTag(),
    ).format(date.toLocalDateTime());
    return Semantics(
      button: true,
      selected: isSelected,
      label: isTrained ? l10n.historyTrainedDay(label) : label,
      excludeSemantics: true,
      child: InkWell(
        onTap: () => onTap(date),
        customBorder: const CircleBorder(),
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? colors.accentSoft : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${date.day}',
                style: context.textStyles.bodyMedium?.copyWith(
                  fontFeatures: AppTheme.tabularFigures,
                ),
              ),
              const SizedBox(height: TokenSpace.xxs),
              Container(
                width: TokenSpace.xs + TokenSpace.xxs,
                height: TokenSpace.xs + TokenSpace.xxs,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isTrained ? colors.accent : Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
