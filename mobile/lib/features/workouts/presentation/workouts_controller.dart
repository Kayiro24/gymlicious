import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/failure/failure.dart';
import 'package:gym_tracker/core/failure/result.dart';
import 'package:gym_tracker/core/providers.dart';
import 'package:gym_tracker/features/workouts/data/document_workout_repository.dart';
import 'package:gym_tracker/features/workouts/domain/entities/exercise.dart';
import 'package:gym_tracker/features/workouts/domain/entities/exercise_enums.dart';
import 'package:gym_tracker/features/workouts/domain/entities/seed_catalog.dart';
import 'package:gym_tracker/features/workouts/domain/entities/split.dart';
import 'package:gym_tracker/features/workouts/domain/entities/workout_data.dart';
import 'package:gym_tracker/features/workouts/domain/entities/workout_session.dart';
import 'package:gym_tracker/features/workouts/domain/repositories/workout_repository.dart';
import 'package:gym_tracker/features/workouts/domain/rules/exercise_name_rules.dart';
import 'package:gym_tracker/features/workouts/domain/rules/exercise_stats_calculator.dart';
import 'package:gym_tracker/features/workouts/domain/rules/session_summary.dart';
import 'package:gym_tracker/features/workouts/domain/session/session_editor.dart';
import 'package:gym_tracker/features/workouts/domain/session/session_factory.dart';

final workoutRepositoryProvider = Provider<WorkoutRepository>(
  (ref) => DocumentWorkoutRepository(ref.watch(documentStoreProvider)),
);

final seedCatalogProvider = Provider<SeedCatalog>((ref) => SeedCatalog.empty);

const exerciseNameField = 'name';

typedef StartingWeight = ({double? maxKg, double? lastKg});

class WorkoutsController extends Notifier<WorkoutData> {
  @override
  WorkoutData build() {
    ref.watch(dataVersionProvider);
    final repository = ref.watch(workoutRepositoryProvider);
    final data = repository.load();
    if (data.exercises.isNotEmpty || data.sessions.isNotEmpty) {
      return data;
    }
    final seeded = data.copyWith(
      exercises: ref.read(seedCatalogProvider).exercises,
    );
    repository.save(seeded);
    return seeded;
  }

  String _id(String prefix) => ref.read(idGeneratorProvider).next(prefix);

  DateTime _now() => ref.read(clockProvider).now();

  void _commit(WorkoutData next) {
    state = next;
    ref.read(workoutRepositoryProvider).save(next);
  }

  Result<Exercise> _nameFailure(ExerciseNameProblem problem) =>
      Err(ValidationFailure({exerciseNameField: problem.name}));

  Result<Exercise> addExercise({
    required String name,
    required MuscleGroup muscleGroup,
    required Equipment equipment,
    double? baselineMaxKg,
  }) {
    final problem = ExerciseNameRules.check(name, state.exercises);
    if (problem != null) {
      return _nameFailure(problem);
    }
    final exercise = Exercise(
      id: _id('ex'),
      name: name.trim(),
      muscleGroup: muscleGroup,
      equipment: equipment,
      isCustom: true,
      baselineMaxKg: baselineMaxKg,
    );
    _commit(state.copyWith(exercises: [...state.exercises, exercise]));
    return Ok(exercise);
  }

  Result<Exercise> updateExercise(Exercise exercise) {
    if (!exercise.isArchived) {
      final problem = ExerciseNameRules.check(
        exercise.name,
        state.exercises,
        ignoreId: exercise.id,
      );
      if (problem != null) {
        return _nameFailure(problem);
      }
    }
    final updated = exercise.copyWith(name: exercise.name.trim());
    _commit(
      state.copyWith(
        exercises: [
          for (final current in state.exercises)
            if (current.id == updated.id) updated else current,
        ],
      ),
    );
    return Ok(updated);
  }

  bool hasHistory(String exerciseId) =>
      state.sessions.any((session) => session.entryFor(exerciseId) != null) ||
      state.activeSession?.entryFor(exerciseId) != null;

  /// Archives an exercise with history and hard-deletes one without (also
  /// removing it from splits). Returns true when it was archived.
  bool removeExercise(String exerciseId) {
    final exercise = state.exerciseById(exerciseId);
    if (exercise == null) {
      return false;
    }
    if (hasHistory(exerciseId)) {
      updateExercise(exercise.copyWith(isArchived: true));
      return true;
    }
    _commit(
      state.copyWith(
        exercises: [
          for (final current in state.exercises)
            if (current.id != exerciseId) current,
        ],
        splits: [
          for (final split in state.splits)
            split.copyWith(
              days: [
                for (final day in split.days)
                  day.copyWith(
                    exerciseIds: [
                      for (final id in day.exerciseIds)
                        if (id != exerciseId) id,
                    ],
                  ),
              ],
            ),
        ],
      ),
    );
    return false;
  }

  Result<Exercise> unarchiveExercise(String exerciseId) {
    final exercise = state.exerciseById(exerciseId);
    if (exercise == null) {
      return _nameFailure(ExerciseNameProblem.empty);
    }
    return updateExercise(exercise.copyWith(isArchived: false));
  }

  /// Starting weights from setup; a last weight is dated today.
  void setBaselines(Map<String, StartingWeight> baselines) {
    final today = CalendarDate.fromDateTime(_now());
    _commit(
      state.copyWith(
        exercises: [
          for (final exercise in state.exercises)
            if (baselines[exercise.id] case final baseline?)
              exercise.copyWith(
                baselineMaxKg: baseline.maxKg,
                baselineLastKg: baseline.lastKg,
                baselineLastDate: baseline.lastKg == null ? null : today,
              )
            else
              exercise,
        ],
      ),
    );
  }

  /// Copies a preset with fresh ids so the user can edit it freely.
  WorkoutSplit addSplitFromPreset(WorkoutSplit preset) {
    final split = preset.copyWith(
      id: _id('split'),
      days: [for (final day in preset.days) day.copyWith(id: _id('day'))],
    );
    _commit(state.copyWith(splits: [...state.splits, split]));
    return split;
  }

  WorkoutSplit createSplit({
    required String name,
    required String firstDayName,
  }) {
    final split = WorkoutSplit(
      id: _id('split'),
      name: name.trim(),
      days: [SplitDay(id: _id('day'), name: firstDayName)],
    );
    _commit(state.copyWith(splits: [...state.splits, split]));
    return split;
  }

  /// Adds a split built in the editor, giving it a permanent id.
  WorkoutSplit addSplit({required String name, required List<SplitDay> days}) {
    final split = WorkoutSplit(id: _id('split'), name: name.trim(), days: days);
    _commit(state.copyWith(splits: [...state.splits, split]));
    return split;
  }

  String newDayId() => _id('day');

  void saveSplit(WorkoutSplit split) => _commit(
    state.copyWith(
      splits: [
        for (final current in state.splits)
          if (current.id == split.id) split else current,
      ],
    ),
  );

  void deleteSplit(String splitId) => _commit(
    state.copyWith(
      splits: [
        for (final split in state.splits)
          if (split.id != splitId) split,
      ],
    ),
  );

  WorkoutSession startSession({WorkoutSplit? split, SplitDay? day}) {
    final session = SessionFactory.start(
      id: _id('ses'),
      startedAt: _now(),
      exercises: state.exercises,
      history: state.sessions,
      stats: ExerciseStatsCalculator.computeAll(
        state.exercises,
        state.sessions,
      ),
      split: split,
      day: day,
    );
    _commit(state.copyWith(activeSession: session));
    return session;
  }

  void updateActiveSession(WorkoutSession Function(WorkoutSession) change) {
    final active = state.activeSession;
    if (active == null) {
      return;
    }
    _commit(state.copyWith(activeSession: change(active)));
  }

  /// Saves the draft as a finished session and summarises it against the
  /// stats from before it. Returns null when nothing was completed.
  SessionSummary? finishActiveSession() {
    final active = state.activeSession;
    if (active == null) {
      return null;
    }
    final statsBefore = ExerciseStatsCalculator.computeAll(
      state.exercises,
      state.sessions,
    );
    final finished = active.withoutEmptyEntries().copyWith(endedAt: _now());
    if (!finished.hasCompletedWork) {
      _commit(state.copyWith(activeSession: null));
      return null;
    }
    _commit(
      state.copyWith(
        sessions: [...state.sessions, finished],
        activeSession: null,
      ),
    );
    return SessionSummary.of(finished, statsBefore);
  }

  void discardActiveSession() => _commit(state.copyWith(activeSession: null));

  void saveSession(WorkoutSession session) => _commit(
    state.copyWith(
      sessions: [
        for (final current in state.sessions)
          if (current.id == session.id) session else current,
      ],
    ),
  );

  WorkoutSession? deleteSession(String sessionId) {
    final removed = state.sessionById(sessionId);
    if (removed == null) {
      return null;
    }
    _commit(
      state.copyWith(
        sessions: [
          for (final session in state.sessions)
            if (session.id != sessionId) session,
        ],
      ),
    );
    return removed;
  }

  void restoreSession(WorkoutSession session) {
    if (state.sessionById(session.id) != null) {
      return;
    }
    _commit(state.copyWith(sessions: [...state.sessions, session]));
  }
}

final workoutsControllerProvider =
    NotifierProvider<WorkoutsController, WorkoutData>(WorkoutsController.new);
