import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/app/app_modules.dart';
import 'package:gym_tracker/app/gym_tracker_app.dart';
import 'package:gym_tracker/core/logging/app_logger.dart';
import 'package:gym_tracker/core/platform/platform_providers.dart';
import 'package:gym_tracker/core/providers.dart';
import 'package:gym_tracker/core/storage/document_store.dart';
import 'package:gym_tracker/core/storage/schema_migrations.dart';
import 'package:gym_tracker/features/profile/profile.dart';
import 'package:gym_tracker/features/quotes/quotes.dart';
import 'package:gym_tracker/features/workouts/workouts.dart';

import '../fakes/fake_gateways.dart';
import '../fakes/memory_file_gateway.dart';

/// Window sizes from spec 8.1: a phone and a tablet in landscape.
const phoneSize = Size(390, 844);
const tabletSize = Size(1280, 800);

final testNow = DateTime(2026, 10, 14, 9, 30);

/// Fakes behind every seam, kept for assertions.
class TestApp {
  final dataStore = MemoryDataStore();
  final files = MemoryFileGateway();
  final clock = FixedClock(testNow);
  final wallpaper = FakeWallpaperGateway();
  final share = FakeShareGateway();
  final documents = FakeDocumentGateway();
  final notifications = FakeNotificationGateway();

  late ProviderContainer container;

  /// Builds the app the way bootstrap() does, minus the platform.
  Future<void> pump(
    WidgetTester tester, {
    Size size = phoneSize,
    bool hasProfile = true,
    double textScale = 1,
    void Function(ProviderContainer container)? arrange,
  }) async {
    tester.view
      ..physicalSize = size
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    final store = DocumentStore(
      dataStore: dataStore,
      sections: [for (final module in appModules) ...module.sections],
      migrator: appSchemaMigrator,
      logger: const SilentLogger(),
      debounce: Duration.zero,
    );
    final (status, seed, quotes) = (await tester.runAsync(
      () async => (
        await store.load(),
        await SeedCatalogLoader(rootBundle).load(),
        await BundledQuotesLoader(rootBundle).load(),
      ),
    ))!;

    final overrides = [
      loggerProvider.overrideWithValue(const SilentLogger()),
      clockProvider.overrideWithValue(clock),
      fileGatewayProvider.overrideWithValue(files),
      documentStoreProvider.overrideWithValue(store),
      featureModulesProvider.overrideWithValue(appModules),
      initialLoadStatusProvider.overrideWithValue(status),
      seedCatalogProvider.overrideWithValue(seed),
      bundledQuotesProvider.overrideWithValue(quotes),
      quoteSourcesProvider.overrideWithValue(const []),
      quoteRandomProvider.overrideWithValue(Random(1)),
      wallpaperGatewayProvider.overrideWithValue(wallpaper),
      shareGatewayProvider.overrideWithValue(share),
      documentGatewayProvider.overrideWithValue(documents),
      photoGatewayProvider.overrideWithValue(FakePhotoGateway()),
      notificationGatewayProvider.overrideWithValue(notifications),
    ];

    if (hasProfile || arrange != null) {
      final seeding = ProviderContainer(overrides: overrides);
      if (hasProfile) {
        seeding.read(profileControllerProvider.notifier).saveValues((
          name: 'Sam',
          gender: Gender.preferNotToSay,
          weightKg: 72,
          heightCm: 175,
          dateOfBirth: null,
          age: 30,
        ));
      }
      arrange?.call(seeding);
      seeding.dispose();
    }

    // An owning scope disposes providers (and their timers) with the tree.
    await tester.pumpWidget(
      ProviderScope(overrides: overrides, child: const GymTrackerApp()),
    );
    container = ProviderScope.containerOf(
      tester.element(find.byType(GymTrackerApp)),
    );
    await tester.pumpAndSettle();
  }
}
