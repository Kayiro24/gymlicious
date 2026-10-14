import 'package:gym_tracker/core/storage/document_store.dart';
import 'package:gym_tracker/features/workouts/data/mappers/workout_mapper.dart';
import 'package:gym_tracker/features/workouts/data/workout_sections.dart';
import 'package:gym_tracker/features/workouts/domain/entities/workout_data.dart';
import 'package:gym_tracker/features/workouts/domain/repositories/workout_repository.dart';
import 'package:gym_tracker/features/workouts/domain/rules/exercise_stats_calculator.dart';

class DocumentWorkoutRepository implements WorkoutRepository {
  const new(this.store);

  final DocumentStore store;

  @override
  WorkoutData load() => WorkoutData(
    exercises: WorkoutSections.parseExercises(
      store.read(WorkoutSections.exercisesKey),
    ),
    splits: WorkoutSections.parseSplits(store.read(WorkoutSections.splitsKey)),
    sessions: WorkoutSections.parseSessions(
      store.read(WorkoutSections.sessionsKey),
    ),
    activeSession: WorkoutSections.parseActiveSession(
      store.read(WorkoutSections.activeSessionKey),
    ),
  );

  @override
  void save(WorkoutData data) {
    final stats = ExerciseStatsCalculator.computeAll(
      data.exercises,
      data.sessions,
    );
    final active = data.activeSession;
    store
      ..write(WorkoutSections.exercisesKey, [
        for (final exercise in data.exercises)
          WorkoutMapper.exerciseToDto(exercise, stats[exercise.id]!).toJson(),
      ])
      ..write(WorkoutSections.splitsKey, [
        for (final split in data.splits)
          WorkoutMapper.splitToDto(split).toJson(),
      ])
      ..write(WorkoutSections.sessionsKey, [
        for (final session in data.sessions)
          WorkoutMapper.sessionToDto(session).toJson(),
      ])
      ..write(
        WorkoutSections.activeSessionKey,
        active == null ? null : WorkoutMapper.sessionToDto(active).toJson(),
      );
  }
}
