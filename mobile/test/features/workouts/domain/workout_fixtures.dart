import 'package:gym_tracker/features/workouts/domain/entities/exercise.dart';
import 'package:gym_tracker/features/workouts/domain/entities/exercise_enums.dart';
import 'package:gym_tracker/features/workouts/domain/entities/split.dart';
import 'package:gym_tracker/features/workouts/domain/entities/workout_session.dart';
import 'package:gym_tracker/features/workouts/domain/entities/workout_set.dart';

const bench = Exercise(
  id: 'ex_bench',
  name: 'Bench Press',
  muscleGroup: MuscleGroup.chest,
  equipment: Equipment.barbell,
);

const pullUp = Exercise(
  id: 'ex_pull_up',
  name: 'Pull-Up',
  muscleGroup: MuscleGroup.back,
  equipment: Equipment.bodyweight,
);

WorkoutSet done(double kg, {int reps = 5, bool warmup = false}) =>
    WorkoutSet(weightKg: kg, reps: reps, isDone: true, isWarmup: warmup);

WorkoutSet planned(double kg) => WorkoutSet(weightKg: kg, reps: 5);

WorkoutSession session(
  String id,
  DateTime startedAt,
  Map<Exercise, List<WorkoutSet>> sets, {
  String? splitId,
  String? dayId,
}) => WorkoutSession(
  id: id,
  startedAt: startedAt,
  endedAt: startedAt.add(const Duration(hours: 1)),
  splitId: splitId,
  dayId: dayId,
  entries: [
    for (final MapEntry(key: exercise, value: exerciseSets) in sets.entries)
      SessionEntry(
        exerciseId: exercise.id,
        exerciseName: exercise.name,
        sets: exerciseSets,
      ),
  ],
);

const ppl = WorkoutSplit(
  id: 'split_ppl',
  name: 'PPL',
  days: [
    SplitDay(id: 'push', name: 'Push', exerciseIds: ['ex_bench']),
    SplitDay(id: 'rest', name: 'Rest', isRest: true),
    SplitDay(id: 'pull', name: 'Pull', exerciseIds: ['ex_pull_up']),
    SplitDay(id: 'legs', name: 'Legs'),
  ],
);
