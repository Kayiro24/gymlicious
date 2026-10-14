import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/core/backup/backup_contributor.dart';
import 'package:gym_tracker/core/backup/document_section_contributor.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/clock/clock.dart';
import 'package:gym_tracker/core/failure/failure.dart';
import 'package:gym_tracker/core/failure/result.dart';
import 'package:gym_tracker/core/logging/app_logger.dart';
import 'package:gym_tracker/core/storage/atomic_json_store.dart';
import 'package:gym_tracker/core/storage/document_store.dart';
import 'package:gym_tracker/core/storage/schema_migrations.dart';
import 'package:gym_tracker/core/units/units.dart';
import 'package:gym_tracker/features/backup/data/backup_service.dart';
import 'package:gym_tracker/features/backup/domain/backup_envelope.dart';
import 'package:gym_tracker/features/checkin/checkin_domain.dart';
import 'package:gym_tracker/features/checkin/data/check_in_repository.dart';
import 'package:gym_tracker/features/profile/data/photo_backup_contributor.dart';
import 'package:gym_tracker/features/profile/data/photo_store.dart';
import 'package:gym_tracker/features/profile/data/profile_repository.dart';
import 'package:gym_tracker/features/profile/domain/profile.dart';
import 'package:gym_tracker/features/rewards/data/rewards_repository.dart';
import 'package:gym_tracker/features/rewards/domain/rewards_record.dart';
import 'package:gym_tracker/features/settings/data/settings_repository.dart';
import 'package:gym_tracker/features/settings/domain/app_settings.dart';
import 'package:gym_tracker/features/workouts/data/document_workout_repository.dart';
import 'package:gym_tracker/features/workouts/data/workout_sections.dart';
import 'package:gym_tracker/features/workouts/domain/entities/workout_data.dart';

import '../../fakes/memory_file_gateway.dart';
import '../workouts/domain/workout_fixtures.dart';

class _FixedClock implements Clock {
  const new(this.value);

  final DateTime value;

  @override
  DateTime now() => value;
}

class _Harness {
  new() {
    store = DocumentStore(
      dataStore: AtomicJsonStore(files: files),
      sections: [
        ProfileRepository.section,
        SettingsRepository.section,
        ...WorkoutSections.all,
        CheckInRepository.section,
        RewardsRepository.section,
      ],
      migrator: appSchemaMigrator,
      logger: const SilentLogger(),
    );
    photos = PhotoStore(files);
    service = BackupService(
      contributors: <BackupContributor>[
        for (final section in store.sections.where((item) => item.isBackedUp))
          DocumentSectionContributor(section, store),
        PhotoBackupContributor(photos),
      ],
      store: store,
      files: files,
      migrator: appSchemaMigrator,
      clock: _FixedClock(DateTime(2026, 10, 14, 9, 30)),
      appVersion: '1.0.0',
    );
  }

  final files = MemoryFileGateway();
  late final DocumentStore store;
  late final PhotoStore photos;
  late final BackupService service;

  ProfileRepository get profiles => ProfileRepository(store);
  SettingsRepository get settings => SettingsRepository(store);
  DocumentWorkoutRepository get workouts => DocumentWorkoutRepository(store);
  CheckInRepository get checkIns => CheckInRepository(store);
  RewardsRepository get rewards => RewardsRepository(store);
}

final _checkIns = CheckInLog(
  entries: {
    const CalendarDate(2026, 10, 12): const CheckInEntry(
      date: CalendarDate(2026, 10, 12),
      done: false,
    ),
    const CalendarDate(2026, 10, 13): CheckInEntry(
      date: const CalendarDate(2026, 10, 13),
      done: true,
      note: 'Chest + triceps',
      time: const DayTime(18, 30),
      durationMinutes: 60,
      updatedAt: DateTime(2026, 10, 13, 19, 40),
    ),
    const CalendarDate(2026, 10, 16): const CheckInEntry(
      date: CalendarDate(2026, 10, 16),
      note: 'Leg day, try heavier squats',
      time: DayTime(7, 0),
    ),
  },
  goals: const WeeklyGoalHistory()
      .withGoal(const CalendarDate(2026, 10, 5), 4)
      .withGoal(const CalendarDate(2026, 10, 12), 3),
);

const _rewards = RewardsRecord(
  earnedBadges: [
    EarnedBadge(id: 'first_workout', earnedAt: CalendarDate(2026, 10, 12)),
    EarnedBadge(id: 'streak_3', earnedAt: CalendarDate(2026, 10, 14)),
  ],
  lastCelebratedLevel: 2,
);

final _photo = Uint8List.fromList(List.generate(300, (index) => index % 256));

Future<_Harness> _populated() async {
  final harness = _Harness();
  await harness.store.load();
  harness.profiles.save(
    Profile(
      name: 'Aman',
      gender: Gender.preferNotToSay,
      weightKg: 74.5,
      heightCm: 178,
      dateOfBirth: const CalendarDate(1998, 4, 12),
      hasPhoto: true,
      createdAt: DateTime(2026, 10, 1, 8),
      updatedAt: DateTime(2026, 10, 2, 8),
    ),
  );
  harness.settings.save(
    const AppSettings(
      weightUnit: WeightUnit.lb,
      weightIncrement: 5,
      quoteMode: QuoteMode.anime,
      activeSplitId: 'split_ppl',
      yearDots: YearDotsSettings(
        layout: YearDotsLayout.months,
        colorPreset: YearDotsColorPreset.ember,
        topMarginPercent: 30,
      ),
    ),
  );
  harness.workouts.save(
    WorkoutData(
      exercises: [bench.copyWith(baselineMaxKg: 90), pullUp],
      splits: const [ppl],
      sessions: [
        session(
          's1',
          DateTime(2026, 10, 12, 17),
          {
            bench: [done(95), done(100)],
            pullUp: [done(0, reps: 10)],
          },
          splitId: ppl.id,
          dayId: 'push',
        ),
      ],
      activeSession: session('draft', DateTime(2026, 10, 14, 8), {
        bench: [planned(100)],
      }),
    ),
  );
  harness.checkIns.save(_checkIns);
  harness.rewards.save(_rewards);
  await harness.photos.write(_photo);
  await harness.store.flush();
  return harness;
}

Future<String> _backupText(_Harness harness) async =>
    (await harness.service.createBackup()).encode();

void main() {
  test('populate → export → wipe → restore gives identical data', () async {
    final harness = await _populated();
    final before = harness.store.snapshot();
    final text = await _backupText(harness);

    await harness.store.clear();
    await harness.photos.delete();
    expect(harness.profiles.load(), isNull);

    final plan = harness.service.prepareRestore(text).valueOrNull!;
    expect(await harness.service.restore(plan), isA<Ok<void>>());

    final after = harness.store.snapshot();
    expect(after['profile'], before['profile']);
    expect(after['settings'], before['settings']);
    expect(after['exercises'], before['exercises']);
    expect(after['splits'], before['splits']);
    expect(after['sessions'], before['sessions']);
    expect(after['activeSession'], isNull);
    expect(after['checkIns'], before['checkIns']);
    expect(after['rewards'], before['rewards']);
    expect(harness.checkIns.load(), _checkIns);
    expect(harness.rewards.load(), _rewards);
    expect(await harness.photos.read(), _photo);

    final reloaded = _Harness()..files.files.addAll(harness.files.files);
    expect(await reloaded.store.load(), DocumentLoadStatus.loaded);
    expect(reloaded.profiles.load()?.name, 'Aman');
    expect(reloaded.checkIns.load(), _checkIns);
    expect(reloaded.rewards.load(), _rewards);
    expect(
      reloaded.settings.load().yearDots.colorPreset,
      YearDotsColorPreset.ember,
    );
  });

  test(
    'the backup excludes the draft session and matches the envelope',
    () async {
      final harness = await _populated();
      final json =
          jsonDecode(await _backupText(harness)) as Map<String, dynamic>;
      final payload = json['payload'] as Map<String, dynamic>;

      expect(json['app'], 'gymtracker');
      expect(json['formatVersion'], 1);
      expect(json['schemaVersion'], currentSchemaVersion);
      expect(payload.containsKey('activeSession'), isFalse);
      expect(payload['photoBase64'], base64Encode(_photo));
      expect(
        BackupEnvelope.fileNameFor(DateTime(2026, 10, 3, 7, 5)),
        'gymlicious-backup-2026-10-03-0705.json',
      );
    },
  );

  test('preview shows name, counts, date and photo', () async {
    final harness = await _populated();
    final plan = harness.service
        .prepareRestore(await _backupText(harness))
        .valueOrNull!;

    expect(plan.preview.profileName, 'Aman');
    expect(plan.preview.exerciseCount, 2);
    expect(plan.preview.sessionCount, 1);
    expect(plan.preview.hasPhoto, isTrue);
    expect(plan.preview.createdAt, DateTime(2026, 10, 14, 9, 30));
  });

  BackupFailureKind? failureOf(Result<Object?> result) => switch (result) {
    Err(failure: BackupFailure(:final kind)) => kind,
    _ => null,
  };

  test('a tampered payload fails the checksum', () async {
    final harness = await _populated();
    final text = await _backupText(harness);
    final tampered = text.replaceFirst('"Aman"', '"Amar"');

    expect(
      failureOf(harness.service.prepareRestore(tampered)),
      BackupFailureKind.damaged,
    );
  });

  test('a backup from a newer app is refused', () async {
    final harness = await _populated();
    final json = jsonDecode(await _backupText(harness)) as Map<String, dynamic>;
    json['schemaVersion'] = currentSchemaVersion + 1;

    expect(
      failureOf(harness.service.prepareRestore(jsonEncode(json))),
      BackupFailureKind.newerSchema,
    );
  });

  test('other files are not mistaken for backups', () async {
    final harness = _Harness();
    await harness.store.load();

    expect(
      failureOf(harness.service.prepareRestore('hello')),
      BackupFailureKind.notABackup,
    );
    expect(
      failureOf(harness.service.prepareRestore('{"app": "other"}')),
      BackupFailureKind.notABackup,
    );
  });

  test(
    'structurally invalid sections are rejected before anything changes',
    () async {
      final harness = await _populated();
      final json =
          jsonDecode(await _backupText(harness)) as Map<String, dynamic>;
      final payload = json['payload'] as Map<String, dynamic>;
      payload['sessions'] = 'not a list';
      json['checksum'] = BackupEnvelope(
        schemaVersion: currentSchemaVersion,
        appVersion: '1.0.0',
        createdAt: DateTime(2026),
        payload: payload,
      ).checksum;

      expect(
        failureOf(harness.service.prepareRestore(jsonEncode(json))),
        BackupFailureKind.invalidStructure,
      );
      expect(harness.profiles.load()?.name, 'Aman');
    },
  );

  test(
    'restore writes pre_restore.json and undo brings the data back',
    () async {
      final source = await _populated();
      final text = await _backupText(source);

      final target = _Harness();
      await target.store.load();
      target.profiles.save(
        Profile(
          name: 'Other',
          gender: Gender.female,
          weightKg: 60,
          heightCm: 165,
          age: 30,
          ageSetOn: const CalendarDate(2026, 1, 1),
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
      );
      await target.store.flush();

      final plan = target.service.prepareRestore(text).valueOrNull!;
      await target.service.restore(plan);

      expect(target.profiles.load()?.name, 'Aman');
      expect(await target.service.hasUndoSnapshot(), isTrue);

      expect(await target.service.undoLastRestore(), isA<Ok<void>>());
      expect(target.profiles.load()?.name, 'Other');
      expect(await target.photos.read(), isNull);
      expect(await target.service.hasUndoSnapshot(), isFalse);
    },
  );

  test('a version 1 backup restores and migrates to version 2', () async {
    final harness = await _populated();
    final json = jsonDecode(await _backupText(harness)) as Map<String, dynamic>;
    final payload =
        Map<String, dynamic>.of(json['payload'] as Map<String, dynamic>)
          ..remove('checkIns')
          ..remove('rewards');
    final settings = Map<String, dynamic>.of(
      payload['settings'] as Map<String, dynamic>,
    )..remove('checkInReminder');
    settings['yearDots'] = {
      ...settings['yearDots'] as Map<String, dynamic>,
      'colorPreset': 'sage',
    };
    payload['settings'] = settings;
    final v1 = BackupEnvelope(
      schemaVersion: 1,
      appVersion: '1.0.0',
      createdAt: DateTime(2026, 10, 2),
      payload: payload,
    ).encode();

    final target = _Harness();
    await target.store.load();
    final plan = target.service.prepareRestore(v1).valueOrNull!;
    expect(await target.service.restore(plan), isA<Ok<void>>());

    expect(target.checkIns.load(), const CheckInLog());
    expect(target.rewards.load(), const RewardsRecord());
    final restored = target.settings.load();
    expect(restored.yearDots.colorPreset, YearDotsColorPreset.ember);
    expect(restored.isCheckInReminderOn, isFalse);
    expect(target.workouts.load().sessions, hasLength(1));
  });
}
