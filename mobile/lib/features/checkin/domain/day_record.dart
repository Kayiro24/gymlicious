import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/features/checkin/domain/check_in_log.dart';
import 'package:gym_tracker/features/checkin/domain/day_time.dart';
import 'package:gym_tracker/features/workouts/workouts_domain.dart';

part 'day_record.freezed.dart';

/// One day as the app shows it: the user's check-in merged with any logged
/// workout session that started that day.
@freezed
abstract class DayRecord with _$DayRecord {
  const factory({
    required CalendarDate date,
    required bool isDone,
    required bool hasSession,
    @Default('') String note,
    DayTime? time,
    int? durationMinutes,
  }) = _DayRecord;

  const new _();

  /// Done only because a session was logged and the user never chose.
  bool isDoneBySession(CheckInLog log) =>
      isDone && hasSession && log.entries[date]?.done == null;
}

abstract final class DayRecords {
  static const _secondsPerMinute = 60;

  /// Every day that has a check-in or a session. Future days are never done
  /// (D49); an explicit Done or not-Done always beats a session.
  static Map<CalendarDate, DayRecord> build(
    CheckInLog log,
    Iterable<WorkoutSession> sessions,
    CalendarDate today,
  ) {
    final sessionsByDay = <CalendarDate, List<WorkoutSession>>{};
    for (final session in sessions) {
      sessionsByDay
          .putIfAbsent(CalendarDate.fromDateTime(session.startedAt), () => [])
          .add(session);
    }
    final dates = {...log.entries.keys, ...sessionsByDay.keys};
    return {
      for (final date in dates)
        date: _record(log, date, sessionsByDay[date] ?? const [], today),
    };
  }

  static DayRecord _record(
    CheckInLog log,
    CalendarDate date,
    List<WorkoutSession> sessions,
    CalendarDate today,
  ) {
    final entry = log.entryFor(date);
    final hasSession = sessions.isNotEmpty;
    final firstStart = sessions.isEmpty
        ? null
        : sessions
              .map((session) => session.startedAt)
              .reduce((a, b) => a.isBefore(b) ? a : b);
    final sessionMinutes = sessions.fold(
      0,
      (total, session) =>
          total + session.duration.inSeconds ~/ _secondsPerMinute,
    );
    return DayRecord(
      date: date,
      isDone: !date.isAfter(today) && (entry.done ?? hasSession),
      hasSession: hasSession,
      note: entry.note,
      time:
          entry.time ??
          (firstStart == null ? null : DayTime.fromDateTime(firstStart)),
      durationMinutes:
          entry.durationMinutes ?? (sessionMinutes > 0 ? sessionMinutes : null),
    );
  }

  static Set<CalendarDate> workoutDays(Map<CalendarDate, DayRecord> records) =>
      {
        for (final record in records.values)
          if (record.isDone) record.date,
      };
}
