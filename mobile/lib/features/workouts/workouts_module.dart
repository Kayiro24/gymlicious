import 'package:gym_tracker/core/module/feature_module.dart';
import 'package:gym_tracker/features/workouts/data/workout_sections.dart';

/// Screen-less owner of exercises, splits and sessions (D31).
const workoutsModule = FeatureModule(
  name: 'workouts',
  sections: WorkoutSections.all,
);
