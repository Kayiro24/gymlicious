import 'package:gym_tracker/core/storage/data_store.dart';
import 'package:gym_tracker/core/storage/schema_migrator.dart';

/// The warm UI upgrade: adds the check-in and rewards sections and the
/// reminder setting, and maps the retired Sage wallpaper preset to Ember
/// (D53). Past sessions need nothing: they count as workout days by rule.
class V1ToV2Migration implements SchemaMigration {
  const new();

  @override
  int get fromVersion => 1;

  @override
  JsonMap migrate(JsonMap document) {
    final migrated = Map<String, Object?>.of(document)
      ..putIfAbsent(
        'checkIns',
        () => <String, Object?>{
          'days': <String, Object?>{},
          'goalHistory': <Object?>[],
        },
      )
      ..putIfAbsent(
        'rewards',
        () => <String, Object?>{
          'earnedBadges': <Object?>[],
          'lastCelebratedLevel': null,
        },
      );
    final settings = migrated['settings'];
    if (settings is Map<String, Object?>) {
      final updated = Map<String, Object?>.of(settings)
        ..putIfAbsent(
          'checkInReminder',
          () => <String, Object?>{'isEnabled': false, 'time': '19:00'},
        );
      final yearDots = updated['yearDots'];
      if (yearDots is Map<String, Object?> &&
          yearDots['colorPreset'] == 'sage') {
        updated['yearDots'] = {...yearDots, 'colorPreset': 'ember'};
      }
      migrated['settings'] = updated;
    }
    return migrated;
  }
}
