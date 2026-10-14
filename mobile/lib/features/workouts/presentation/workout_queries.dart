import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/features/settings/settings.dart';
import 'package:gym_tracker/features/workouts/domain/entities/exercise_stats.dart';
import 'package:gym_tracker/features/workouts/domain/entities/split.dart';
import 'package:gym_tracker/features/workouts/domain/rules/exercise_stats_calculator.dart';
import 'package:gym_tracker/features/workouts/domain/rules/up_next.dart';
import 'package:gym_tracker/features/workouts/presentation/workouts_controller.dart';

/// Max/last per exercise id from finished sessions (the draft is excluded).
final exerciseStatsProvider = Provider<Map<String, ExerciseStats>>((ref) {
  final data = ref.watch(workoutsControllerProvider);
  return ExerciseStatsCalculator.computeAll(data.exercises, data.sessions);
});

/// The active split, falling back to the first split when none is chosen.
final activeSplitProvider = Provider<WorkoutSplit?>((ref) {
  final splits = ref.watch(workoutsControllerProvider.select((d) => d.splits));
  final activeId = ref.watch(
    settingsControllerProvider.select((settings) => settings.activeSplitId),
  );
  for (final split in splits) {
    if (split.id == activeId) {
      return split;
    }
  }
  return splits.isEmpty ? null : splits.first;
});

final upNextDayProvider = Provider<SplitDay?>((ref) {
  final split = ref.watch(activeSplitProvider);
  if (split == null) {
    return null;
  }
  final sessions = ref.watch(
    workoutsControllerProvider.select((data) => data.sessions),
  );
  return UpNext.dayFor(split, sessions);
});
