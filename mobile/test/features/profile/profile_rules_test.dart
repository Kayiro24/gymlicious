import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/units/units.dart';
import 'package:gym_tracker/features/backup/domain/backup_reminder.dart';
import 'package:gym_tracker/features/profile/domain/profile.dart';
import 'package:gym_tracker/features/profile/domain/profile_draft.dart';
import 'package:gym_tracker/features/profile/domain/profile_rules.dart';
import 'package:gym_tracker/features/profile/domain/profile_validator.dart';

const today = CalendarDate(2026, 10, 14);

const validDraft = ProfileDraft(
  name: '  Aman  ',
  gender: Gender.male,
  weight: '74.5',
  heightCm: '178',
  dateOfBirth: CalendarDate(1998, 4, 12),
);

Map<ProfileField, ProfileProblem> errorsOf(ProfileDraft draft) =>
    ProfileValidator.validate(draft, today).errors;

void main() {
  group('ProfileValidator', () {
    test('a complete draft produces canonical values', () {
      final result = ProfileValidator.validate(validDraft, today);

      expect(result.isValid, isTrue);
      expect(result.values?.name, 'Aman');
      expect(result.values?.weightKg, 74.5);
      expect(result.values?.heightCm, 178);
    });

    test('an empty draft reports every mandatory field in form order', () {
      expect(errorsOf(const ProfileDraft()).keys, [
        ProfileField.name,
        ProfileField.gender,
        ProfileField.weight,
        ProfileField.height,
        ProfileField.dateOfBirth,
      ]);
    });

    test('name is 1 to 40 characters after trimming', () {
      expect(
        errorsOf(validDraft.copyWith(name: '   '))[ProfileField.name],
        ProfileProblem.required,
      );
      expect(
        errorsOf(validDraft.copyWith(name: 'x' * 41))[ProfileField.name],
        ProfileProblem.tooLong,
      );
      expect(errorsOf(validDraft.copyWith(name: 'x' * 40)), isEmpty);
    });

    test('weight is 20 to 400 kg, checked in the entered unit', () {
      ProfileProblem? weight(String value, [WeightUnit unit = WeightUnit.kg]) =>
          errorsOf(
            validDraft.copyWith(weight: value, weightUnit: unit),
          )[ProfileField.weight];

      expect(weight('19.9'), ProfileProblem.outOfRange);
      expect(weight('400.1'), ProfileProblem.outOfRange);
      expect(weight('20'), isNull);
      expect(weight('abc'), ProfileProblem.invalidNumber);
      expect(weight('45', WeightUnit.lb), isNull);
      expect(weight('44', WeightUnit.lb), ProfileProblem.outOfRange);
      expect(weight('880', WeightUnit.lb), isNull);
      expect(weight('74,5'), isNull);
    });

    test('height is 90 to 250 cm, or feet and inches', () {
      ProfileProblem? height(ProfileDraft draft) =>
          errorsOf(draft)[ProfileField.height];

      expect(
        height(validDraft.copyWith(heightCm: '89')),
        ProfileProblem.outOfRange,
      );
      expect(
        height(validDraft.copyWith(heightCm: '251')),
        ProfileProblem.outOfRange,
      );

      final imperial = validDraft.copyWith(heightUnit: HeightUnit.ftIn);
      expect(
        height(imperial.copyWith(heightFeet: '5', heightInches: '10')),
        isNull,
      );
      expect(height(imperial.copyWith(heightFeet: '5')), isNull);
      expect(
        height(imperial.copyWith(heightFeet: '5', heightInches: '12')),
        ProfileProblem.invalidNumber,
      );
      expect(
        height(imperial.copyWith(heightFeet: '2')),
        ProfileProblem.outOfRange,
      );
      expect(height(imperial), ProfileProblem.required);
    });

    test('date of birth: not in the future, age 13 to 100', () {
      ProfileProblem? dob(CalendarDate date) => errorsOf(
        validDraft.copyWith(dateOfBirth: date),
      )[ProfileField.dateOfBirth];

      expect(dob(const CalendarDate(2026, 10, 15)), ProfileProblem.inFuture);
      expect(dob(const CalendarDate(2013, 10, 15)), ProfileProblem.outOfRange);
      expect(dob(const CalendarDate(2013, 10, 14)), isNull);
      expect(dob(const CalendarDate(1925, 10, 15)), isNull);
      expect(dob(const CalendarDate(1925, 10, 14)), ProfileProblem.outOfRange);
    });

    test('age-only entry replaces date of birth', () {
      final ageDraft = validDraft.copyWith(usesAge: true, dateOfBirth: null);

      expect(errorsOf(ageDraft)[ProfileField.age], ProfileProblem.required);
      expect(
        errorsOf(ageDraft.copyWith(age: '12'))[ProfileField.age],
        ProfileProblem.outOfRange,
      );
      final valid = ProfileValidator.validate(
        ageDraft.copyWith(age: '28'),
        today,
      );
      expect(valid.values?.age, 28);
      expect(valid.values?.dateOfBirth, isNull);
    });
  });

  group('ProfileRules', () {
    Profile profile({CalendarDate? dob, int? age, CalendarDate? setOn}) =>
        Profile(
          name: 'A',
          gender: Gender.other,
          weightKg: 70,
          heightCm: 175,
          dateOfBirth: dob,
          age: age,
          ageSetOn: setOn,
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        );

    test('age from date of birth counts the birthday only once reached', () {
      final person = profile(dob: const CalendarDate(2000, 10, 15));

      expect(ProfileRules.ageOf(person, today), 25);
      expect(ProfileRules.ageOf(person, const CalendarDate(2026, 10, 15)), 26);
    });

    test('Feb 29 birthdays age on Mar 1 in common years', () {
      final person = profile(dob: const CalendarDate(2008, 2, 29));

      expect(ProfileRules.ageOf(person, const CalendarDate(2026, 2, 28)), 17);
      expect(ProfileRules.ageOf(person, const CalendarDate(2026, 3, 1)), 18);
    });

    test('age-only profiles keep getting older', () {
      final person = profile(age: 30, setOn: const CalendarDate(2026, 10, 14));

      expect(ProfileRules.ageOf(person, today), 30);
      expect(ProfileRules.ageOf(person, const CalendarDate(2027, 10, 13)), 30);
      expect(ProfileRules.ageOf(person, const CalendarDate(2027, 10, 14)), 31);
      expect(ProfileRules.ageOf(person, const CalendarDate(2030, 1, 1)), 33);
    });

    test('isValid guards the gate', () {
      expect(
        ProfileRules.isValid(profile(age: 30, setOn: today), today),
        isTrue,
      );
      expect(ProfileRules.isValid(profile(), today), isFalse);
      expect(
        ProfileRules.isValid(
          profile(age: 30, setOn: today).copyWith(name: ' '),
          today,
        ),
        isFalse,
      );
    });

    test('BMI', () {
      expect(ProfileRules.bodyMassIndex(70, 175), closeTo(22.86, 0.01));
    });
  });

  group('BackupReminder', () {
    final now = DateTime(2026, 10, 14);
    List<DateTime> starts(int count, DateTime after) => [
      for (var i = 1; i <= count; i++) after.add(Duration(days: i)),
    ];

    test('never backed up: due after three sessions', () {
      bool due(int sessions) => BackupReminder.isDue(
        now: now,
        lastBackupAt: null,
        dismissedAt: null,
        sessionStarts: starts(sessions, DateTime(2026, 9)),
        isEnabled: true,
      );

      expect(due(2), isFalse);
      expect(due(3), isTrue);
    });

    test('stale backup: due only with five sessions since', () {
      final lastBackup = DateTime(2026, 9, 20);
      bool due(int sessions, DateTime last) => BackupReminder.isDue(
        now: now,
        lastBackupAt: last,
        dismissedAt: null,
        sessionStarts: starts(sessions, last),
        isEnabled: true,
      );

      expect(due(5, lastBackup), isTrue);
      expect(due(4, lastBackup), isFalse);
      expect(due(9, DateTime(2026, 10, 5)), isFalse);
    });

    test('dismissal and the setting silence it', () {
      final base = (
        now: now,
        lastBackupAt: null,
        sessionStarts: starts(5, DateTime(2026, 9)),
      );

      expect(
        BackupReminder.isDue(
          now: base.now,
          lastBackupAt: base.lastBackupAt,
          dismissedAt: DateTime(2026, 10, 10),
          sessionStarts: base.sessionStarts,
          isEnabled: true,
        ),
        isFalse,
      );
      expect(
        BackupReminder.isDue(
          now: base.now,
          lastBackupAt: base.lastBackupAt,
          dismissedAt: null,
          sessionStarts: base.sessionStarts,
          isEnabled: false,
        ),
        isFalse,
      );
    });
  });
}
