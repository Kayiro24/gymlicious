import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/clock/iso_date_time.dart';
import 'package:gym_tracker/features/workouts/data/dto/exercise_dto.dart';
import 'package:gym_tracker/features/workouts/data/dto/session_dto.dart';
import 'package:gym_tracker/features/workouts/data/dto/split_dto.dart';
import 'package:gym_tracker/features/workouts/domain/entities/exercise.dart';
import 'package:gym_tracker/features/workouts/domain/entities/exercise_enums.dart';
import 'package:gym_tracker/features/workouts/domain/entities/exercise_stats.dart';
import 'package:gym_tracker/features/workouts/domain/entities/split.dart';
import 'package:gym_tracker/features/workouts/domain/entities/workout_session.dart';
import 'package:gym_tracker/features/workouts/domain/entities/workout_set.dart';

abstract final class WorkoutMapper {
  static Exercise exerciseFromDto(ExerciseDto dto) => Exercise(
    id: dto.id,
    name: dto.name,
    muscleGroup:
        MuscleGroup.tryParse(dto.muscleGroup) ??
        (throw FormatException('Unknown muscle group ${dto.muscleGroup}')),
    equipment:
        Equipment.tryParse(dto.equipment) ??
        (throw FormatException('Unknown equipment ${dto.equipment}')),
    isCustom: dto.isCustom,
    isArchived: dto.archived,
    baselineMaxKg: dto.baselineMaxKg,
    baselineLastKg: dto.baselineLastKg,
    baselineLastDate: _date(dto.baselineLastDate),
    notes: dto.notes,
  );

  static ExerciseDto exerciseToDto(Exercise exercise, ExerciseStats stats) =>
      ExerciseDto(
        id: exercise.id,
        name: exercise.name,
        muscleGroup: exercise.muscleGroup.name,
        equipment: exercise.equipment.name,
        isCustom: exercise.isCustom,
        archived: exercise.isArchived,
        baselineMaxKg: exercise.baselineMaxKg,
        baselineLastKg: exercise.baselineLastKg,
        baselineLastDate: exercise.baselineLastDate?.toIso(),
        maxWeightKg: stats.maxKg,
        maxWeightDate: stats.maxDate?.toIso(),
        lastWeightKg: stats.lastKg,
        lastWeightDate: stats.lastDate?.toIso(),
        notes: exercise.notes,
      );

  static WorkoutSplit splitFromDto(SplitDto dto) {
    final days = [...dto.days]..sort((a, b) => a.order.compareTo(b.order));
    return WorkoutSplit(
      id: dto.id,
      name: dto.name,
      isPreset: dto.isPreset,
      days: [
        for (final day in days)
          SplitDay(
            id: day.id,
            name: day.name,
            isRest: day.isRest,
            exerciseIds: day.exerciseIds,
          ),
      ],
    );
  }

  static SplitDto splitToDto(WorkoutSplit split) => SplitDto(
    id: split.id,
    name: split.name,
    isPreset: split.isPreset,
    days: [
      for (final (index, day) in split.days.indexed)
        SplitDayDto(
          id: day.id,
          name: day.name,
          order: index,
          isRest: day.isRest,
          exerciseIds: day.exerciseIds,
        ),
    ],
  );

  static WorkoutSession sessionFromDto(SessionDto dto) => WorkoutSession(
    id: dto.id,
    startedAt: IsoDateTime.parse(dto.startedAt),
    endedAt: IsoDateTime.tryParse(dto.endedAt),
    splitId: dto.splitId,
    dayId: dto.dayId,
    dayName: dto.dayNameSnapshot,
    note: dto.note,
    entries: [
      for (final entry in dto.entries)
        SessionEntry(
          exerciseId: entry.exerciseId,
          exerciseName: entry.exerciseNameSnapshot,
          note: entry.note,
          sets: [
            for (final set in entry.sets)
              WorkoutSet(
                weightKg: set.weightKg,
                reps: set.reps,
                isWarmup: set.isWarmup,
                isDone: set.done,
              ),
          ],
        ),
    ],
  );

  static SessionDto sessionToDto(WorkoutSession session) {
    final endedAt = session.endedAt;
    return SessionDto(
      id: session.id,
      startedAt: IsoDateTime.format(session.startedAt),
      endedAt: endedAt == null ? null : IsoDateTime.format(endedAt),
      splitId: session.splitId,
      dayId: session.dayId,
      dayNameSnapshot: session.dayName,
      note: session.note,
      entries: [
        for (final entry in session.entries)
          SessionEntryDto(
            exerciseId: entry.exerciseId,
            exerciseNameSnapshot: entry.exerciseName,
            note: entry.note,
            sets: [
              for (final set in entry.sets)
                SetDto(
                  weightKg: set.weightKg,
                  reps: set.reps,
                  isWarmup: set.isWarmup,
                  done: set.isDone,
                ),
            ],
          ),
      ],
    );
  }

  static CalendarDate? _date(String? iso) =>
      iso == null ? null : CalendarDate.parse(iso);
}
