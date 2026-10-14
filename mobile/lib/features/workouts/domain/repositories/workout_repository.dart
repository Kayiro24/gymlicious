import 'package:gym_tracker/features/workouts/domain/entities/workout_data.dart';

abstract interface class WorkoutRepository {
  WorkoutData load();

  /// Persists [data]; saving is debounced by the storage layer.
  void save(WorkoutData data);
}
