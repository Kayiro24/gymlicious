import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/app/router.dart';
import 'package:gym_tracker/features/checkin/checkin.dart';
import 'package:gym_tracker/features/onboarding/onboarding.dart';

import '../helpers/test_app.dart';

Future<void> _settle(WidgetTester tester) async {
  for (var frame = 0; frame < 10; frame++) {
    await tester.pump(const Duration(milliseconds: 200));
  }
}

Future<void> _tapText(WidgetTester tester, String text) async {
  await tester.ensureVisible(find.text(text));
  await tester.pump();
  await tester.tap(find.text(text));
  await _settle(tester);
}

void main() {
  testWidgets('goal step saves the goal, then split, then all set', (
    tester,
  ) async {
    final app = TestApp();
    await app.pump(tester);
    app.container.read(routerProvider).go(OnboardingRoutes.goal);
    await _settle(tester);

    expect(find.text('Step 2 of 4'), findsOneWidget);
    expect(find.text('4 days a week'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('3 days'));
    await _settle(tester);
    await _tapText(tester, 'Continue');
    expect(app.container.read(weeklyGoalProvider), 3);
    expect(find.text('Step 3 of 4'), findsOneWidget);

    await _tapText(tester, 'Set up later');
    expect(find.text("You're all set, Sam!"), findsOneWidget);

    await tester.tap(find.text("Let's go"));
    await _settle(tester);
    expect(find.text('I worked out today'), findsOneWidget);
  });

  testWidgets('skipping the goal step keeps the default of 4', (tester) async {
    final app = TestApp();
    await app.pump(tester);
    app.container.read(routerProvider).go(OnboardingRoutes.goal);
    await _settle(tester);
    await _tapText(tester, 'Set up later');
    expect(app.container.read(weeklyGoalProvider), 4);
    expect(
      app.container.read(checkInControllerProvider).goals.periods,
      isEmpty,
    );
  });

  testWidgets('the gate shows step 1 with restore at the top', (tester) async {
    await TestApp().pump(tester, hasProfile: false);
    expect(find.text('Step 1 of 4'), findsOneWidget);
    expect(find.text('Restore from backup'), findsOneWidget);
  });
}
