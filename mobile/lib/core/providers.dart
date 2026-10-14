import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/backup/backup_contributor.dart';
import 'package:gym_tracker/core/backup/document_section_contributor.dart';
import 'package:gym_tracker/core/clock/clock.dart';
import 'package:gym_tracker/core/config/app_config.dart';
import 'package:gym_tracker/core/ids/id_generator.dart';
import 'package:gym_tracker/core/logging/app_logger.dart';
import 'package:gym_tracker/core/module/feature_module.dart';
import 'package:gym_tracker/core/storage/document_store.dart';
import 'package:gym_tracker/core/storage/file_gateway.dart';

/// Bumped after restore or reset so every controller reloads from storage.
class DataVersion extends Notifier<int> {
  @override
  int build() => 0;

  void bump() => state++;
}

final dataVersionProvider = NotifierProvider<DataVersion, int>(DataVersion.new);

/// Load result of the data file; corrupted until the user restores or
/// starts fresh from the recovery screen.
final initialLoadStatusProvider = Provider<DocumentLoadStatus>(
  (ref) => DocumentLoadStatus.loaded,
);

class StorageStatus extends Notifier<DocumentLoadStatus> {
  @override
  DocumentLoadStatus build() => ref.watch(initialLoadStatusProvider);

  bool get isCorrupted => state == DocumentLoadStatus.corrupted;

  void markHealthy() => state = DocumentLoadStatus.loaded;
}

final storageStatusProvider =
    NotifierProvider<StorageStatus, DocumentLoadStatus>(StorageStatus.new);

final appVersionProvider = Provider<String>((ref) => '1.0.0');

final clockProvider = Provider<Clock>((ref) => const SystemClock());

final idGeneratorProvider = Provider<IdGenerator>((ref) => RandomIdGenerator());

final loggerProvider = Provider<AppLogger>((ref) => const SilentLogger());

final appConfigProvider = Provider<AppConfig>(
  (ref) => AppConfig.fromEnvironment(),
);

final fileGatewayProvider = Provider<FileGateway>(
  (ref) => throw UnimplementedError('Overridden in bootstrap'),
);

final documentStoreProvider = Provider<DocumentStore>(
  (ref) => throw UnimplementedError('Overridden in bootstrap'),
);

final featureModulesProvider = Provider<List<FeatureModule>>(
  (ref) => throw UnimplementedError('Overridden in bootstrap'),
);

/// Every backed-up document section plus each feature's extra contributors.
final backupContributorsProvider = Provider<List<BackupContributor>>((ref) {
  final store = ref.watch(documentStoreProvider);
  final modules = ref.watch(featureModulesProvider);
  return [
    for (final section in store.sections.where((item) => item.isBackedUp))
      DocumentSectionContributor(section, store),
    for (final module in modules) ...module.backupContributors(ref),
  ];
});
