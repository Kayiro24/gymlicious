import 'package:gym_tracker/features/workouts/domain/entities/exercise_stats.dart';
import 'package:gym_tracker/features/workouts/domain/entities/workout_session.dart';
import 'package:gym_tracker/features/workouts/domain/entities/workout_set.dart';
import 'package:gym_tracker/features/workouts/domain/rules/set_prefill.dart';

/// Pure edits on a session; every method returns a new session.
extension SessionEditor on WorkoutSession {
  WorkoutSession _withEntry(
    int entryIndex,
    SessionEntry Function(SessionEntry entry) change,
  ) => copyWith(
    entries: [
      for (final (index, entry) in entries.indexed)
        if (index == entryIndex) change(entry) else entry,
    ],
  );

  WorkoutSession replaceSet(int entryIndex, int setIndex, WorkoutSet set) =>
      _withEntry(
        entryIndex,
        (entry) => entry.copyWith(
          sets: [
            for (final (index, current) in entry.sets.indexed)
              if (index == setIndex) set else current,
          ],
        ),
      );

  WorkoutSession addSet(int entryIndex, ExerciseStats stats) => _withEntry(
    entryIndex,
    (entry) => entry.copyWith(
      sets: [...entry.sets, SetPrefill.nextSet(entry.sets, stats)],
    ),
  );

  WorkoutSession insertSet(int entryIndex, int setIndex, WorkoutSet set) =>
      _withEntry(
        entryIndex,
        (entry) => entry.copyWith(sets: [...entry.sets]..insert(setIndex, set)),
      );

  WorkoutSession removeSet(int entryIndex, int setIndex) => _withEntry(
    entryIndex,
    (entry) => entry.copyWith(sets: [...entry.sets]..removeAt(setIndex)),
  );

  WorkoutSession setEntryNote(int entryIndex, String note) =>
      _withEntry(entryIndex, (entry) => entry.copyWith(note: note));

  WorkoutSession addEntry(SessionEntry entry) =>
      copyWith(entries: [...entries, entry]);

  WorkoutSession insertEntry(int entryIndex, SessionEntry entry) =>
      copyWith(entries: [...entries]..insert(entryIndex, entry));

  WorkoutSession removeEntry(int entryIndex) =>
      copyWith(entries: [...entries]..removeAt(entryIndex));

  WorkoutSession moveEntry(int from, int to) {
    final reordered = [...entries];
    final moved = reordered.removeAt(from);
    reordered.insert(to.clamp(0, reordered.length), moved);
    return copyWith(entries: reordered);
  }

  /// Drops exercises with no sets so empty cards don't clutter history.
  WorkoutSession withoutEmptyEntries() => copyWith(
    entries: entries.where((entry) => entry.sets.isNotEmpty).toList(),
  );
}
