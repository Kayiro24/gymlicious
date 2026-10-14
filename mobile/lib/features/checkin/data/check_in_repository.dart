import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/clock/iso_date_time.dart';
import 'package:gym_tracker/core/storage/document_store.dart';
import 'package:gym_tracker/core/storage/json_cast.dart';
import 'package:gym_tracker/core/storage/parsed_section.dart';
import 'package:gym_tracker/features/checkin/domain/check_in_entry.dart';
import 'package:gym_tracker/features/checkin/domain/check_in_log.dart';
import 'package:gym_tracker/features/checkin/domain/check_in_rules.dart';
import 'package:gym_tracker/features/checkin/domain/day_time.dart';
import 'package:gym_tracker/features/checkin/domain/weekly_goal.dart';

/// The `checkIns` section: `days` keyed by "YYYY-MM-DD" (one per day by
/// construction) and the `goalHistory` list.
class CheckInRepository {
  const new(this.store);

  static const sectionKey = 'checkIns';
  static const Map<String, Object?> emptyJson = {
    'days': <String, Object?>{},
    'goalHistory': <Object?>[],
  };

  static const section = ParsedSection(
    key: sectionKey,
    emptyValue: emptyJson,
    parse: parse,
  );

  final DocumentStore store;

  CheckInLog load() => parse(store.read(sectionKey));

  void save(CheckInLog log) => store.write(sectionKey, toJson(log));

  static CheckInLog parse(Object? raw) {
    final json = JsonCast.optionalObject(raw, sectionKey);
    if (json == null) {
      return const CheckInLog();
    }
    final days = JsonCast.optionalObject(json['days'], 'days') ?? const {};
    return CheckInLog(
      entries: {
        for (final MapEntry(:key, :value) in days.entries)
          CalendarDate.parse(key): _entry(CalendarDate.parse(key), value),
      },
      goals: WeeklyGoalHistory(
        periods: [
          for (final period in JsonCast.objectList(
            json['goalHistory'] ?? const <Object?>[],
            'goalHistory',
          ))
            _period(period),
        ],
      ),
    );
  }

  static CheckInEntry _entry(CalendarDate date, Object? raw) {
    final json = JsonCast.object(raw, 'day ${date.toIso()}');
    final done = json['done'];
    final note = json['note'] ?? '';
    final time = json['time'];
    final duration = json['durationMin'];
    if ((done != null && done is! bool) ||
        note is! String ||
        (time != null && time is! String) ||
        (duration != null && duration is! int)) {
      throw FormatException('Invalid check-in for ${date.toIso()}');
    }
    if (duration is int && !CheckInRules.isValidDuration(duration)) {
      throw FormatException('Duration out of range on ${date.toIso()}');
    }
    final updatedAt = json['updatedAt'];
    return CheckInEntry(
      date: date,
      done: done as bool?,
      note: note,
      time: time is String ? DayTime.parse(time) : null,
      durationMinutes: duration as int?,
      updatedAt: updatedAt is String ? IsoDateTime.tryParse(updatedAt) : null,
    );
  }

  static GoalPeriod _period(Map<String, dynamic> json) {
    final from = json['effectiveFrom'];
    final days = json['daysPerWeek'];
    if (from is! String ||
        days is! int ||
        !WeeklyGoalHistory.isValidGoal(days)) {
      throw const FormatException('Invalid goal history entry');
    }
    final effectiveFrom = CalendarDate.parse(from);
    if (effectiveFrom.weekday != DateTime.monday) {
      throw FormatException('Goal must start on a Monday', from);
    }
    return GoalPeriod(effectiveFrom: effectiveFrom, daysPerWeek: days);
  }

  static Map<String, Object?> toJson(CheckInLog log) => {
    'days': {
      for (final entry
          in (log.entries.values.toList()
            ..sort((a, b) => a.date.compareTo(b.date))))
        entry.date.toIso(): {
          'done': entry.done,
          'note': entry.note,
          'time': entry.time?.toStorage(),
          'durationMin': entry.durationMinutes,
          'updatedAt': switch (entry.updatedAt) {
            final updatedAt? => IsoDateTime.format(updatedAt),
            null => null,
          },
        },
    },
    'goalHistory': [
      for (final period in log.goals.periods)
        {
          'effectiveFrom': period.effectiveFrom.toIso(),
          'daysPerWeek': period.daysPerWeek,
        },
    ],
  };
}
