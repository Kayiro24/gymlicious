import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/failure/failure.dart';
import 'package:gym_tracker/core/failure/result.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/core/units/weight_text.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/app_segmented.dart';
import 'package:gym_tracker/design_system/app_sheet.dart';
import 'package:gym_tracker/design_system/app_text_field.dart';
import 'package:gym_tracker/features/settings/settings.dart';
import 'package:gym_tracker/features/workouts/workouts.dart';
import 'package:gym_tracker/shared/unit_field.dart';

/// Creates a custom exercise, or edits [existing]. Resolves to the saved
/// exercise, or null when cancelled.
Future<Exercise?> showExerciseFormSheet(
  BuildContext context, {
  Exercise? existing,
}) {
  final l10n = AppLocalizations.of(context);
  return showAppSheet<Exercise>(
    context: context,
    title: existing == null ? l10n.exerciseFormTitle : l10n.exerciseEditTitle,
    builder: (_) => _ExerciseForm(existing: existing),
  );
}

class _ExerciseForm extends ConsumerStatefulWidget {
  const new({required this.existing});

  final Exercise? existing;

  @override
  ConsumerState<_ExerciseForm> createState() => _ExerciseFormState();
}

class _ExerciseFormState extends ConsumerState<_ExerciseForm> {
  late final _name = TextEditingController(text: widget.existing?.name ?? '');
  late final _startingMax = TextEditingController();
  late MuscleGroup _muscle = widget.existing?.muscleGroup ?? MuscleGroup.chest;
  late Equipment _equipment = widget.existing?.equipment ?? Equipment.barbell;
  String? _nameError;
  String? _maxError;

  @override
  void initState() {
    super.initState();
    final baseline = widget.existing?.baselineMaxKg;
    if (baseline != null) {
      final unit = ref.read(settingsControllerProvider).weightUnit;
      _startingMax.text = WeightText.value(baseline, unit);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _startingMax.dispose();
    super.dispose();
  }

  String _nameProblem(AppLocalizations l10n, String code) => switch (code) {
    'duplicate' => l10n.exerciseNameTaken,
    'tooLong' => l10n.exerciseNameTooLong,
    _ => l10n.exerciseNameEmpty,
  };

  void _save() {
    final l10n = AppLocalizations.of(context);
    final format = WeightFormat.of(context, ref);
    final maxText = _startingMax.text.trim();
    final startingMax = maxText.isEmpty ? null : format.parse(maxText);
    if (maxText.isNotEmpty && startingMax == null) {
      setState(() => _maxError = l10n.profileErrorInvalidNumber);
      return;
    }
    final controller = ref.read(workoutsControllerProvider.notifier);
    final existing = widget.existing;
    final result = existing == null
        ? controller.addExercise(
            name: _name.text,
            muscleGroup: _muscle,
            equipment: _equipment,
            baselineMaxKg: startingMax,
          )
        : controller.updateExercise(
            existing.copyWith(
              name: _name.text,
              muscleGroup: _muscle,
              equipment: _equipment,
              baselineMaxKg: startingMax,
            ),
          );
    switch (result) {
      case Ok(:final value):
        Navigator.of(context).pop(value);
      case Err(failure: ValidationFailure(:final fieldErrors)):
        setState(() {
          _maxError = null;
          _nameError = _nameProblem(l10n, fieldErrors[exerciseNameField] ?? '');
        });
      case Err():
        setState(() => _nameError = l10n.commonSomethingWentWrong);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final unit = WeightFormat.of(context, ref).unit;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          label: l10n.exerciseName,
          controller: _name,
          isRequired: true,
          autofocus: widget.existing == null,
          maxLength: ExerciseNameRules.maxLength,
          textCapitalization: TextCapitalization.words,
          errorText: _nameError,
        ),
        const SizedBox(height: TokenSpace.lg),
        Text(l10n.exerciseMuscle, style: context.textStyles.labelMedium),
        const SizedBox(height: TokenSpace.sm),
        AppSegmented<MuscleGroup>(
          semanticLabel: l10n.exerciseMuscle,
          selected: _muscle,
          options: [
            for (final group in MuscleGroup.values)
              AppSegmentOption(group, ExerciseLabels.muscle(l10n, group)),
          ],
          onChanged: (group) => setState(() => _muscle = group),
        ),
        const SizedBox(height: TokenSpace.lg),
        Text(l10n.exerciseEquipment, style: context.textStyles.labelMedium),
        const SizedBox(height: TokenSpace.sm),
        AppSegmented<Equipment>(
          semanticLabel: l10n.exerciseEquipment,
          selected: _equipment,
          options: [
            for (final equipment in Equipment.values)
              AppSegmentOption(
                equipment,
                ExerciseLabels.equipment(l10n, equipment),
              ),
          ],
          onChanged: (equipment) => setState(() => _equipment = equipment),
        ),
        const SizedBox(height: TokenSpace.lg),
        UnitField(
          label: l10n.exerciseStartingMax,
          unitLabel: unit.name,
          controller: _startingMax,
          isRequired: false,
          errorText: _maxError,
          textInputAction: TextInputAction.done,
          onChanged: (_) {},
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: TokenSpace.xs,
            left: TokenSpace.xs,
          ),
          child: Text(
            l10n.exerciseStartingMaxHint,
            style: context.textStyles.bodySmall,
          ),
        ),
        const SizedBox(height: TokenSpace.xl),
        AppButton(label: l10n.exerciseSave, isExpanded: true, onPressed: _save),
      ],
    );
  }
}
