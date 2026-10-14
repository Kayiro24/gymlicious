import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/app_theme.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/core/units/units.dart';
import 'package:gym_tracker/design_system/motion.dart';
import 'package:gym_tracker/features/workouts/workouts.dart';
import 'package:intl/intl.dart';

/// Best weight per session over time, in the user's unit.
class ProgressChart extends StatelessWidget {
  const new({required this.points, required this.format, super.key});

  static const height = 200.0;

  final List<ProgressPoint> points;
  final WeightFormat format;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final dateFormat = DateFormat.MMMd(locale);
    final spots = [
      for (final (index, point) in points.indexed)
        FlSpot(
          index.toDouble(),
          UnitConversion.toDisplayWeight(point.bestKg, format.unit),
        ),
    ];
    final labelStyle = context.textStyles.labelSmall?.copyWith(
      fontFeatures: AppTheme.tabularFigures,
    );
    final last = points.length - 1;
    return Semantics(
      label: l10n.exerciseChartLabel(points.length),
      child: ExcludeSemantics(
        child: SizedBox(
          height: height,
          child: LineChart(
            duration: AppMotion.of(context),
            LineChartData(
              minX: 0,
              maxX: last <= 0 ? 1 : last.toDouble(),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) => colors.textPrimary,
                  getTooltipItems: (touched) => [
                    for (final spot in touched)
                      _tooltip(points[spot.x.toInt()], dateFormat, colors),
                  ],
                ),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: TokenSpace.xxl + TokenSpace.sm,
                    getTitlesWidget: (value, meta) =>
                        Text(meta.formattedValue, style: labelStyle),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize: TokenSpace.xl,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      final isEdge = index == 0 || index == last;
                      if (!isEdge || index >= points.length) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        dateFormat.format(points[index].date.toLocalDateTime()),
                        style: labelStyle,
                      );
                    },
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  preventCurveOverShooting: true,
                  color: colors.accent,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    getDotPainter: (spot, percent, bar, index) =>
                        FlDotCirclePainter(
                          radius: 3.5,
                          color: colors.accent,
                          strokeColor: colors.surface,
                          strokeWidth: 2,
                        ),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: colors.accentSoft.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  LineTooltipItem _tooltip(
    ProgressPoint point,
    DateFormat dateFormat,
    AppColors colors,
  ) {
    final weight = format.withUnit(point.bestKg);
    final date = dateFormat.format(point.date.toLocalDateTime());
    return LineTooltipItem(
      '$weight\n$date',
      TextStyle(color: colors.background),
    );
  }
}
