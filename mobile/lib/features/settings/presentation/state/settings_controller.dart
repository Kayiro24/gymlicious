import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/providers.dart';
import 'package:gym_tracker/features/settings/data/settings_repository.dart';
import 'package:gym_tracker/features/settings/domain/app_settings.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(documentStoreProvider)),
);

class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    ref.watch(dataVersionProvider);
    return ref.watch(settingsRepositoryProvider).load();
  }

  void update(AppSettings Function(AppSettings current) change) {
    final next = change(state);
    if (next == state) {
      return;
    }
    state = next;
    ref.read(settingsRepositoryProvider).save(next);
  }
}

final settingsControllerProvider =
    NotifierProvider<SettingsController, AppSettings>(SettingsController.new);
