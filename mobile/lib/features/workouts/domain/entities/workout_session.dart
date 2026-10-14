import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gym_tracker/features/workouts/domain/entities/workout_set.dart';

part 'workout_session.freezed.dart';

@freezed
abstract class SessionEntry with _$SessionEntry {
  const factory({
    required String exerciseId,
    required String exerciseName,
    @Default(<WorkoutSet>[]) List<WorkoutSet> sets,
    @Default('') String note,
  }) = _SessionEntry;

  const new _();

  Iterable<WorkoutSet> get countedSets =>
      sets.where((set) => set.countsForStats);

  /// Heaviest completed working set, or null if none were completed.
  double? get bestWeightKg {
    double? best;
    for (final set in countedSets) {
      if (best == null || set.weightKg > best) {
        best = set.weightKg;
      }
    }
    return best;
  }

  double get volumeKg => countedSets.fold(
    0,
    (total, set) => total + set.weightKg * (set.reps ?? 0),
  );
}

/// A logged workout. [splitId] and [dayId] are null for freestyle sessions;
/// [dayName] is a snapshot so history survives split edits and deletion.
@freezed
abstract class WorkoutSession with _$WorkoutSession {
  const factory({
    required String id,
    required DateTime startedAt,
    DateTime? endedAt,
    String? splitId,
    String? dayId,
    String? dayName,
    @Default(<SessionEntry>[]) List<SessionEntry> entries,
    @Default('') String note,
  }) = _WorkoutSession;

  const new _();

  bool get isFinished => endedAt != null;

  Duration get duration =>
      endedAt == null ? Duration.zero : endedAt!.difference(startedAt);

  SessionEntry? entryFor(String exerciseId) {
    for (final entry in entries) {
      if (entry.exerciseId == exerciseId) {
        return entry;
      }
    }
    return null;
  }

  bool get hasCompletedWork =>
      entries.any((entry) => entry.countedSets.isNotEmpty);

  double get volumeKg =>
      entries.fold(0, (total, entry) => total + entry.volumeKg);
}
