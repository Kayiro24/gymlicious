import 'package:gym_tracker/features/workouts/domain/entities/exercise.dart';
import 'package:gym_tracker/features/workouts/domain/entities/split.dart';

/// Bundled starting exercises and preset splits.
class SeedCatalog {
  const new({required this.exercises, required this.presets});

  static const empty = SeedCatalog(exercises: [], presets: []);

  final List<Exercise> exercises;
  final List<WorkoutSplit> presets;
}
