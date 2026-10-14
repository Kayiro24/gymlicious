import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';

typedef ChartBar = ({String label, int value});

/// A simple warm bar chart with plain labels and an optional goal line.
/// The caller's [semanticLabel] describes the data for screen readers.
class WarmBarChart extends StatelessWidget {
  const new({
    required this.bars,
    required this.semanticLabel,
    super.key,
    this.goal,
    this.highlightLast = false,
  });

  final List<ChartBar> bars;
  final String semanticLabel;
  final int? goal;
  final bool highlightLast;

  static const double _height = 180;
  static const double _barWidth = 18;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final peak = [
      for (final bar in bars) bar.value,
      ?goal,
      1,
    ].reduce((a, b) => a > b ? a : b);
    final labelStyle = context.textStyles.labelSmall;
    return Semantics(
      label: semanticLabel,
      container: true,
      child: ExcludeSemantics(
        child: SizedBox(
          height: _height,
          child: BarChart(
            BarChartData(
              maxY: peak + 1,
              minY: 0,
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barTouchData: const BarTouchData(enabled: false),
              extraLinesData: ExtraLinesData(
                horizontalLines: [
                  if (goal case final goal?)
                    HorizontalLine(
                      y: goal.toDouble(),
                      color: colors.textSecondary,
                      strokeWidth: 1.5,
                      dashArray: const [6, 4],
                    ),
                ],
              ),
              titlesData: FlTitlesData(
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: TokenSpace.xl,
                    getTitlesWidget: (value, meta) =>
                        Text('${bars[value.toInt()].value}', style: labelStyle),
                  ),
                ),
                rightTitles: const AxisTitles(),
                leftTitles: const AxisTitles(),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: TokenSpace.xxl,
                    getTitlesWidget: (value, meta) => Padding(
                      padding: const EdgeInsets.only(top: TokenSpace.xs),
                      child: Text(
                        bars[value.toInt()].label,
                        style: labelStyle,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ),
                ),
              ),
              barGroups: [
                for (final (index, bar) in bars.indexed)
                  BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: bar.value.toDouble(),
                        width: _barWidth,
                        borderRadius: BorderRadius.circular(TokenSpace.xs),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: highlightLast && index == bars.length - 1
                              ? [colors.accent, colors.ember]
                              : colors.fireColors,
                        ),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: peak + 1,
                          color: colors.surfaceMuted,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
