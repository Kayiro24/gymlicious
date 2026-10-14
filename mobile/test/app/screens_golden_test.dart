@Tags(['golden'])
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/app/gym_tracker_app.dart';
import 'package:gym_tracker/app/router.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/features/checkin/checkin.dart';
import 'package:gym_tracker/features/onboarding/onboarding.dart';
import 'package:gym_tracker/features/settings/settings.dart';

import '../helpers/test_app.dart';

/// Two weeks of check-ins ending on the harness's Wednesday 14 Oct 2026.
void _seedHistory(ProviderContainer container) {
  final checkIns = container.read(checkInControllerProvider.notifier)
    ..setWeeklyGoal(4);
  for (final day in [5, 6, 8, 10, 11, 12, 13]) {
    checkIns.setDone(CalendarDate(2026, 10, day), isDone: true);
  }
  checkIns
    ..saveDetails(
      const CalendarDate(2026, 10, 13),
      note: 'Chest + triceps',
      time: const DayTime(18, 30),
      durationMinutes: 60,
    )
    ..saveDetails(
      const CalendarDate(2026, 10, 16),
      note: 'Leg day',
      time: const DayTime(7, 0),
      durationMinutes: null,
    );
}

void _dark(ProviderContainer container) => container
    .read(settingsControllerProvider.notifier)
    .update((settings) => settings.copyWith(theme: ThemePreference.dark));

Future<void> _settle(WidgetTester tester) async {
  for (var frame = 0; frame < 8; frame++) {
    await tester.pump(const Duration(milliseconds: 200));
  }
}

void main() {
  final variants = [
    ('phone_light', phoneSize, false, 1.0),
    ('phone_dark', phoneSize, true, 1.0),
    ('phone_light_2x', phoneSize, false, 2.0),
    ('tablet_light', tabletSize, false, 1.0),
    ('tablet_dark', tabletSize, true, 1.0),
  ];
  final screens = [
    ('home', null),
    ('plan', CheckInRoutes.plan),
    ('stats', '/stats'),
    ('me', '/settings'),
    ('goal_step', OnboardingRoutes.goal),
  ];

  for (final (screen, path) in screens) {
    for (final (variant, size, isDark, scale) in variants) {
      testWidgets('$screen $variant', (tester) async {
        final app = TestApp();
        await app.pump(
          tester,
          size: size,
          textScale: scale,
          arrange: (container) {
            _seedHistory(container);
            if (isDark) {
              _dark(container);
            }
          },
        );
        if (path != null) {
          app.container.read(routerProvider).go(path);
        }
        await _settle(tester);
        expect(tester.takeException(), isNull);
        await expectLater(
          find.byType(GymTrackerApp),
          matchesGoldenFile('goldens/screens/${screen}_$variant.png'),
        );
      });
    }
  }
}
