import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/features/year_dots/domain/dot_layout.dart';
import 'package:gym_tracker/features/year_dots/domain/year_progress.dart';

const _vectorsPath =
    '../shared-test-vectors/year_dots/layout_test_vectors.json';
const _tolerance = 0.01;

void main() {
  group('YearProgress', () {
    test('matches the spec example line', () {
      final progress = YearProgress(const CalendarDate(2026, 10, 14));

      expect(progress.dayOfYear, 287);
      expect(progress.daysInYear, 365);
      expect(progress.daysLeft, 78);
      expect(progress.percentDone, 79);
    });

    test('Jan 1 and Dec 31 in normal and leap years', () {
      final jan1 = YearProgress(const CalendarDate(2028, 1, 1));
      expect((jan1.dayOfYear, jan1.daysLeft, jan1.daysInYear), (1, 365, 366));
      expect(jan1.percentDone, 0);

      final dec31 = YearProgress(const CalendarDate(2026, 12, 31));
      expect((dec31.dayOfYear, dec31.daysLeft), (365, 0));
      expect(dec31.percentDone, 100);

      final leapEnd = YearProgress(const CalendarDate(2028, 12, 31));
      expect((leapEnd.dayOfYear, leapEnd.daysLeft), (366, 0));
    });

    test('dot states split around today', () {
      final progress = YearProgress(const CalendarDate(2026, 1, 3));

      expect(progress.stateOf(0), DotState.done);
      expect(progress.stateOf(1), DotState.done);
      expect(progress.stateOf(2), DotState.today);
      expect(progress.stateOf(3), DotState.left);
      expect(progress.dateOf(59), const CalendarDate(2026, 3, 1));
    });

    test('local dates are immune to DST: each local day maps once', () {
      final days = <int>{};
      for (var hour = 0; hour < 24 * 400; hour += 1) {
        final local = DateTime(2026).add(Duration(hours: hour));
        if (local.year == 2026) {
          days.add(CalendarDate.fromDateTime(local).dayOfYear);
        }
      }
      expect(days, hasLength(365));
    });
  });

  group('DotLayout parity with shared test vectors', () {
    final vectors = jsonDecode(
      File(_vectorsPath).readAsStringSync(),
    ) as Map<String, dynamic>;
    final cases = (vectors['cases'] as List).cast<Map<String, dynamic>>();

    test('constants match', () {
      expect(vectors['gapRatio'], DotLayout.gapRatio);
      expect(vectors['aspect'], DotLayout.aspect);
    });

    for (final vector in cases) {
      final kind = DotLayoutKind.values.byName(vector['layout'] as String);
      final year = vector['year'] as int;
      final width = (vector['width'] as num).toDouble();
      final height = (vector['height'] as num).toDouble();
      final expected = vector['expected'] as Map<String, dynamic>;

      test('${kind.name} $year at ${width}x$height', () {
        final layout = DotLayout.compute(kind, year, width, height);

        expect(layout.cells, hasLength(expected['dayCount']));
        expect(
          layout.cellWidth,
          closeTo((expected['cellWidth'] as num).toDouble(), _tolerance),
        );
        if (kind == DotLayoutKind.continuous) {
          expect(layout.columns, expected['columns']);
          expect(layout.rows, expected['rows']);
        } else {
          expect(layout.blockColumns, expected['blockColumns']);
          expect(layout.blockRows, expected['blockRows']);
        }
        final samples = expected['samples'] as Map<String, dynamic>;
        for (final MapEntry(key: index, value: rect) in samples.entries) {
          final values = (rect as List).cast<num>();
          final cell = layout.cells[int.parse(index)];
          expect(cell.left, closeTo(values[0].toDouble(), _tolerance));
          expect(cell.top, closeTo(values[1].toDouble(), _tolerance));
          expect(cell.width, closeTo(values[2].toDouble(), _tolerance));
          expect(cell.height, closeTo(values[3].toDouble(), _tolerance));
        }
      });
    }
  });

  group('DotLayout geometry', () {
    test('every cell fits inside the area and nothing overlaps', () {
      for (final kind in DotLayoutKind.values) {
        final layout = DotLayout.compute(kind, 2028, 390, 600);
        for (final cell in layout.cells) {
          expect(cell.left, greaterThanOrEqualTo(-_tolerance));
          expect(cell.top, greaterThanOrEqualTo(-_tolerance));
          expect(cell.left + cell.width, lessThanOrEqualTo(390 + _tolerance));
          expect(cell.top + cell.height, lessThanOrEqualTo(600 + _tolerance));
        }
        final keys = {
          for (final cell in layout.cells)
            (cell.left.round(), cell.top.round()),
        };
        expect(keys, hasLength(layout.cells.length));
      }
    });

    test('hit testing finds the tapped day', () {
      final layout = DotLayout.continuous(365, 400, 600);
      final target = layout.cells[72];

      expect(
        layout.hitTest(target.left + target.width / 2, target.top + 1),
        72,
      );
      expect(layout.hitTest(-50, -50), isNull);
    });
  });
}
