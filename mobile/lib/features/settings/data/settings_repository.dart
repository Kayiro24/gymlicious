import 'package:gym_tracker/core/storage/document_store.dart';
import 'package:gym_tracker/core/storage/json_cast.dart';
import 'package:gym_tracker/core/storage/parsed_section.dart';
import 'package:gym_tracker/features/settings/data/settings_dto.dart';
import 'package:gym_tracker/features/settings/data/settings_mapper.dart';
import 'package:gym_tracker/features/settings/domain/app_settings.dart';

class SettingsRepository {
  const new(this.store);

  static const sectionKey = 'settings';

  static const section = ParsedSection(
    key: sectionKey,
    emptyValue: null,
    parse: parse,
  );

  final DocumentStore store;

  static AppSettings parse(Object? raw) {
    final json = JsonCast.optionalObject(raw, sectionKey);
    return json == null
        ? const AppSettings()
        : SettingsMapper.fromDto(SettingsDto.fromJson(json));
  }

  AppSettings load() => parse(store.read(sectionKey));

  void save(AppSettings settings) =>
      store.write(sectionKey, SettingsMapper.toDto(settings).toJson());
}
