import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_chip.dart';
import 'package:gym_tracker/design_system/app_list_tile.dart';
import 'package:gym_tracker/design_system/app_sheet.dart';
import 'package:gym_tracker/features/exercises/exercises.dart';
import 'package:gym_tracker/features/workouts/workouts.dart';
import 'package:gym_tracker/shared/search_field.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Searchable, filterable picker over active exercises, with an inline
/// "create" option. Resolves to the chosen exercise or null.
Future<Exercise?> showExercisePicker(
  BuildContext context, {
  Set<String> exclude = const {},
}) {
  final l10n = AppLocalizations.of(context);
  return showAppSheet<Exercise>(
    context: context,
    title: l10n.pickerTitle,
    builder: (_) => _Picker(exclude: exclude),
  );
}

class _Picker extends ConsumerStatefulWidget {
  const new({required this.exclude});

  final Set<String> exclude;

  @override
  ConsumerState<_Picker> createState() => _PickerState();
}

class _PickerState extends ConsumerState<_Picker> {
  static const _listHeightFactor = 0.5;

  final _search = TextEditingController();
  String _query = '';
  MuscleGroup? _muscle;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final created = await showExerciseFormSheet(context);
    if (created != null && mounted) {
      Navigator.of(context).pop(created);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = _query.trim().toLowerCase();
    final exercises = [
      for (final exercise
          in ref.watch(workoutsControllerProvider).activeExercises)
        if (!widget.exclude.contains(exercise.id) &&
            (_muscle == null || exercise.muscleGroup == _muscle) &&
            (query.isEmpty || exercise.name.toLowerCase().contains(query)))
          exercise,
    ]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SearchField(
          controller: _search,
          hintText: l10n.exercisesSearchHint,
          onChanged: (value) => setState(() => _query = value),
        ),
        const SizedBox(height: TokenSpace.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final group in MuscleGroup.values) ...[
                AppChip(
                  label: ExerciseLabels.muscle(l10n, group),
                  isSelected: _muscle == group,
                  onSelected: (isOn) =>
                      setState(() => _muscle = isOn ? group : null),
                ),
                const SizedBox(width: TokenSpace.xs),
              ],
            ],
          ),
        ),
        const SizedBox(height: TokenSpace.sm),
        AppListTile(
          leadingIcon: LucideIcons.plus,
          title: l10n.pickerNewExercise,
          onTap: _create,
        ),
        const Divider(),
        SizedBox(
          height: MediaQuery.sizeOf(context).height * _listHeightFactor,
          child: ListView.builder(
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final exercise = exercises[index];
              return AppListTile(
                title: exercise.name,
                subtitle: ExerciseLabels.muscle(l10n, exercise.muscleGroup),
                trailing: Icon(LucideIcons.plus, color: context.colors.accent),
                onTap: () => Navigator.of(context).pop(exercise),
              );
            },
          ),
        ),
      ],
    );
  }
}
