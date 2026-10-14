import 'package:flutter/widgets.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/features/rewards/domain/badges.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

abstract final class BadgeText {
  static String title(AppLocalizations l10n, BadgeKind kind) => switch (kind) {
    BadgeKind.firstWorkout => l10n.badgeFirstWorkout,
    BadgeKind.firstPersonalRecord => l10n.badgeFirstPr,
    BadgeKind.firstFullWeek => l10n.badgeFirstFullWeek,
    _ when kind.metric == BadgeMetric.bestStreak => l10n.badgeStreak(
      kind.threshold,
    ),
    _ => l10n.badgeWorkouts(kind.threshold),
  };

  static IconData icon(BadgeKind kind) => switch (kind) {
    BadgeKind.firstWorkout => LucideIcons.dumbbell,
    BadgeKind.firstPersonalRecord => LucideIcons.trophy,
    BadgeKind.firstFullWeek => LucideIcons.calendarCheck,
    BadgeKind.workouts10 => LucideIcons.medal,
    BadgeKind.workouts50 => LucideIcons.award,
    BadgeKind.workouts100 => LucideIcons.crown,
    _ => LucideIcons.flame,
  };

  static String next(AppLocalizations l10n, BadgeProgress progress) {
    final name = title(l10n, progress.kind);
    return switch (progress.kind.metric) {
      BadgeMetric.workouts => l10n.badgeNextWorkouts(progress.remaining, name),
      BadgeMetric.bestStreak => l10n.badgeNextStreak(progress.remaining, name),
      BadgeMetric.personalRecords => l10n.badgeNextPr(name),
      BadgeMetric.weeksMet => l10n.badgeNextWeek(name),
    };
  }
}
