import 'package:gym_tracker/core/storage/json_cast.dart';
import 'package:gym_tracker/core/storage/parsed_section.dart';
import 'package:gym_tracker/features/workouts/data/dto/exercise_dto.dart';
import 'package:gym_tracker/features/workouts/data/dto/session_dto.dart';
import 'package:gym_tracker/features/workouts/data/dto/split_dto.dart';
import 'package:gym_tracker/features/workouts/data/mappers/workout_mapper.dart';
import 'package:gym_tracker/features/workouts/domain/entities/exercise.dart';
import 'package:gym_tracker/features/workouts/domain/entities/split.dart';
import 'package:gym_tracker/features/workouts/domain/entities/workout_session.dart';

abstract final class WorkoutSections {
  static const exercisesKey = 'exercises';
  static const splitsKey = 'splits';
  static const sessionsKey = 'sessions';
  static const activeSessionKey = 'activeSession';

  static List<Exercise> parseExercises(Object? raw) => [
    for (final json in JsonCast.objectList(raw, exercisesKey))
      WorkoutMapper.exerciseFromDto(ExerciseDto.fromJson(json)),
  ];

  static List<WorkoutSplit> parseSplits(Object? raw) => [
    for (final json in JsonCast.objectList(raw, splitsKey))
      WorkoutMapper.splitFromDto(SplitDto.fromJson(json)),
  ];

  static List<WorkoutSession> parseSessions(Object? raw) => [
    for (final json in JsonCast.objectList(raw, sessionsKey))
      WorkoutMapper.sessionFromDto(SessionDto.fromJson(json)),
  ];

  static WorkoutSession? parseActiveSession(Object? raw) {
    final json = JsonCast.optionalObject(raw, activeSessionKey);
    return json == null
        ? null
        : WorkoutMapper.sessionFromDto(SessionDto.fromJson(json));
  }

  static const all = [
    ParsedSection(
      key: exercisesKey,
      emptyValue: <Object?>[],
      parse: parseExercises,
    ),
    ParsedSection(key: splitsKey, emptyValue: <Object?>[], parse: parseSplits),
    ParsedSection(
      key: sessionsKey,
      emptyValue: <Object?>[],
      parse: parseSessions,
    ),
    ParsedSection(
      key: activeSessionKey,
      emptyValue: null,
      parse: parseActiveSession,
      isBackedUp: false,
    ),
  ];
}
