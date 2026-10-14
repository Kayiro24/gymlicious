import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/layout/content_width.dart';
import 'package:gym_tracker/core/providers.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/app_card.dart';
import 'package:gym_tracker/design_system/app_toast.dart';
import 'package:gym_tracker/features/workouts/workouts.dart';
import 'package:gym_tracker/shared/date_picker_field.dart';
import 'package:gym_tracker/shared/empty_state.dart';
import 'package:gym_tracker/shared/set_row.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Edits a past session's date, weights and reps (backdating allowed).
class SessionEditScreen extends ConsumerStatefulWidget {
  const new({required this.sessionId, super.key});

  final String sessionId;

  @override
  ConsumerState<SessionEditScreen> createState() => _SessionEditScreenState();
}

class _SessionEditScreenState extends ConsumerState<SessionEditScreen> {
  late WorkoutSession? _session = ref
      .read(workoutsControllerProvider)
      .sessionById(widget.sessionId);

  void _edit(WorkoutSession Function(WorkoutSession) change) =>
      setState(() => _session = change(_session!));

  /// Moves the session to [date], keeping its time of day and duration.
  void _setDate(CalendarDate date) => _edit((session) {
    final start = session.startedAt;
    final moved = DateTime(
      date.year,
      date.month,
      date.day,
      start.hour,
      start.minute,
    );
    final end = session.endedAt;
    return session.copyWith(
      startedAt: moved,
      endedAt: end == null ? null : moved.add(end.difference(start)),
    );
  });

  void _save() {
    ref.read(workoutsControllerProvider.notifier).saveSession(_session!);
    showAppToast(context, AppLocalizations.of(context).sessionDetailSaved);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final session = _session;
    if (session == null) {
      return Scaffold(
        appBar: AppBar(),
        body: EmptyState(
          icon: LucideIcons.searchX,
          message: l10n.sessionDetailMissing,
        ),
      );
    }
    final format = WeightFormat.of(context, ref);
    final today = CalendarDate.fromDateTime(ref.read(clockProvider).now());
    return Scaffold(
      appBar: AppBar(title: Text(l10n.sessionDetailEdit)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(TokenSpace.lg),
          children: [
            ContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DatePickerField(
                    label: l10n.sessionDetailDate,
                    value: CalendarDate.fromDateTime(session.startedAt),
                    firstDate: CalendarDate(today.year - 10, 1, 1),
                    lastDate: today,
                    onChanged: _setDate,
                  ),
                  const SizedBox(height: TokenSpace.lg),
                  for (final (entryIndex, entry)
                      in session.entries.indexed) ...[
                    AppCard(
                      padding: const EdgeInsets.all(TokenSpace.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            entry.exerciseName,
                            style: context.textStyles.titleMedium,
                          ),
                          const SizedBox(height: TokenSpace.sm),
                          for (final (setIndex, set) in entry.sets.indexed) ...[
                            SetRow(
                              key: ValueKey(
                                '$entryIndex-$setIndex-${entry.sets.length}',
                              ),
                              number: setIndex + 1,
                              weightText: format.input(set.weightKg),
                              repsText: set.reps?.toString() ?? '',
                              unitLabel: format.unit.name,
                              isWarmup: set.isWarmup,
                              isDone: set.isDone,
                              onWeightChanged: (text) {
                                final kilograms = format.parse(text);
                                if (kilograms != null) {
                                  _edit(
                                    (s) => s.replaceSet(
                                      entryIndex,
                                      setIndex,
                                      set.copyWith(weightKg: kilograms),
                                    ),
                                  );
                                }
                              },
                              onRepsChanged: (text) => _edit(
                                (s) => s.replaceSet(
                                  entryIndex,
                                  setIndex,
                                  set.copyWith(reps: int.tryParse(text)),
                                ),
                              ),
                              onIncrement: () => _edit(
                                (s) => s.replaceSet(
                                  entryIndex,
                                  setIndex,
                                  set.copyWith(
                                    weightKg: format.step(
                                      set.weightKg,
                                      isUp: true,
                                    ),
                                  ),
                                ),
                              ),
                              onDecrement: () => _edit(
                                (s) => s.replaceSet(
                                  entryIndex,
                                  setIndex,
                                  set.copyWith(
                                    weightKg: format.step(
                                      set.weightKg,
                                      isUp: false,
                                    ),
                                  ),
                                ),
                              ),
                              onWarmupToggled: () => _edit(
                                (s) => s.replaceSet(
                                  entryIndex,
                                  setIndex,
                                  set.copyWith(isWarmup: !set.isWarmup),
                                ),
                              ),
                              onDoneToggled: () => _edit(
                                (s) => s.replaceSet(
                                  entryIndex,
                                  setIndex,
                                  set.copyWith(isDone: !set.isDone),
                                ),
                              ),
                              onRemove: () => _edit(
                                (s) => s.removeSet(entryIndex, setIndex),
                              ),
                            ),
                            const SizedBox(height: TokenSpace.sm),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: TokenSpace.md),
                  ],
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
            label: l10n.sessionEditSave,
            isExpanded: true,
            onPressed: _save,
          ),
        ),
      ),
    );
  }
}
