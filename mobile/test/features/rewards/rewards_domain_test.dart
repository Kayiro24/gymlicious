import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/features/checkin/checkin_domain.dart';
import 'package:gym_tracker/features/rewards/rewards_domain.dart';

import '../../fakes/fake_gateways.dart';
import '../workouts/domain/workout_fixtures.dart';

CalendarDate _oct(int day) => CalendarDate(2026, 10, day);

void main() {
  group('levels', () {
    test('follow 50 × L × (L − 1)', () {
      expect(RewardRules.totalXpForLevel(1), 0);
      expect(RewardRules.totalXpForLevel(2), 100);
      expect(RewardRules.totalXpForLevel(5), 1000);
      expect(RewardRules.totalXpForLevel(10), 4500);
    });

    test('progress within a level', () {
      final progress = LevelProgress.fromTotalXp(720);
      expect(progress.level, 4);
      expect(progress.xpIntoLevel, 120);
      expect(progress.xpForLevel, 400);
      expect(progress.xpToNext, 280);
      expect(LevelProgress.fromTotalXp(0).level, 1);
      expect(LevelProgress.fromTotalXp(100).level, 2);
    });
  });

  group('personal records', () {
    test('the first lift sets the bar; only later beats count', () {
      final records = PersonalRecords.find(
        const [bench],
        [
          session('a', DateTime(2026, 10, 5, 18), {
            bench: [done(60)],
          }),
          session('b', DateTime(2026, 10, 7, 18), {
            bench: [done(62.5), done(65)],
          }),
          session('c', DateTime(2026, 10, 9, 18), {
            bench: [done(65)],
          }),
        ],
      );
      expect(records, hasLength(1));
      expect(records.single.weightKg, 65);
      expect(records.single.date, _oct(7));
    });

    test('a baseline max must be beaten; warm-ups never count', () {
      final records = PersonalRecords.find(
        [bench.copyWith(baselineMaxKg: 100)],
        [
          session('a', DateTime(2026, 10, 5, 18), {
            bench: [done(95), done(120, warmup: true)],
          }),
          session('b', DateTime(2026, 10, 7, 18), {
            bench: [done(102.5)],
          }),
        ],
      );
      expect(records.map((record) => record.weightKg), [102.5]);
    });
  });

  group('badges', () {
    test('are deserved when their metric reaches the threshold', () {
      final deserved = Badges.deserved(
        const BadgeMetrics(
          workouts: 12,
          bestStreak: 7,
          personalRecords: 0,
          weeksMet: 1,
        ),
      );
      expect(deserved, {
        BadgeKind.firstWorkout,
        BadgeKind.streak3,
        BadgeKind.streak7,
        BadgeKind.firstFullWeek,
        BadgeKind.workouts10,
      });
    });

    test('next is the locked badge closest to done', () {
      const metrics = BadgeMetrics(
        workouts: 8,
        bestStreak: 2,
        personalRecords: 0,
        weeksMet: 0,
      );
      final next = Badges.next(metrics, {BadgeKind.firstWorkout.id})!;
      expect(next.kind, BadgeKind.workouts10);
      expect(next.remaining, 2);
      expect(
        Badges.next(metrics, {for (final k in BadgeKind.values) k.id}),
        isNull,
      );
    });

    test('there are 12 badges with unique ids', () {
      expect(BadgeKind.values, hasLength(12));
      expect({for (final kind in BadgeKind.values) kind.id}, hasLength(12));
      expect(BadgeKind.byId('streak_30'), BadgeKind.streak30);
      expect(BadgeKind.byId('nope'), isNull);
    });
  });

  group('summary', () {
    test('adds XP for days, session days, PRs and met weeks', () {
      final sessions = [
        session('a', DateTime(2026, 10, 12, 18), {
          bench: [done(60)],
        }),
        session('b', DateTime(2026, 10, 13, 18), {
          bench: [done(65)],
        }),
      ];
      final log = const CheckInLog()
          .withEntry(CheckInEntry(date: _oct(14), done: true))
          .withEntry(CheckInEntry(date: _oct(15), done: true));
      final today = _oct(18);
      final days = DayRecords.build(log, sessions, today);
      final streak = WeeklyStreakCalculator(
        FixedClock(DateTime(2026, 10, 18, 9)),
      ).compute((workoutDays: DayRecords.workoutDays(days), goals: log.goals));

      final summary = RewardsSummary.compute(
        days: days,
        streak: streak,
        exercises: const [bench],
        sessions: sessions,
      );
      // 4 check-ins, 2 session days, 1 PR, 1 met week (goal 4).
      expect(summary.level.totalXp, 40 + 20 + 25 + 50);
      expect(summary.metrics.workouts, 4);
      expect(summary.metrics.personalRecords, 1);
      expect(summary.metrics.weeksMet, 1);
      expect(summary.metrics.bestStreak, 4);
    });

    test('undoing a check-in takes its XP back', () {
      final today = _oct(14);
      RewardsSummary summaryFor(CheckInLog log) {
        final days = DayRecords.build(log, const [], today);
        final streak =
            WeeklyStreakCalculator(FixedClock(DateTime(2026, 10, 14, 9)))
                .compute((
                  workoutDays: DayRecords.workoutDays(days),
                  goals: log.goals,
                ));
        return RewardsSummary.compute(
          days: days,
          streak: streak,
          exercises: const [],
          sessions: const [],
        );
      }

      final checkedIn = const CheckInLog().withEntry(
        CheckInEntry(date: today, done: true),
      );
      expect(summaryFor(checkedIn).level.totalXp, RewardRules.checkInXp);
      expect(summaryFor(const CheckInLog()).level.totalXp, 0);
    });
  });
}
