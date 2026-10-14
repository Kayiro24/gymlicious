import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/clock/iso_date_time.dart';
import 'package:gym_tracker/core/units/number_format.dart';
import 'package:gym_tracker/core/units/units.dart';
import 'package:gym_tracker/core/units/weight_stepper.dart';
import 'package:gym_tracker/core/units/weight_text.dart';

void main() {
  group('UnitConversion', () {
    test('kg to lb round-trips do not visibly drift', () {
      for (var kg = 0.0; kg <= 400; kg += 2.5) {
        final shown = WeightText.value(kg, WeightUnit.lb);
        final back = UnitConversion.lbToKg(NumberText.parseDecimal(shown)!);
        expect((back - kg).abs(), lessThan(0.05), reason: '$kg kg');
      }
    });

    test('display conversion is identity for kg', () {
      expect(UnitConversion.toDisplayWeight(82.5, WeightUnit.kg), 82.5);
      expect(UnitConversion.fromDisplayWeight(100, WeightUnit.lb), 45.359237);
    });

    test('centimetres to feet and inches', () {
      expect(UnitConversion.cmToFeetInches(178), (feet: 5, inches: 10.0));
      expect(UnitConversion.cmToFeetInches(182.88), (feet: 6, inches: 0.0));
      expect(UnitConversion.feetInchesToCm(5, 10), closeTo(177.8, 0.001));
    });

    test('units parse with safe defaults', () {
      expect(WeightUnit.fromName('lb'), WeightUnit.lb);
      expect(WeightUnit.fromName('stone'), WeightUnit.kg);
      expect(HeightUnit.fromName('ftIn'), HeightUnit.ftIn);
      expect(WeightUnit.lb.defaultIncrement, 5);
    });
  });

  group('NumberText and WeightText', () {
    test('trims trailing zeros', () {
      expect(NumberText.trimmed(80), '80');
      expect(NumberText.trimmed(82.5), '82.5');
      expect(NumberText.trimmed(82.25, step: 0.25), '82.25');
      expect(NumberText.trimmed(82.26), '82.3');
    });

    test('parses comma decimals and rejects junk', () {
      expect(NumberText.parseDecimal('82,5'), 82.5);
      expect(NumberText.parseDecimal(' '), isNull);
      expect(NumberText.parseDecimal('abc'), isNull);
    });

    test('bodyweight shows BW at zero and +added load otherwise', () {
      String text(double kg) => WeightText.withUnit(
        kg,
        WeightUnit.kg,
        isBodyweight: true,
        bodyweightLabel: 'BW',
      );

      expect(text(0), 'BW');
      expect(text(10), '+10 kg');
      expect(
        WeightText.withUnit(
          100,
          WeightUnit.lb,
          isBodyweight: false,
          bodyweightLabel: 'BW',
        ),
        '220.5 lb',
      );
    });
  });

  group('CalendarDate', () {
    test('day of year in normal and leap years', () {
      expect(const CalendarDate(2026, 1, 1).dayOfYear, 1);
      expect(const CalendarDate(2026, 12, 31).dayOfYear, 365);
      expect(const CalendarDate(2028, 12, 31).dayOfYear, 366);
      expect(const CalendarDate(2028, 3, 1).dayOfYear, 61);
      expect(CalendarDate.daysInYear(2100), 365);
      expect(CalendarDate.daysInYear(2000), 366);
    });

    test('adding days crosses months and years', () {
      expect(
        const CalendarDate(2026, 12, 31).addDays(1),
        const CalendarDate(2027, 1, 1),
      );
      expect(
        const CalendarDate(2028, 3, 1).addDays(-1),
        const CalendarDate(2028, 2, 29),
      );
      expect(
        const CalendarDate(
          2026,
          1,
          1,
        ).daysUntil(const CalendarDate(2026, 12, 31)),
        364,
      );
    });

    test('parses only real ISO dates', () {
      expect(CalendarDate.parse('1998-04-12'), const CalendarDate(1998, 4, 12));
      expect(() => CalendarDate.parse('2026-02-30'), throwsFormatException);
      expect(() => CalendarDate.parse('12/04/1998'), throwsFormatException);
      expect(const CalendarDate(2026, 3, 5).toIso(), '2026-03-05');
    });

    test('ordering and weekday', () {
      expect(const CalendarDate(2026, 10, 14).weekday, DateTime.wednesday);
      expect(
        const CalendarDate(2026, 1, 1).isBefore(const CalendarDate(2026, 1, 2)),
        isTrue,
      );
    });
  });

  group('IsoDateTime', () {
    test('format keeps wall-clock time and offset; parse round-trips', () {
      final original = DateTime(2026, 10, 12, 17, 5, 9);
      final formatted = IsoDateTime.format(original);

      expect(formatted, startsWith('2026-10-12T17:05:09'));
      expect(formatted, matches(RegExp(r'[+-]\d\d:\d\d$')));
      expect(IsoDateTime.parse(formatted), original);
    });

    test('parses spec-style strings with an explicit offset', () {
      final parsed = IsoDateTime.parse('2026-10-12T17:00:00+05:30');
      expect(parsed.toUtc(), DateTime.utc(2026, 10, 12, 11, 30));
    });
  });

  group('WeightStepper', () {
    double step(
      double kg, {
      required bool isUp,
      WeightUnit unit = WeightUnit.kg,
      double increment = 2.5,
    }) => WeightStepper.step(kg, unit: unit, increment: increment, isUp: isUp);

    test('moves one increment on the grid', () {
      expect(step(80, isUp: true), 82.5);
      expect(step(80, isUp: false), 77.5);
    });

    test('snaps to the grid when off it', () {
      expect(step(81, isUp: true), 82.5);
      expect(step(81, isUp: false), 80);
    });

    test('never goes below zero', () {
      expect(step(0, isUp: false), 0);
      expect(step(1, isUp: false), 0);
    });

    test('steps in pounds for lb users', () {
      final next = step(
        UnitConversion.lbToKg(100),
        isUp: true,
        unit: WeightUnit.lb,
        increment: 5,
      );
      expect(UnitConversion.kgToLb(next), closeTo(105, 1e-9));
    });
  });
}
