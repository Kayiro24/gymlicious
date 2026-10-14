import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/features/workouts/data/dto/session_dto.dart';
import 'package:gym_tracker/features/workouts/data/mappers/workout_mapper.dart';
import 'package:gym_tracker/features/workouts/domain/entities/exercise.dart';
import 'package:gym_tracker/features/workouts/domain/entities/exercise_enums.dart';
import 'package:gym_tracker/features/workouts/domain/entities/workout_session.dart';
import 'package:gym_tracker/features/workouts/domain/entities/workout_set.dart';
import 'package:gym_tracker/features/workouts/domain/rules/exercise_stats_calculator.dart';
import 'package:gym_tracker/features/workouts/domain/rules/progress_series.dart';

/// Plan risk R8: two years of five-a-week training must stay small and fast,
/// since every save rewrites the whole file.
void main() {
  final exercises = [
    for (var i = 0; i < 60; i++)
      Exercise(
        id: 'ex_$i',
        name: 'Exercise $i',
        muscleGroup: MuscleGroup.values[i % MuscleGroup.values.length],
        equipment: Equipment.barbell,
      ),
  ];
  final start = DateTime(2024, 10, 14, 18);
  final sessions = [
    for (var day = 0; day < 730; day++)
      if (day % 7 < 5)
        WorkoutSession(
          id: 'session_$day',
          startedAt: start.add(Duration(days: day)),
          endedAt: start.add(Duration(days: day, hours: 1)),
          dayName: 'Day ${day % 5}',
          entries: [
            for (var slot = 0; slot < 6; slot++)
              SessionEntry(
                exerciseId: 'ex_${(day * 6 + slot) % 60}',
                exerciseName: 'Exercise ${(day * 6 + slot) % 60}',
                sets: [
                  for (var set = 0; set < 4; set++)
                    WorkoutSet(
                      weightKg: 40 + (day % 50) + set * 2.5,
                      reps: 8,
                      isDone: true,
                      isWarmup: set == 0,
                    ),
                ],
              ),
          ],
        ),
  ];

  test('the stored sessions stay under 3 MB and round-trip', () {
    final encoded = jsonEncode([
      for (final session in sessions)
        WorkoutMapper.sessionToDto(session).toJson(),
    ]);
    expect(utf8.encode(encoded).length, lessThan(3 * 1024 * 1024));
    final decoded = [
      for (final json
          in (jsonDecode(encoded) as List).cast<Map<String, dynamic>>())
        WorkoutMapper.sessionFromDto(SessionDto.fromJson(json)),
    ];
    expect(decoded, sessions);
  });

  test('stats for every exercise and a progress chart stay fast', () {
    final watch = Stopwatch()..start();
    final stats = ExerciseStatsCalculator.computeAll(exercises, sessions);
    final series = ProgressSeries.forExercise('ex_0', sessions);
    watch.stop();
    expect(stats, hasLength(60));
    expect(series, isNotEmpty);
    expect(watch.elapsedMilliseconds, lessThan(500));
  });
}
