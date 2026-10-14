import 'package:freezed_annotation/freezed_annotation.dart';

part 'split.freezed.dart';

@freezed
abstract class SplitDay with _$SplitDay {
  const factory({
    required String id,
    required String name,
    @Default(false) bool isRest,
    @Default(<String>[]) List<String> exerciseIds,
  }) = _SplitDay;
}

/// A training rotation; [days] are in rotation order.
@freezed
abstract class WorkoutSplit with _$WorkoutSplit {
  const factory({
    required String id,
    required String name,
    @Default(false) bool isPreset,
    @Default(<SplitDay>[]) List<SplitDay> days,
  }) = _WorkoutSplit;

  const new _();

  List<SplitDay> get trainingDays =>
      days.where((day) => !day.isRest).toList(growable: false);

  SplitDay? dayById(String id) {
    for (final day in days) {
      if (day.id == id) {
        return day;
      }
    }
    return null;
  }
}
