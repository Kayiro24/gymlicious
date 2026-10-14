import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/clock/today_provider.dart';
import 'package:gym_tracker/core/providers.dart';
import 'package:gym_tracker/features/checkin/data/check_in_repository.dart';
import 'package:gym_tracker/features/checkin/domain/check_in_entry.dart';
import 'package:gym_tracker/features/checkin/domain/check_in_log.dart';
import 'package:gym_tracker/features/checkin/domain/check_in_rules.dart';
import 'package:gym_tracker/features/checkin/domain/day_record.dart';
import 'package:gym_tracker/features/checkin/domain/day_time.dart';
import 'package:gym_tracker/features/checkin/domain/streak_calculator.dart';
import 'package:gym_tracker/features/checkin/domain/streak_snapshot.dart';
import 'package:gym_tracker/features/checkin/domain/training_week.dart';
import 'package:gym_tracker/features/workouts/workouts.dart';

final checkInRepositoryProvider = Provider<CheckInRepository>(
  (ref) => CheckInRepository(ref.watch(documentStoreProvider)),
);

class CheckInController extends Notifier<CheckInLog> {
  @override
  CheckInLog build() {
    ref.watch(dataVersionProvider);
    return ref.watch(checkInRepositoryProvider).load();
  }

  CalendarDate get _today => ref.read(todayProvider);

  /// Built here rather than read from [dayRecordsProvider], which depends on
  /// this notifier.
  DayRecord? _recordFor(CalendarDate date) {
    final sessions = ref
        .read(workoutsControllerProvider)
        .sessions
        .where(
          (session) => CalendarDate.fromDateTime(session.startedAt) == date,
        );
    return DayRecords.build(state, sessions, _today)[date];
  }

  void _update(
    CalendarDate date,
    CheckInEntry Function(CheckInEntry entry) change,
  ) {
    final entry = change(state.entryFor(date))
        .copyWith(updatedAt: ref.read(clockProvider).now());
    state = state.withEntry(entry);
    ref.read(checkInRepositoryProvider).save(state);
  }

  /// Stores null when the choice matches what a logged session would give,
  /// so deleting that session later still updates the day (D49).
  void setDone(CalendarDate date, {required bool isDone}) {
    if (isDone && !CheckInRules.canMarkDone(date, _today)) {
      return;
    }
    final hasSession = _recordFor(date)?.hasSession ?? false;
    _update(
      date,
      (entry) => entry.copyWith(done: isDone == hasSession ? null : isDone),
    );
  }

  void toggleDone(CalendarDate date) =>
      setDone(date, isDone: !(_recordFor(date)?.isDone ?? false));

  void saveDetails(
    CalendarDate date, {
    required String note,
    required DayTime? time,
    required int? durationMinutes,
  }) => _update(
    date,
    (entry) => entry.copyWith(
      note: note.trim(),
      time: time,
      durationMinutes: date.isAfter(_today) ? null : durationMinutes,
    ),
  );

  /// Applies from this week's Monday; past weeks keep their goal.
  void setWeeklyGoal(int days) {
    state = state.copyWith(
      goals: state.goals.withGoal(TrainingWeek.mondayOf(_today), days),
    );
    ref.read(checkInRepositoryProvider).save(state);
  }
}

final checkInControllerProvider =
    NotifierProvider<CheckInController, CheckInLog>(CheckInController.new);

final dayRecordsProvider = Provider<Map<CalendarDate, DayRecord>>((ref) {
  final log = ref.watch(checkInControllerProvider);
  final sessions = ref.watch(
    workoutsControllerProvider.select((data) => data.sessions),
  );
  return DayRecords.build(log, sessions, ref.watch(todayProvider));
});

final streakCalculatorProvider = Provider<StreakCalculator>(
  (ref) => WeeklyStreakCalculator(ref.watch(clockProvider)),
);

final streakSnapshotProvider = Provider<StreakSnapshot>((ref) {
  ref.watch(todayProvider);
  final records = ref.watch(dayRecordsProvider);
  final goals = ref.watch(checkInControllerProvider.select((log) => log.goals));
  return ref.watch(streakCalculatorProvider).compute((
    workoutDays: DayRecords.workoutDays(records),
    goals: goals,
  ));
});

/// The goal the settings row edits: the newest one.
final weeklyGoalProvider = Provider<int>(
  (ref) =>
      ref.watch(checkInControllerProvider.select((log) => log.goals.latest)),
);

final isTodayDoneProvider = Provider<bool>((ref) {
  final today = ref.watch(todayProvider);
  return ref.watch(dayRecordsProvider)[today]?.isDone ?? false;
});
