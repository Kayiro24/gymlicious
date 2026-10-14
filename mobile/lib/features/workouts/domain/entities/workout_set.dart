import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_set.freezed.dart';

@freezed
abstract class WorkoutSet with _$WorkoutSet {
  const factory({
    required double weightKg,
    int? reps,
    @Default(false) bool isWarmup,
    @Default(false) bool isDone,
  }) = _WorkoutSet;

  const new _();

  /// Completed working sets are the only ones that count for max and last.
  bool get countsForStats => isDone && !isWarmup;
}
