import 'dart:math' as math;

import 'package:gym_tracker/core/clock/calendar_date.dart';

/// A rectangle in logical or physical pixels (pure Dart, no dart:ui).
typedef DotRect = ({double left, double top, double width, double height});

enum DotLayoutKind { continuous, months }

/// Geometry for every day of a year, per ADR 0004. Identical rules run in
/// the Kotlin wallpaper; both are checked against shared test vectors.
class DotLayout {
  const new({
    required this.kind,
    required this.cellWidth,
    required this.cells,
    required this.monthLabels,
    this.columns = 0,
    this.rows = 0,
    this.blockColumns = 0,
    this.blockRows = 0,
  });

  factory compute(DotLayoutKind kind, int year, double width, double height) =>
      kind == DotLayoutKind.continuous
      ? DotLayout.continuous(CalendarDate.daysInYear(year), width, height)
      : DotLayout.months(year, width, height);

  factory continuous(int dayCount, double width, double height) {
    var bestWidth = -1.0;
    var bestColumns = minColumns;
    var bestRows = 0;
    for (var columns = minColumns; columns <= maxColumns; columns++) {
      final rows = (dayCount / columns).ceil();
      final cellWidth = math.min(
        width / (columns + (columns - 1) * gapRatio),
        height / (rows + (rows - 1) * gapRatio) * aspect,
      );
      if (cellWidth > bestWidth + _tieEpsilon) {
        bestWidth = cellWidth;
        bestColumns = columns;
        bestRows = rows;
      }
    }
    final cellHeight = bestWidth / aspect;
    final gap = bestWidth * gapRatio;
    final gridWidth = bestColumns * bestWidth + (bestColumns - 1) * gap;
    final gridHeight = bestRows * cellHeight + (bestRows - 1) * gap;
    final left = (width - gridWidth) / 2;
    final top = (height - gridHeight) / 2;
    return DotLayout(
      kind: DotLayoutKind.continuous,
      cellWidth: bestWidth,
      columns: bestColumns,
      rows: bestRows,
      monthLabels: const [],
      cells: [
        for (var index = 0; index < dayCount; index++)
          (
            left: left + (index % bestColumns) * (bestWidth + gap),
            top: top + (index ~/ bestColumns) * (cellHeight + gap),
            width: bestWidth,
            height: cellHeight,
          ),
      ],
    );
  }

  factory months(int year, double width, double height) {
    var bestWidth = -1.0;
    var blockColumns = 3;
    var blockRows = 4;
    for (final (columns, rows) in const [(3, 4), (4, 3)]) {
      final cellWidth = math.min(
        width / (columns * (daysPerWeek + 6 * gapRatio) + (columns - 1)),
        height / (rows * (_blockRowCount / aspect + 6 * gapRatio) + (rows - 1)),
      );
      if (cellWidth > bestWidth + _tieEpsilon) {
        bestWidth = cellWidth;
        blockColumns = columns;
        blockRows = rows;
      }
    }
    final cellHeight = bestWidth / aspect;
    final gap = bestWidth * gapRatio;
    final blockWidth = daysPerWeek * bestWidth + 6 * gap;
    final blockHeight = _blockRowCount * cellHeight + 6 * gap;
    final totalWidth =
        blockColumns * blockWidth + (blockColumns - 1) * bestWidth;
    final totalHeight = blockRows * blockHeight + (blockRows - 1) * bestWidth;
    final left = (width - totalWidth) / 2;
    final top = (height - totalHeight) / 2;

    final cells = <DotRect>[];
    final labels = <DotRect>[];
    for (var month = 0; month < monthsPerYear; month++) {
      final blockLeft =
          left + (month % blockColumns) * (blockWidth + bestWidth);
      final blockTop =
          top + (month ~/ blockColumns) * (blockHeight + bestWidth);
      labels.add((
        left: blockLeft,
        top: blockTop,
        width: blockWidth,
        height: cellHeight,
      ));
      final first = CalendarDate(year, month + 1, 1);
      final dayCount = CalendarDate.daysInMonth(year, month + 1);
      for (var day = 0; day < dayCount; day++) {
        final index = first.weekday - 1 + day;
        cells.add((
          left: blockLeft + (index % daysPerWeek) * (bestWidth + gap),
          top: blockTop + (1 + index ~/ daysPerWeek) * (cellHeight + gap),
          width: bestWidth,
          height: cellHeight,
        ));
      }
    }
    return DotLayout(
      kind: DotLayoutKind.months,
      cellWidth: bestWidth,
      blockColumns: blockColumns,
      blockRows: blockRows,
      cells: cells,
      monthLabels: labels,
    );
  }

  static const gapRatio = 0.3;
  static const aspect = 0.8;
  static const minColumns = 10;
  static const maxColumns = 31;
  static const daysPerWeek = 7;
  static const monthsPerYear = 12;
  static const _blockRowCount = 7;
  static const _tieEpsilon = 1e-9;

  final DotLayoutKind kind;
  final double cellWidth;

  /// One rect per day, Jan 1 first.
  final List<DotRect> cells;

  /// Months layout only: the label slot above each month block.
  final List<DotRect> monthLabels;
  final int columns;
  final int rows;
  final int blockColumns;
  final int blockRows;

  double get cellHeight => cellWidth / aspect;

  double get gap => cellWidth * gapRatio;

  /// Index of the day whose cell contains the point, allowing half a gap of
  /// slack so taps between dots still land.
  int? hitTest(double x, double y) {
    final slack = gap / 2;
    for (final (index, cell) in cells.indexed) {
      if (x >= cell.left - slack &&
          x <= cell.left + cell.width + slack &&
          y >= cell.top - slack &&
          y <= cell.top + cell.height + slack) {
        return index;
      }
    }
    return null;
  }
}
