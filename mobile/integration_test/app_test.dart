import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/app/bootstrap.dart';
import 'package:gym_tracker/app/gym_tracker_app.dart';
import 'package:gym_tracker/core/failure/result.dart';
import 'package:gym_tracker/core/providers.dart';
import 'package:gym_tracker/features/backup/backup.dart';
import 'package:gym_tracker/features/backup/domain/restore_plan.dart';
import 'package:gym_tracker/features/checkin/checkin.dart';
import 'package:gym_tracker/features/profile/profile.dart';
import 'package:integration_test/integration_test.dart';

/// Runs on a device or emulator against the real file system:
/// `flutter test integration_test --flavor dev`.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  ProfileValues profileNamed(String name) => (
    name: name,
    gender: Gender.preferNotToSay,
    weightKg: 72,
    heightCm: 175,
    dateOfBirth: null,
    age: 30,
  );

  Future<ProviderContainer> freshApp(WidgetTester tester) async {
    final container = await bootstrap();
    await container.read(documentStoreProvider).clear();
    for (final module in container.read(featureModulesProvider)) {
      await module.clearLocalData(container.read);
    }
    container.read(dataVersionProvider.notifier).bump();
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const GymTrackerApp(),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets(
    'gate, check-in, persistence, backup and restore on a real device',
    (tester) async {
      var container = await freshApp(tester);
      expect(
        find.text("Welcome to Gymlicious. Let's get you set up."),
        findsOneWidget,
      );

      container
          .read(profileControllerProvider.notifier)
          .saveValues(profileNamed('Sam'));
      await tester.pumpAndSettle();
      expect(find.text('Home'), findsWidgets);

      await tester.ensureVisible(find.text('I worked out today'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('I worked out today'));
      await tester.pumpAndSettle();
      expect(container.read(isTodayDoneProvider), isTrue);
      expect(container.read(streakSnapshotProvider).currentDays, 1);
      await tester.tapAt(const Offset(4, 4));
      await tester.pumpAndSettle();

      final service = container.read(backupServiceProvider);
      final backupText = (await service.createBackup()).encode();

      container
          .read(profileControllerProvider.notifier)
          .saveValues(profileNamed('Changed'));
      final plan = service.prepareRestore(backupText);
      expect(plan, isA<Ok<RestorePlan>>());
      final restored = await service.restore((plan as Ok<RestorePlan>).value);
      expect(restored, isA<Ok<void>>());
      container.read(dataVersionProvider.notifier).bump();
      await tester.pumpAndSettle();
      expect(container.read(profileControllerProvider)?.name, 'Sam');
      expect(container.read(isTodayDoneProvider), isTrue);

      await container.read(documentStoreProvider).flush();
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();

      container = await bootstrap();
      addTearDown(container.dispose);
      expect(container.read(profileControllerProvider)?.name, 'Sam');
      expect(container.read(checkInControllerProvider).entries, hasLength(1));
    },
  );
}
