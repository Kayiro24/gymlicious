import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:gym_tracker/core/storage/json_cast.dart';
import 'package:gym_tracker/features/workouts/data/dto/exercise_dto.dart';
import 'package:gym_tracker/features/workouts/data/dto/split_dto.dart';
import 'package:gym_tracker/features/workouts/data/mappers/workout_mapper.dart';
import 'package:gym_tracker/features/workouts/domain/entities/seed_catalog.dart';

class SeedCatalogLoader {
  const new(this.bundle);

  static const exercisesAsset = 'assets/seed/exercises.json';
  static const splitsAsset = 'assets/seed/splits.json';

  final AssetBundle bundle;

  Future<SeedCatalog> load() async {
    final exercisesJson = jsonDecode(await bundle.loadString(exercisesAsset));
    final splitsJson = jsonDecode(await bundle.loadString(splitsAsset));
    return SeedCatalog(
      exercises: [
        for (final json in JsonCast.objectList(exercisesJson, exercisesAsset))
          WorkoutMapper.exerciseFromDto(ExerciseDto.fromJson(json)),
      ],
      presets: [
        for (final json in JsonCast.objectList(splitsJson, splitsAsset))
          WorkoutMapper.splitFromDto(SplitDto.fromJson(json)),
      ],
    );
  }
}
