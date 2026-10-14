import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/storage/migrations/v1_to_v2_migration.dart';
import 'package:gym_tracker/core/storage/schema_migrations.dart';
import 'package:gym_tracker/features/checkin/checkin_domain.dart';
import 'package:gym_tracker/features/checkin/data/check_in_repository.dart';

import '../workouts/domain/workout_fixtures.dart';

CalendarDate _oct(int day) => CalendarDate(2026, 10, day);

void main() {
  group('DayRecords', () {
    final today = _oct(14);
    final logged = session('s', DateTime(2026, 10, 13, 18, 5), {
      bench: [done(60)],
    });

    test('a logged session marks its day done with its time and length', () {
      final records = DayRecords.build(const CheckInLog(), [logged], today);
      final record = records[_oct(13)]!;
      expect(record.isDone, isTrue);
      expect(record.hasSession, isTrue);
      expect(record.time, const DayTime(18, 5));
      expect(record.durationMinutes, 60);
      expect(record.isDoneBySession(const CheckInLog()), isTrue);
    });

    test('an explicit not-done beats the session; the session stays', () {
      final log = const CheckInLog().withEntry(
        CheckInEntry(date: _oct(13), done: false),
      );
      final record = DayRecords.build(log, [logged], today)[_oct(13)]!;
      expect(record.isDone, isFalse);
      expect(record.hasSession, isTrue);
    });

    test('the user time and duration win over the session', () {
      final log = const CheckInLog().withEntry(
        CheckInEntry(
          date: _oct(13),
          time: const DayTime(7, 30),
          durationMinutes: 45,
        ),
      );
      final record = DayRecords.build(log, [logged], today)[_oct(13)]!;
      expect(record.time, const DayTime(7, 30));
      expect(record.durationMinutes, 45);
      expect(record.isDone, isTrue);
    });

    test('future days are never done, but keep their plan', () {
      final log = const CheckInLog().withEntry(
        CheckInEntry(date: _oct(16), done: true, note: 'Legs'),
      );
      final record = DayRecords.build(log, const [], today)[_oct(16)]!;
      expect(record.isDone, isFalse);
      expect(record.note, 'Legs');
    });

    test('workoutDays lists only done days', () {
      final log = const CheckInLog()
          .withEntry(CheckInEntry(date: _oct(12), done: true))
          .withEntry(CheckInEntry(date: _oct(14), note: 'Rest and stretch'));
      final records = DayRecords.build(log, [logged], today);
      expect(DayRecords.workoutDays(records), {_oct(12), _oct(13)});
    });
  });

  group('CheckInLog', () {
    test('a blank entry is dropped so storage stays small', () {
      final log = const CheckInLog()
          .withEntry(CheckInEntry(date: _oct(12), done: true))
          .withEntry(CheckInEntry(date: _oct(12)));
      expect(log.entries, isEmpty);
    });
  });

  group('CheckInRepository', () {
    final log = CheckInLog(
      entries: {
        _oct(13): CheckInEntry(
          date: _oct(13),
          done: true,
          note: 'Chest',
          time: const DayTime(18, 30),
          durationMinutes: 60,
        ),
      },
      goals: const WeeklyGoalHistory().withGoal(_oct(12), 3),
    );

    test('round-trips through JSON', () {
      expect(CheckInRepository.parse(CheckInRepository.toJson(log)), log);
    });

    test('dates are keys, so each day is stored once', () {
      final json = CheckInRepository.toJson(log);
      expect((json['days']! as Map).keys, ['2026-10-13']);
    });

    test('rejects goals that do not start on a Monday', () {
      expect(
        () => CheckInRepository.parse({
          'days': <String, Object?>{},
          'goalHistory': [
            {'effectiveFrom': '2026-10-14', 'daysPerWeek': 4},
          ],
        }),
        throwsFormatException,
      );
    });

    test('rejects out-of-range durations and bad dates', () {
      expect(
        () => CheckInRepository.parse({
          'days': {
            '2026-10-13': {'done': true, 'durationMin': 0},
          },
        }),
        throwsFormatException,
      );
      expect(
        () => CheckInRepository.parse({
          'days': {
            '2026-02-30': {'done': true},
          },
        }),
        throwsFormatException,
      );
    });
  });

  group('DayTime', () {
    test('parses and prints HH:mm', () {
      expect(DayTime.parse('06:05'), const DayTime(6, 5));
      expect(const DayTime(18, 30).toStorage(), '18:30');
      expect(() => DayTime.parse('24:00'), throwsFormatException);
      expect(() => DayTime.parse('7:00'), throwsFormatException);
    });
  });

  group('schema v1 to v2', () {
    final v1 = {
      'schemaVersion': 1,
      'profile': {'name': 'Aman'},
      'settings': {
        'theme': 'dark',
        'yearDots': {'colorPreset': 'sage', 'layout': 'months'},
      },
      'sessions': <Object?>[],
    };

    test('adds the new sections and keeps everything else', () {
      final migrated = appSchemaMigrator.migrate(v1);
      expect(migrated['schemaVersion'], currentSchemaVersion);
      expect(migrated['profile'], {'name': 'Aman'});
      expect(migrated['checkIns'], {
        'days': <String, Object?>{},
        'goalHistory': <Object?>[],
      });
      expect(migrated['rewards'], {
        'earnedBadges': <Object?>[],
        'lastCelebratedLevel': null,
      });
      final settings = migrated['settings']! as Map<String, Object?>;
      expect(settings['theme'], 'dark');
      expect(settings['checkInReminder'], {
        'isEnabled': false,
        'time': '19:00',
      });
      expect(settings['yearDots'], {
        'colorPreset': 'ember',
        'layout': 'months',
      });
    });

    test('never overwrites sections that already exist', () {
      final existing = {
        ...v1,
        'checkIns': {
          'days': {
            '2026-10-13': {'done': true},
          },
        },
      };
      final migrated = const V1ToV2Migration().migrate(existing);
      expect(migrated['checkIns'], existing['checkIns']);
    });

    test('a file without settings migrates cleanly', () {
      final migrated = appSchemaMigrator.migrate({'schemaVersion': 1});
      expect(migrated.containsKey('settings'), isFalse);
      expect(migrated['checkIns'], isNotNull);
    });
  });
}
