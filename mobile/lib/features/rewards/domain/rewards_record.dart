import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';

part 'rewards_record.freezed.dart';

@freezed
abstract class EarnedBadge with _$EarnedBadge {
  const factory({required String id, required CalendarDate earnedAt}) =
      _EarnedBadge;
}

/// What the rewards feature stores. XP and level are derived and never
/// stored; badges are kept once earned (D46).
@freezed
abstract class RewardsRecord with _$RewardsRecord {
  const factory({
    @Default(<EarnedBadge>[]) List<EarnedBadge> earnedBadges,

    /// Null until the first evaluation, which records silently.
    int? lastCelebratedLevel,
  }) = _RewardsRecord;

  const new _();

  bool get isInitialised => lastCelebratedLevel != null;

  Set<String> get earnedIds => {for (final badge in earnedBadges) badge.id};

  EarnedBadge? badge(String id) =>
      earnedBadges.where((badge) => badge.id == id).firstOrNull;
}
