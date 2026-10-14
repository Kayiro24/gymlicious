import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/app/recovery_screen.dart';
import 'package:gym_tracker/features/settings/settings.dart';

import '../helpers/test_app.dart';

void main() {
  testWidgets('first launch opens the welcome gate', (tester) async {
    await TestApp().pump(tester, hasProfile: false);
    expect(
      find.text("Welcome to Gymlicious. Let's get you set up."),
      findsOneWidget,
    );
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('with a profile, phones get a bottom bar of five tabs', (
    tester,
  ) async {
    await TestApp().pump(tester);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationDestination), findsNWidgets(5));
    expect(find.byType(NavigationRail), findsNothing);
  });

  testWidgets('tablets get a navigation rail', (tester) async {
    await TestApp().pump(tester, size: tabletSize);
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('every tab opens without errors at both sizes', (tester) async {
    for (final size in [phoneSize, tabletSize]) {
      await TestApp().pump(tester, size: size);
      for (final label in ['Plan', 'Train', 'Stats', 'Me', 'Home']) {
        await tester.tap(find.text(label).last);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: '$label at $size');
      }
    }
  });

  testWidgets('an unreadable data file opens the recovery screen', (
    tester,
  ) async {
    final app = TestApp()..dataStore.isCorrupted = true;
    await app.pump(tester, hasProfile: false);
    expect(find.byType(RecoveryScreen), findsOneWidget);
  });

  testWidgets('the wallpaper config is pushed on start', (tester) async {
    final app = TestApp();
    await app.pump(tester);
    expect(app.wallpaper.pushed, isNotEmpty);
    expect(app.wallpaper.pushed.last['layout'], 'continuous');
    expect(app.wallpaper.pushed.last['summaryTemplate'], contains('{left}'));
  });

  testWidgets('choosing dark theme switches the app theme', (tester) async {
    final app = TestApp();
    await app.pump(tester);
    app.container
        .read(settingsControllerProvider.notifier)
        .update((settings) => settings.copyWith(theme: ThemePreference.dark));
    await tester.pumpAndSettle();
    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.themeMode, ThemeMode.dark);
  });
}
