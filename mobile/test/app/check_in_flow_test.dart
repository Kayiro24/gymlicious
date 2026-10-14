import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/features/checkin/checkin.dart';
import 'package:gym_tracker/features/rewards/rewards.dart';
import 'package:gym_tracker/features/settings/settings.dart';
import 'package:gym_tracker/shared/celebration_overlay.dart';

import '../helpers/test_app.dart';

Future<void> _settle(WidgetTester tester) async {
  for (var frame = 0; frame < 10; frame++) {
    await tester.pump(const Duration(milliseconds: 200));
  }
}

void main() {
  testWidgets('one tap checks in, celebrates, and can be undone', (
    tester,
  ) async {
    final app = TestApp();
    await app.pump(tester);
    expect(find.text('Fresh start today'), findsWidgets);

    await tester.ensureVisible(find.text('I worked out today'));
    await tester.pump();
    await tester.tap(find.text('I worked out today'));
    await _settle(tester);

    expect(find.byType(CelebrationOverlay), findsOneWidget);
    expect(find.textContaining('First workout'), findsWidgets);
    expect(find.textContaining('Day 1!'), findsWidgets);
    expect(app.container.read(streakSnapshotProvider).currentDays, 1);
    expect(
      app.container.read(rewardsControllerProvider).earnedIds,
      contains(BadgeKind.firstWorkout.id),
    );

    await tester.tapAt(const Offset(4, 4));
    await _settle(tester);
    expect(find.byType(CelebrationOverlay), findsNothing);
    expect(find.text('Done. Nice work!'), findsOneWidget);

    await tester.ensureVisible(find.text('Undo'));
    await tester.tap(find.text('Undo'));
    await _settle(tester);
    expect(app.container.read(streakSnapshotProvider).currentDays, 0);
    expect(find.byType(CelebrationOverlay), findsNothing);
    expect(
      app.container.read(rewardsControllerProvider).earnedIds,
      contains(BadgeKind.firstWorkout.id),
      reason: 'badges are kept once earned',
    );
  });

  testWidgets('a past day can be backfilled from Plan in two taps', (
    tester,
  ) async {
    final app = TestApp();
    await app.pump(tester);
    await tester.tap(find.text('Plan').last);
    await _settle(tester);

    await tester.tap(
      find.bySemanticsLabel(RegExp('^Monday, October 12')).first,
    );
    await _settle(tester);
    expect(find.text('Worked out'), findsOneWidget);

    await tester.tap(find.byType(Switch));
    await tester.enterText(find.byType(TextField), 'Chest + triceps');
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await _settle(tester);

    final record = app.container.read(
      dayRecordsProvider,
    )[const CalendarDate(2026, 10, 12)]!;
    expect(record.isDone, isTrue);
    expect(record.note, 'Chest + triceps');
  });

  testWidgets('future days can be planned but not ticked off', (tester) async {
    final app = TestApp();
    await app.pump(tester);
    await tester.tap(find.text('Plan').last);
    await _settle(tester);
    await tester.tap(
      find.bySemanticsLabel(RegExp('^Friday, October 16')).first,
    );
    await _settle(tester);

    expect(find.text('You can tick this off on the day.'), findsOneWidget);
    final toggle = tester.widget<SwitchListTile>(find.byType(SwitchListTile));
    expect(toggle.onChanged, isNull);
  });

  testWidgets('the weekly goal is changed from Me', (tester) async {
    final app = TestApp();
    await app.pump(tester);
    await tester.tap(find.text('Me').last);
    await _settle(tester);
    await tester.tap(find.text('Gym days per week'));
    await _settle(tester);
    await tester.tap(find.bySemanticsLabel('5 days'));
    await tester.tap(find.text('Save'));
    await _settle(tester);

    expect(app.container.read(weeklyGoalProvider), 5);
    expect(find.text('5 days a week'), findsOneWidget);
  });

  testWidgets('the daily reminder skips Sundays and checked-in days', (
    tester,
  ) async {
    final app = TestApp();
    await app.pump(tester);
    app.container
        .read(checkInControllerProvider.notifier)
        .setDone(const CalendarDate(2026, 10, 14), isDone: true);
    app.container
        .read(settingsControllerProvider.notifier)
        .update((s) => s.copyWith(isCheckInReminderOn: true));
    await _settle(tester);

    final reminders = app.notifications.checkInReminders;
    expect(reminders, isNotEmpty);
    expect(reminders.where((time) => time.weekday == DateTime.sunday), isEmpty);
    expect(
      reminders.where((time) => time.day == 14 && time.month == 10),
      isEmpty,
    );
    expect(reminders.first, DateTime(2026, 10, 15, 19));

    app.container
        .read(settingsControllerProvider.notifier)
        .update((s) => s.copyWith(isCheckInReminderOn: false));
    await _settle(tester);
    expect(app.notifications.checkInReminders, isEmpty);
  });

  testWidgets('Stats starts with a friendly empty state', (tester) async {
    final app = TestApp();
    await app.pump(tester);
    await tester.tap(find.text('Stats').last);
    await _settle(tester);
    expect(
      find.text('Your stats grow with every workout. Tick off today to start.'),
      findsOneWidget,
    );

    app.container
        .read(checkInControllerProvider.notifier)
        .setDone(const CalendarDate(2026, 10, 13), isDone: true);
    await _settle(tester);
    expect(find.text('Current streak'), findsOneWidget);
    expect(find.text('Last 8 weeks'), findsOneWidget);
  });
}
