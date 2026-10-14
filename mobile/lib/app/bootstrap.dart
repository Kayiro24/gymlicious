import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/app/app_modules.dart';
import 'package:gym_tracker/core/logging/app_logger.dart';
import 'package:gym_tracker/core/providers.dart';
import 'package:gym_tracker/core/storage/atomic_json_store.dart';
import 'package:gym_tracker/core/storage/document_store.dart';
import 'package:gym_tracker/core/storage/io_file_gateway.dart';
import 'package:gym_tracker/core/storage/schema_migrations.dart';
import 'package:gym_tracker/features/quotes/quotes.dart';
import 'package:gym_tracker/features/workouts/workouts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

/// Loads the data file (parsed in an isolate), seed assets and bundled
/// quotes while the native splash is still showing, then wires providers.
Future<ProviderContainer> bootstrap() async {
  const logger = kReleaseMode
      ? SilentLogger()
      : DeveloperLogger(minimumLevel: LogLevel.debug);
  final files = IoFileGateway(await getApplicationDocumentsDirectory());
  final store = DocumentStore(
    dataStore: AtomicJsonStore(files: files),
    sections: [for (final module in appModules) ...module.sections],
    migrator: appSchemaMigrator,
    logger: logger,
  );
  final (loadStatus, seed, bundledQuotes, packageInfo) = await (
    store.load(),
    SeedCatalogLoader(rootBundle).load(),
    BundledQuotesLoader(rootBundle).load(),
    PackageInfo.fromPlatform(),
  ).wait;
  return ProviderContainer(
    overrides: [
      loggerProvider.overrideWithValue(logger),
      fileGatewayProvider.overrideWithValue(files),
      documentStoreProvider.overrideWithValue(store),
      featureModulesProvider.overrideWithValue(appModules),
      initialLoadStatusProvider.overrideWithValue(loadStatus),
      appVersionProvider.overrideWithValue(packageInfo.version),
      seedCatalogProvider.overrideWithValue(seed),
      bundledQuotesProvider.overrideWithValue(bundledQuotes),
    ],
  );
}
