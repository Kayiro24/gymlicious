import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/features/checkin/checkin_domain.dart';
import 'package:gym_tracker/features/rewards/domain/badges.dart';
import 'package:gym_tracker/features/rewards/domain/personal_records.dart';
import 'package:gym_tracker/features/rewards/domain/reward_rules.dart';
import 'package:gym_tracker/features/workouts/workouts_domain.dart';

/// XP, level and badge metrics, recomputed from days, sessions and weeks so
/// they can never drift from the log.
class RewardsSummary {
  const new({
    required this.level,
    required this.metrics,
    required this.personalRecords,
  });

  factory compute({
    required Map<CalendarDate, DayRecord> days,
    required StreakSnapshot streak,
    required Iterable<Exercise> exercises,
    required Iterable<WorkoutSession> sessions,
  }) {
    final sessionDays = {
      for (final session in sessions)
        if (session.hasCompletedWork)
          CalendarDate.fromDateTime(session.startedAt),
    };
    final workoutDays = [
      for (final record in days.values)
        if (record.isDone) record.date,
    ];
    final records = PersonalRecords.find(exercises, sessions);
    final weeksMet = streak.weeks.where((week) => week.isMet).length;
    final xp =
        workoutDays.length * RewardRules.checkInXp +
        workoutDays.where(sessionDays.contains).length * RewardRules.sessionXp +
        records.length * RewardRules.personalRecordXp +
        weeksMet * RewardRules.weeklyGoalXp;
    return RewardsSummary(
      level: LevelProgress.fromTotalXp(xp),
      personalRecords: records,
      metrics: BadgeMetrics(
        workouts: workoutDays.length,
        bestStreak: streak.bestDays,
        personalRecords: records.length,
        weeksMet: weeksMet,
      ),
    );
  }

  final LevelProgress level;
  final BadgeMetrics metrics;
  final List<PersonalRecord> personalRecords;
}
