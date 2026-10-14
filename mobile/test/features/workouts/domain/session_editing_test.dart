import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/features/workouts/domain/entities/exercise_stats.dart';
import 'package:gym_tracker/features/workouts/domain/entities/workout_data.dart';
import 'package:gym_tracker/features/workouts/domain/entities/workout_session.dart';
import 'package:gym_tracker/features/workouts/domain/session/session_editor.dart';
import 'package:gym_tracker/features/workouts/domain/session/session_factory.dart';

import 'workout_fixtures.dart';

final _monday = DateTime(2026, 10, 12, 18);

void main() {
  group('SessionFactory', () {
    test('a split day starts with its exercises, prefilled from history', () {
      final history = [
        session('s1', _monday, {
          bench: [done(60), done(62.5)],
        }),
      ];
      final started = SessionFactory.start(
        id: 'new',
        startedAt: _monday.add(const Duration(days: 2)),
        exercises: const [bench, pullUp],
        history: history,
        stats: const {},
        split: ppl,
        day: ppl.days.first,
      );
      expect(started.splitId, 'split_ppl');
      expect(started.dayName, 'Push');
      expect(started.entries.single.exerciseId, bench.id);
      expect(started.entries.single.sets.map((set) => set.weightKg), [
        60,
        62.5,
      ]);
      expect(started.entries.single.sets.every((set) => !set.isDone), isTrue);
    });

    test('archived exercises are left out; freestyle starts empty', () {
      final archived = bench.copyWith(isArchived: true);
      final started = SessionFactory.start(
        id: 'new',
        startedAt: _monday,
        exercises: [archived],
        history: const [],
        stats: const {},
        split: ppl,
        day: ppl.days.first,
      );
      expect(started.entries, isEmpty);
      final freestyle = SessionFactory.start(
        id: 'free',
        startedAt: _monday,
        exercises: const [bench],
        history: const [],
        stats: const {},
      );
      expect(freestyle.splitId, isNull);
      expect(freestyle.entries, isEmpty);
    });
  });

  group('SessionEditor', () {
    final base = session('s', _monday, {
      bench: [done(60)],
      pullUp: [done(0)],
    });

    test('set edits only touch the chosen entry', () {
      final edited = base
          .replaceSet(0, 0, done(65))
          .insertSet(0, 0, done(40, warmup: true))
          .addSet(0, const ExerciseStats(lastKg: 65));
      expect(edited.entries[0].sets.map((set) => set.weightKg), [40, 65, 65]);
      expect(edited.entries[1], base.entries[1]);
      expect(edited.removeSet(0, 0).entries[0].sets, hasLength(2));
      expect(base.entries[0].sets.single.weightKg, 60);
    });

    test('entries can be added, inserted, moved and removed', () {
      const extra = SessionEntry(exerciseId: 'x', exerciseName: 'X');
      final edited = base.addEntry(extra).insertEntry(0, extra);
      expect(edited.entries.map((entry) => entry.exerciseId), [
        'x',
        bench.id,
        pullUp.id,
        'x',
      ]);
      expect(edited.moveEntry(0, 99).entries.map((entry) => entry.exerciseId), [
        bench.id,
        pullUp.id,
        'x',
        'x',
      ]);
      expect(edited.removeEntry(0).entries.first.exerciseId, bench.id);
    });

    test('notes are kept and empty entries are dropped on finish', () {
      const empty = SessionEntry(exerciseId: 'x', exerciseName: 'X');
      final edited = base.setEntryNote(1, 'Slow').addEntry(empty);
      expect(edited.entries[1].note, 'Slow');
      expect(edited.withoutEmptyEntries().entries, hasLength(2));
    });
  });

  group('WorkoutData lookups', () {
    final older = session('a', _monday, {
      bench: [done(60)],
    });
    final newer = session('b', _monday.add(const Duration(days: 1)), {});
    final data = WorkoutData(
      exercises: [bench, pullUp.copyWith(isArchived: true)],
      splits: const [ppl],
      sessions: [newer, older],
    );

    test('finds items by id and orders sessions newest first', () {
      expect(data.exerciseById(bench.id), bench);
      expect(data.exerciseById('missing'), isNull);
      expect(data.splitById('split_ppl'), ppl);
      expect(data.splitById(null), isNull);
      expect(data.sessionById('a'), older);
      expect(data.sessionById('z'), isNull);
      expect(data.activeExercises, [bench]);
      expect(
        WorkoutData(sessions: [older, newer]).sessionsNewestFirst
            .map((s) => s.id),
        ['b', 'a'],
      );
    });

    test('session totals count only completed working sets', () {
      final mixed = session('m', _monday, {
        bench: [done(100, reps: 2), done(50, warmup: true), planned(200)],
      });
      expect(mixed.volumeKg, 200);
      expect(mixed.entries.single.bestWeightKg, 100);
      expect(mixed.hasCompletedWork, isTrue);
      expect(mixed.duration, const Duration(hours: 1));
      expect(mixed.entryFor(bench.id), isNotNull);
      expect(mixed.entryFor('nope'), isNull);
    });
  });
}
