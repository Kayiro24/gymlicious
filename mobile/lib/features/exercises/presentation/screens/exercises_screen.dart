import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/layout/window_size_class.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_chip.dart';
import 'package:gym_tracker/features/exercises/presentation/exercises_routes.dart';
import 'package:gym_tracker/features/exercises/presentation/widgets/exercise_detail_view.dart';
import 'package:gym_tracker/features/exercises/presentation/widgets/exercise_form_sheet.dart';
import 'package:gym_tracker/features/workouts/workouts.dart';
import 'package:gym_tracker/shared/empty_state.dart';
import 'package:gym_tracker/shared/exercise_tile.dart';
import 'package:gym_tracker/shared/filter_sheet.dart';
import 'package:gym_tracker/shared/search_field.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Library with search and muscle filter; list + detail side by side on
/// expanded widths (spec 8.2 point 3).
class ExercisesScreen extends ConsumerStatefulWidget {
  const new({super.key});

  static const listPaneWidth = 400.0;

  @override
  ConsumerState<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends ConsumerState<ExercisesScreen> {
  final _search = TextEditingController();
  String _query = '';
  MuscleGroup? _muscle;
  bool _showArchived = false;
  String? _selectedId;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Exercise> _visible(List<Exercise> all) {
    final query = _query.trim().toLowerCase();
    return [
      for (final exercise in all)
        if (exercise.isArchived == _showArchived &&
            (_muscle == null || exercise.muscleGroup == _muscle) &&
            (query.isEmpty || exercise.name.toLowerCase().contains(query)))
          exercise,
    ]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  Future<void> _pickMuscle() async {
    final l10n = AppLocalizations.of(context);
    final chosen = await showFilterSheet<MuscleGroup>(
      context: context,
      selected: _muscle,
      options: [
        for (final group in MuscleGroup.values)
          (value: group, label: ExerciseLabels.muscle(l10n, group)),
      ],
    );
    if (mounted) {
      setState(() => _muscle = chosen);
    }
  }

  void _open(String id, {required bool isTwoPane}) {
    if (isTwoPane) {
      setState(() => _selectedId = id);
    } else {
      unawaited(context.push(ExercisesRoutes.detail(id)));
    }
  }

  Future<void> _add({required bool isTwoPane}) async {
    final created = await showExerciseFormSheet(context);
    if (created != null && mounted) {
      _open(created.id, isTwoPane: isTwoPane);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final exercises = _visible(ref.watch(workoutsControllerProvider).exercises);
    final stats = ref.watch(exerciseStatsProvider);
    final format = WeightFormat.of(context, ref);
    final isTwoPane = WindowSizeClass.of(context).isExpanded;
    final list = CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(TokenSpace.lg),
          sliver: SliverList.list(
            children: [
              SearchField(
                controller: _search,
                hintText: l10n.exercisesSearchHint,
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: TokenSpace.md),
              Wrap(
                spacing: TokenSpace.sm,
                runSpacing: TokenSpace.sm,
                children: [
                  AppChip(
                    label: _muscle == null
                        ? l10n.exercisesFilter
                        : ExerciseLabels.muscle(l10n, _muscle!),
                    isSelected: _muscle != null,
                    onSelected: (_) => _pickMuscle(),
                  ),
                  AppChip(
                    label: l10n.exercisesShowArchived,
                    isSelected: _showArchived,
                    onSelected: (value) =>
                        setState(() => _showArchived = value),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (exercises.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyState(
              icon: LucideIcons.searchX,
              message: l10n.exercisesEmpty,
              actionLabel: l10n.exercisesAdd,
              onAction: () => _add(isTwoPane: isTwoPane),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              TokenSpace.lg,
              0,
              TokenSpace.lg,
              TokenSpace.xxxl * 2,
            ),
            sliver: SliverList.separated(
              itemCount: exercises.length,
              separatorBuilder: (_, _) => const SizedBox(height: TokenSpace.sm),
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                final exerciseStats = stats[exercise.id] ?? ExerciseStats.empty;
                return ExerciseTile(
                  name: exercise.name,
                  subtitle:
                      '${ExerciseLabels.muscle(l10n, exercise.muscleGroup)} · '
                      '${ExerciseLabels.equipment(l10n, exercise.equipment)}',
                  lastText: format.withUnit(
                    exerciseStats.lastKg,
                    isBodyweight: exercise.isBodyweight,
                  ),
                  maxText: format.withUnit(
                    exerciseStats.maxKg,
                    isBodyweight: exercise.isBodyweight,
                  ),
                  isSelected: isTwoPane && exercise.id == _selectedId,
                  onTap: () => _open(exercise.id, isTwoPane: isTwoPane),
                );
              },
            ),
          ),
      ],
    );
    final selected = _selectedId;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.exercisesTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _add(isTwoPane: isTwoPane),
        icon: const Icon(LucideIcons.plus),
        label: Text(l10n.exercisesAdd),
      ),
      body: SafeArea(
        child: isTwoPane
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: ExercisesScreen.listPaneWidth, child: list),
                  const VerticalDivider(width: 1),
                  Expanded(
                    child: selected == null
                        ? EmptyState(
                            icon: LucideIcons.dumbbell,
                            message: l10n.exercisesNoneSelected,
                          )
                        : SingleChildScrollView(
                            padding: const EdgeInsets.all(TokenSpace.xl),
                            child: ExerciseDetailView(
                              key: ValueKey(selected),
                              exerciseId: selected,
                              onRemoved: () =>
                                  setState(() => _selectedId = null),
                            ),
                          ),
                  ),
                ],
              )
            : list,
      ),
    );
  }
}
