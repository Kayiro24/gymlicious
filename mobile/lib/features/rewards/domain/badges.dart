/// What a badge measures.
enum BadgeMetric { workouts, bestStreak, personalRecords, weeksMet }

/// The 12 milestones from the brief, in display order.
enum BadgeKind {
  firstWorkout('first_workout', BadgeMetric.workouts, 1),
  streak3('streak_3', BadgeMetric.bestStreak, 3),
  streak7('streak_7', BadgeMetric.bestStreak, 7),
  streak14('streak_14', BadgeMetric.bestStreak, 14),
  streak30('streak_30', BadgeMetric.bestStreak, 30),
  streak60('streak_60', BadgeMetric.bestStreak, 60),
  streak100('streak_100', BadgeMetric.bestStreak, 100),
  firstPersonalRecord('first_pr', BadgeMetric.personalRecords, 1),
  firstFullWeek('first_full_week', BadgeMetric.weeksMet, 1),
  workouts10('workouts_10', BadgeMetric.workouts, 10),
  workouts50('workouts_50', BadgeMetric.workouts, 50),
  workouts100('workouts_100', BadgeMetric.workouts, 100);

  new(this.id, this.metric, this.threshold);

  final String id;
  final BadgeMetric metric;
  final int threshold;

  static BadgeKind? byId(String id) =>
      values.where((kind) => kind.id == id).firstOrNull;
}

/// The numbers badges are judged on, all derived from stored data.
class BadgeMetrics {
  const new({
    required this.workouts,
    required this.bestStreak,
    required this.personalRecords,
    required this.weeksMet,
  });

  static const zero = BadgeMetrics(
    workouts: 0,
    bestStreak: 0,
    personalRecords: 0,
    weeksMet: 0,
  );

  final int workouts;
  final int bestStreak;
  final int personalRecords;
  final int weeksMet;

  int valueOf(BadgeMetric metric) => switch (metric) {
    BadgeMetric.workouts => workouts,
    BadgeMetric.bestStreak => bestStreak,
    BadgeMetric.personalRecords => personalRecords,
    BadgeMetric.weeksMet => weeksMet,
  };
}

typedef BadgeProgress = ({BadgeKind kind, int current, int remaining});

abstract final class Badges {
  static Set<BadgeKind> deserved(BadgeMetrics metrics) => {
    for (final kind in BadgeKind.values)
      if (metrics.valueOf(kind.metric) >= kind.threshold) kind,
  };

  static BadgeProgress progressOf(BadgeKind kind, BadgeMetrics metrics) {
    final current = metrics.valueOf(kind.metric).clamp(0, kind.threshold);
    return (kind: kind, current: current, remaining: kind.threshold - current);
  }

  /// The locked badge closest to done (by fraction; ties keep display
  /// order), or null when everything is earned.
  static BadgeProgress? next(BadgeMetrics metrics, Set<String> earnedIds) {
    BadgeProgress? best;
    var bestFraction = -1.0;
    for (final kind in BadgeKind.values) {
      if (earnedIds.contains(kind.id)) {
        continue;
      }
      final progress = progressOf(kind, metrics);
      final fraction = progress.current / kind.threshold;
      if (fraction > bestFraction) {
        best = progress;
        bestFraction = fraction;
      }
    }
    return best;
  }
}
