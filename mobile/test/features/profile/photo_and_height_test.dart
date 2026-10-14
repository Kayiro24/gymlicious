import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_theme.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/core/units/units.dart';
import 'package:gym_tracker/features/profile/data/photo_store.dart';
import 'package:gym_tracker/features/profile/domain/photo_crop.dart';
import 'package:gym_tracker/features/profile/presentation/screens/photo_crop_screen.dart';
import 'package:gym_tracker/shared/height_field.dart';
import 'package:image/image.dart' as img;

import '../../helpers/test_app.dart';

/// 400×200: left half red, right half blue.
Uint8List _twoTone() {
  final image = img.Image(width: 400, height: 200);
  for (var y = 0; y < 200; y++) {
    for (var x = 0; x < 400; x++) {
      image.setPixelRgb(x, y, x < 200 ? 255 : 0, 0, x < 200 ? 0 : 255);
    }
  }
  return img.encodePng(image);
}

Widget _localized(Widget child) => MaterialApp(
  theme: AppTheme.light(),
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ],
  home: child,
);

void main() {
  group('height wheel', () {
    test('steps cover 90 to 250 cm in both units', () {
      final inches = HeightField.stepsFor(HeightUnit.ftIn);
      expect(inches.first, 36);
      expect(inches.last, 98);
      final centimetres = HeightField.stepsFor(HeightUnit.cm);
      expect(centimetres.first, 90);
      expect(centimetres.last, 250);
    });

    test('a selection converts to the other unit', () {
      expect(HeightField.stepOf(HeightUnit.ftIn, 170), 67);
      expect(
        HeightField.centimetresOf(HeightUnit.ftIn, 67),
        closeTo(170.18, 0.01),
      );
      expect(HeightField.stepOf(HeightUnit.cm, 170.18), 170);
    });

    testWidgets('shows the height in the other unit underneath', (
      tester,
    ) async {
      var centimetres = 170.0;
      await tester.pumpWidget(
        _localized(
          Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => HeightField(
                label: 'Height',
                unit: HeightUnit.ftIn,
                centimetres: centimetres,
                onChanged: (value) => setState(() => centimetres = value),
              ),
            ),
          ),
        ),
      );
      expect(find.text('5 ft 7 in'), findsOneWidget);
      expect(find.text("That's 170 cm"), findsOneWidget);

      await tester.drag(
        find.byType(ListWheelScrollView),
        const Offset(0, -TokenLayout.minTouchTarget * 3),
      );
      await tester.pumpAndSettle();
      expect(centimetres, closeTo(70 * 2.54, 0.01));
      expect(find.text("That's 178 cm"), findsOneWidget);
    });
  });

  group('photo crop', () {
    test('the framed square is what gets stored', () async {
      const leftSquare = (left: 0.0, top: 0.0, width: 0.5, height: 1.0);
      final stored = await PhotoStore.prepare(_twoTone(), crop: leftSquare);
      final image = img.decodeJpg(stored!)!;
      expect(image.width, 200);
      expect(image.height, 200);
      final centre = image.getPixel(100, 100);
      expect(centre.r, greaterThan(200));
      expect(centre.b, lessThan(60));
    });

    test('without a crop it keeps the centre square', () async {
      final stored = await PhotoStore.prepare(_twoTone());
      final image = img.decodeJpg(stored!)!;
      expect(image.width, image.height);
    });

    testWidgets('Use photo returns the centred square at first', (
      tester,
    ) async {
      PhotoCrop? result;
      final bytes = _twoTone();
      await tester.pumpWidget(
        _localized(
          Builder(
            builder: (context) => TextButton(
              onPressed: () async =>
                  result = await PhotoCropScreen.open(context, bytes),
              child: const Text('pick'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('pick'));
      await tester.pump();
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 200)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Move and scale'), findsOneWidget);
      await tester.tap(find.text('Use photo'));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!.height, closeTo(1, 0.001));
      expect(result!.width, closeTo(0.5, 0.001));
      expect(result!.left, closeTo(0.25, 0.001));
      expect(result!.top, closeTo(0, 0.001));
    });
  });

  testWidgets('the gate starts in feet at 5 ft 7 in, units at the bottom', (
    tester,
  ) async {
    await TestApp().pump(tester, hasProfile: false);
    for (var frame = 0; frame < 5; frame++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Add photo'), findsWidgets);
    expect(find.text('5 ft 7 in'), findsOneWidget);
    expect(find.text("That's 170 cm"), findsOneWidget);
    final height = tester.getTopLeft(find.text('5 ft 7 in')).dy;
    final units = tester.getTopLeft(find.text('Units')).dy;
    expect(units, greaterThan(height));
  });
}
