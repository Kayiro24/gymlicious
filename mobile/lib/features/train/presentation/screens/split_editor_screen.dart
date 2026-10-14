import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/layout/content_width.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/app_card.dart';
import 'package:gym_tracker/design_system/app_chip.dart';
import 'package:gym_tracker/design_system/app_section_header.dart';
import 'package:gym_tracker/design_system/app_text_field.dart';
import 'package:gym_tracker/features/settings/settings.dart';
import 'package:gym_tracker/features/train/presentation/widgets/exercise_picker_sheet.dart';
import 'package:gym_tracker/features/workouts/workouts.dart';
import 'package:gym_tracker/shared/confirm_dialog.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Create or edit a split: name, ordered days, ordered exercises per day.
class SplitEditorScreen extends ConsumerStatefulWidget {
  const new({required this.splitId, super.key});

  /// Null for a new split.
  final String? splitId;

  @override
  ConsumerState<SplitEditorScreen> createState() => _SplitEditorScreenState();
}

class _SplitEditorScreenState extends ConsumerState<SplitEditorScreen> {
  late final _name = TextEditingController();
  late List<SplitDay> _days;
  String? _nameError;

  bool get _isNew => widget.splitId == null;

  @override
  void initState() {
    super.initState();
    final existing = ref
        .read(workoutsControllerProvider)
        .splitById(widget.splitId);
    _name.text = existing?.name ?? '';
    _days = existing?.days ?? [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_days.isEmpty && _isNew) {
      _days = [_newDay(AppLocalizations.of(context).splitDefaultDay(1))];
    }
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  SplitDay _newDay(String name) => SplitDay(
    id: ref.read(workoutsControllerProvider.notifier).newDayId(),
    name: name,
  );

  void _updateDay(int index, SplitDay Function(SplitDay) change) => setState(
    () => _days = [
      for (final (i, day) in _days.indexed)
        if (i == index) change(day) else day,
    ],
  );

  Future<void> _addExercise(int dayIndex) async {
    final exercise = await showExercisePicker(
      context,
      exclude: _days[dayIndex].exerciseIds.toSet(),
    );
    if (exercise != null) {
      _updateDay(
        dayIndex,
        (day) => day.copyWith(exerciseIds: [...day.exerciseIds, exercise.id]),
      );
    }
  }

  void _save() {
    final l10n = AppLocalizations.of(context);
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = l10n.splitNameRequired);
      return;
    }
    final controller = ref.read(workoutsControllerProvider.notifier);
    final days = [
      for (final (index, day) in _days.indexed)
        if (day.name.trim().isEmpty)
          day.copyWith(name: l10n.splitDefaultDay(index + 1))
        else
          day,
    ];
    if (_isNew) {
      final split = controller.addSplit(name: name, days: days);
      final settings = ref.read(settingsControllerProvider);
      if (settings.activeSplitId == null) {
        _makeActive(split.id);
      }
    } else {
      controller.saveSplit(
        WorkoutSplit(
          id: widget.splitId!,
          name: name,
          isPreset:
              ref
                  .read(workoutsControllerProvider)
                  .splitById(widget.splitId)
                  ?.isPreset ??
              false,
          days: days,
        ),
      );
    }
    context.pop();
  }

  void _makeActive(String splitId) => ref
      .read(settingsControllerProvider.notifier)
      .update((settings) => settings.copyWith(activeSplitId: splitId));

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final isConfirmed = await showConfirmDialog(
      context,
      title: l10n.splitDeleteQuestion,
      message: l10n.splitDeleteExplain,
      confirmLabel: l10n.splitDelete,
      isDestructive: true,
    );
    if (!isConfirmed || !mounted) {
      return;
    }
    ref.read(workoutsControllerProvider.notifier).deleteSplit(widget.splitId!);
    if (ref.read(settingsControllerProvider).activeSplitId == widget.splitId) {
      ref
          .read(settingsControllerProvider.notifier)
          .update((settings) => settings.copyWith(activeSplitId: null));
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final data = ref.watch(workoutsControllerProvider);
    final activeId = ref.watch(
      settingsControllerProvider.select((s) => s.activeSplitId),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? l10n.splitEditorNewTitle : l10n.splitEditorTitle),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(TokenSpace.lg),
          children: [
            ContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                    label: l10n.splitName,
                    controller: _name,
                    isRequired: true,
                    hintText: l10n.splitDefaultName,
                    errorText: _nameError,
                    textCapitalization: TextCapitalization.words,
                  ),
                  if (!_isNew) ...[
                    const SizedBox(height: TokenSpace.md),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: AppChip(
                        label: activeId == widget.splitId
                            ? l10n.splitIsActive
                            : l10n.splitMakeActive,
                        isSelected: activeId == widget.splitId,
                        onSelected: (_) => _makeActive(widget.splitId!),
                      ),
                    ),
                  ],
                  AppSectionHeader(l10n.splitDays),
                  Text(
                    l10n.splitReorderHint,
                    style: context.textStyles.bodySmall,
                  ),
                  const SizedBox(height: TokenSpace.sm),
                  ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    buildDefaultDragHandles: false,
                    itemCount: _days.length,
                    onReorderItem: (from, to) => setState(() {
                      final moved = _days.removeAt(from);
                      _days.insert(to, moved);
                      _days = [..._days];
                    }),
                    itemBuilder: (context, index) => Padding(
                      key: ValueKey(_days[index].id),
                      padding: const EdgeInsets.only(bottom: TokenSpace.md),
                      child: _DayEditor(
                        index: index,
                        day: _days[index],
                        exerciseNames: {
                          for (final id in _days[index].exerciseIds)
                            id: data.exerciseById(id)?.name ?? id,
                        },
                        canRemove: _days.length > 1,
                        onChanged: (change) => _updateDay(index, change),
                        onAddExercise: () => _addExercise(index),
                        onRemove: () =>
                            setState(() => _days = [..._days]..removeAt(index)),
                      ),
                    ),
                  ),
                  AppButton(
                    label: l10n.splitAddDay,
                    icon: LucideIcons.plus,
                    variant: AppButtonVariant.secondary,
                    onPressed: () => setState(
                      () => _days = [
                        ..._days,
                        _newDay(l10n.splitDefaultDay(_days.length + 1)),
                      ],
                    ),
                  ),
                  if (!_isNew) ...[
                    const SizedBox(height: TokenSpace.xl),
                    AppButton(
                      label: l10n.splitDelete,
                      icon: LucideIcons.trash2,
                      variant: AppButtonVariant.quiet,
                      onPressed: () => unawaited(_delete()),
                    ),
                  ],
                  const SizedBox(height: TokenSpace.xxxl),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TokenSpace.md),
          child: AppButton(
            label: l10n.splitSave,
            isExpanded: true,
            onPressed: _save,
          ),
        ),
      ),
    );
  }
}

class _DayEditor extends StatefulWidget {
  const new({
    required this.index,
    required this.day,
    required this.exerciseNames,
    required this.canRemove,
    required this.onChanged,
    required this.onAddExercise,
    required this.onRemove,
  });

  final int index;
  final SplitDay day;
  final Map<String, String> exerciseNames;
  final bool canRemove;
  final ValueChanged<SplitDay Function(SplitDay)> onChanged;
  final VoidCallback onAddExercise;
  final VoidCallback onRemove;

  @override
  State<_DayEditor> createState() => _DayEditorState();
}

class _DayEditorState extends State<_DayEditor> {
  late final _name = TextEditingController(text: widget.day.name);

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final day = widget.day;
    return AppCard(
      padding: const EdgeInsets.all(TokenSpace.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ReorderableDragStartListener(
                index: widget.index,
                child: Padding(
                  padding: const EdgeInsets.all(TokenSpace.sm),
                  child: Icon(
                    LucideIcons.gripVertical,
                    color: context.colors.textSecondary,
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _name,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(labelText: l10n.splitDayName),
                  onChanged: (value) => widget.onChanged(
                    (current) => current.copyWith(name: value),
                  ),
                ),
              ),
              if (widget.canRemove)
                IconButton(
                  tooltip: l10n.splitRemoveDay,
                  icon: const Icon(LucideIcons.x),
                  onPressed: widget.onRemove,
                ),
            ],
          ),
          const SizedBox(height: TokenSpace.sm),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: AppChip(
              label: l10n.splitRestDay,
              isSelected: day.isRest,
              onSelected: (isRest) => widget.onChanged(
                (current) => current.copyWith(isRest: isRest),
              ),
            ),
          ),
          if (!day.isRest) ...[
            const SizedBox(height: TokenSpace.sm),
            ReorderableListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              buildDefaultDragHandles: false,
              onReorderItem: (from, to) => widget.onChanged((current) {
                final ids = [...current.exerciseIds];
                final moved = ids.removeAt(from);
                ids.insert(to, moved);
                return current.copyWith(exerciseIds: ids);
              }),
              children: [
                for (final (index, id) in day.exerciseIds.indexed)
                  ListTile(
                    key: ValueKey('$id-$index'),
                    contentPadding: EdgeInsets.zero,
                    leading: ReorderableDragStartListener(
                      index: index,
                      child: const Icon(LucideIcons.gripVertical),
                    ),
                    title: Text(widget.exerciseNames[id] ?? id),
                    trailing: IconButton(
                      tooltip: l10n.splitRemoveExercise(
                        widget.exerciseNames[id] ?? id,
                      ),
                      icon: const Icon(LucideIcons.x),
                      onPressed: () => widget.onChanged(
                        (current) => current.copyWith(
                          exerciseIds: [...current.exerciseIds]
                            ..removeAt(index),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: AppButton(
                label: l10n.splitAddExercise,
                icon: LucideIcons.plus,
                variant: AppButtonVariant.quiet,
                onPressed: widget.onAddExercise,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
