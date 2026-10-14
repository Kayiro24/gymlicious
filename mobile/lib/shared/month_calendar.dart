import 'package:flutter/material.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/shared/day_chip.dart';

/// A Monday-first month grid of [DayChip]s.
class MonthCalendar extends StatelessWidget {
  const new({
    required this.year,
    required this.month,
    required this.weekdayLabels,
    required this.dayData,
    super.key,
    this.onDayTap,
  });

  final int year;
  final int month;

  /// Monday first.
  final List<String> weekdayLabels;
  final DayChipData Function(CalendarDate date) dayData;
  final ValueChanged<CalendarDate>? onDayTap;

  @override
  Widget build(BuildContext context) {
    final first = CalendarDate(year, month, 1);
    final leading = first.weekday - 1;
    final dayCount = CalendarDate.daysInMonth(year, month);
    final rows = ((leading + dayCount) / DateTime.daysPerWeek).ceil();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ExcludeSemantics(
          child: Row(
            children: [
              for (final label in weekdayLabels)
                Expanded(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: context.textStyles.labelSmall,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: TokenSpace.xs),
        for (var row = 0; row < rows; row++)
          Row(
            children: [
              for (var column = 0; column < DateTime.daysPerWeek; column++)
                Expanded(
                  child: _cell(
                    row * DateTime.daysPerWeek + column - leading + 1,
                    dayCount,
                  ),
                ),
            ],
          ),
      ],
    );
  }

  Widget _cell(int day, int dayCount) {
    if (day < 1 || day > dayCount) {
      return const SizedBox.shrink();
    }
    final date = CalendarDate(year, month, day);
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: DayChip(
        data: dayData(date),
        onTap: onDayTap == null ? null : () => onDayTap!(date),
      ),
    );
  }
}
