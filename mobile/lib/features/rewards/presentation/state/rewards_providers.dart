import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/providers.dart';
import 'package:gym_tracker/features/checkin/checkin.dart';
import 'package:gym_tracker/features/rewards/data/rewards_repository.dart';
import 'package:gym_tracker/features/rewards/domain/badges.dart';
import 'package:gym_tracker/features/rewards/domain/rewards_record.dart';
import 'package:gym_tracker/features/rewards/domain/rewards_summary.dart';
import 'package:gym_tracker/features/workouts/workouts.dart';

final rewardsRepositoryProvider = Provider<RewardsRepository>(
  (ref) => RewardsRepository(ref.watch(documentStoreProvider)),
);

/// The stored part of rewards: badges once earned and the last level that
/// was celebrated.
class RewardsController extends Notifier<RewardsRecord> {
  @override
  RewardsRecord build() {
    ref.watch(dataVersionProvider);
    return ref.watch(rewardsRepositoryProvider).load();
  }

  /// Records newly deserved badges and the level; returns the badges that
  /// were new. Badges already stored are never removed (D46).
  List<BadgeKind> record({
    required Set<BadgeKind> deserved,
    required int level,
    required CalendarDate today,
  }) {
    final earned = state.earnedIds;
    final fresh = [
      for (final kind in BadgeKind.values)
        if (deserved.contains(kind) && !earned.contains(kind.id)) kind,
    ];
    final celebrated = state.lastCelebratedLevel ?? 0;
    final next = state.copyWith(
      earnedBadges: [
        ...state.earnedBadges,
        for (final kind in fresh) EarnedBadge(id: kind.id, earnedAt: today),
      ],
      lastCelebratedLevel: level > celebrated ? level : celebrated,
    );
    if (next != state) {
      state = next;
      ref.read(rewardsRepositoryProvider).save(next);
    }
    return fresh;
  }
}

final rewardsControllerProvider =
    NotifierProvider<RewardsController, RewardsRecord>(RewardsController.new);

final rewardsSummaryProvider = Provider<RewardsSummary>((ref) {
  final workouts = ref.watch(workoutsControllerProvider);
  return RewardsSummary.compute(
    days: ref.watch(dayRecordsProvider),
    streak: ref.watch(streakSnapshotProvider),
    exercises: workouts.exercises,
    sessions: workouts.sessions,
  );
});

final nextBadgeProvider = Provider<BadgeProgress?>((ref) {
  final metrics = ref.watch(rewardsSummaryProvider).metrics;
  final earned = ref.watch(rewardsControllerProvider).earnedIds;
  return Badges.next(metrics, {
    ...earned,
    for (final kind in Badges.deserved(metrics)) kind.id,
  });
});
