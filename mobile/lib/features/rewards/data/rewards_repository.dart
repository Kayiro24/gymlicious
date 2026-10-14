import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/storage/document_store.dart';
import 'package:gym_tracker/core/storage/json_cast.dart';
import 'package:gym_tracker/core/storage/parsed_section.dart';
import 'package:gym_tracker/features/rewards/domain/rewards_record.dart';

class RewardsRepository {
  const new(this.store);

  static const sectionKey = 'rewards';
  static const Map<String, Object?> emptyJson = {
    'earnedBadges': <Object?>[],
    'lastCelebratedLevel': null,
  };

  static const section = ParsedSection(
    key: sectionKey,
    emptyValue: emptyJson,
    parse: parse,
  );

  final DocumentStore store;

  RewardsRecord load() => parse(store.read(sectionKey));

  void save(RewardsRecord record) => store.write(sectionKey, toJson(record));

  static RewardsRecord parse(Object? raw) {
    final json = JsonCast.optionalObject(raw, sectionKey);
    if (json == null) {
      return const RewardsRecord();
    }
    final level = json['lastCelebratedLevel'];
    if (level != null && level is! int) {
      throw const FormatException('lastCelebratedLevel must be a number');
    }
    return RewardsRecord(
      earnedBadges: [
        for (final badge in JsonCast.objectList(
          json['earnedBadges'] ?? const <Object?>[],
          'earnedBadges',
        ))
          _badge(badge),
      ],
      lastCelebratedLevel: level as int?,
    );
  }

  static EarnedBadge _badge(Map<String, dynamic> json) {
    final id = json['id'];
    final earnedAt = json['earnedAt'];
    if (id is! String || earnedAt is! String) {
      throw const FormatException('Invalid earned badge');
    }
    return EarnedBadge(id: id, earnedAt: CalendarDate.parse(earnedAt));
  }

  static Map<String, Object?> toJson(RewardsRecord record) => {
    'earnedBadges': [
      for (final badge in record.earnedBadges)
        {'id': badge.id, 'earnedAt': badge.earnedAt.toIso()},
    ],
    'lastCelebratedLevel': record.lastCelebratedLevel,
  };
}
