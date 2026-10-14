import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/features/workouts/domain/entities/exercise_enums.dart';

abstract final class ExerciseLabels {
  static String muscle(AppLocalizations l10n, MuscleGroup group) =>
      switch (group) {
        MuscleGroup.chest => l10n.muscleChest,
        MuscleGroup.back => l10n.muscleBack,
        MuscleGroup.shoulders => l10n.muscleShoulders,
        MuscleGroup.biceps => l10n.muscleBiceps,
        MuscleGroup.triceps => l10n.muscleTriceps,
        MuscleGroup.forearms => l10n.muscleForearms,
        MuscleGroup.quads => l10n.muscleQuads,
        MuscleGroup.hamstrings => l10n.muscleHamstrings,
        MuscleGroup.glutes => l10n.muscleGlutes,
        MuscleGroup.calves => l10n.muscleCalves,
        MuscleGroup.core => l10n.muscleCore,
        MuscleGroup.fullBody => l10n.muscleFullBody,
        MuscleGroup.cardio => l10n.muscleCardio,
      };

  static String equipment(AppLocalizations l10n, Equipment equipment) =>
      switch (equipment) {
        Equipment.barbell => l10n.equipmentBarbell,
        Equipment.dumbbell => l10n.equipmentDumbbell,
        Equipment.machine => l10n.equipmentMachine,
        Equipment.cable => l10n.equipmentCable,
        Equipment.bodyweight => l10n.equipmentBodyweight,
        Equipment.kettlebell => l10n.equipmentKettlebell,
        Equipment.band => l10n.equipmentBand,
        Equipment.other => l10n.equipmentOther,
      };
}
