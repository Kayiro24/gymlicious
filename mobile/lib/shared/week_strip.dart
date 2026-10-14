import 'package:flutter/material.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/shared/day_chip.dart';

/// Monday to Sunday in one row; chips scale down to fit narrow widths.
class WeekStrip extends StatelessWidget {
  const new({
    required this.days,
    required this.weekdayLabels,
    super.key,
    this.onDayTap,
  }) : assert(days.length == DateTime.daysPerWeek, 'A week has 7 days');

  final List<DayChipData> days;

  /// Monday first.
  final List<String> weekdayLabels;
  final ValueChanged<int>? onDayTap;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (final (index, day) in days.indexed)
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: DayChip(
              data: day,
              weekdayLabel: weekdayLabels[index],
              diameter: TokenSpace.xxl + TokenSpace.md,
              onTap: onDayTap == null ? null : () => onDayTap!(index),
            ),
          ),
        ),
    ],
  );
}
