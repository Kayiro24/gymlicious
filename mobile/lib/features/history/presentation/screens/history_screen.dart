import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/layout/window_size_class.dart';
import 'package:gym_tracker/core/providers.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/core/units/number_format.dart';
import 'package:gym_tracker/core/units/units.dart';
import 'package:gym_tracker/design_system/app_card.dart';
import 'package:gym_tracker/design_system/app_section_header.dart';
import 'package:gym_tracker/design_system/app_segmented.dart';
import 'package:gym_tracker/features/history/presentation/history_routes.dart';
import 'package:gym_tracker/features/history/presentation/widgets/session_card.dart';
import 'package:gym_tracker/features/history/presentation/widgets/session_detail_view.dart';
import 'package:gym_tracker/features/history/presentation/widgets/training_calendar_view.dart';
import 'package:gym_tracker/features/workouts/workouts.dart';
import 'package:gym_tracker/shared/empty_state.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const new({super.key});

  static const listPaneWidth = 420.0;

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  bool _isCalendar = false;
  late CalendarDate _month = CalendarDate.fromDateTime(
    ref.read(clockProvider).now(),
  );
  CalendarDate? _selectedDate;
  String? _selectedSessionId;

  void _open(String id, {required bool isTwoPane}) {
    if (isTwoPane) {
      setState(() => _selectedSessionId = id);
    } else {
      unawaited(context.push(HistoryRoutes.detail(id)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sessions = ref.watch(workoutsControllerProvider).sessionsNewestFirst;
    final isTwoPane = WindowSizeClass.of(context).isExpanded;
    final list = sessions.isEmpty
        ? EmptyState(icon: LucideIcons.history, message: l10n.historyEmpty)
        : ListView(
            padding: const EdgeInsets.all(TokenSpace.lg),
            children: [
              _MonthStats(sessions: sessions),
              const SizedBox(height: TokenSpace.lg),
              AppSegmented<bool>(
                selected: _isCalendar,
                options: [
                  AppSegmentOption(false, l10n.historyList),
                  AppSegmentOption(true, l10n.historyCalendar),
                ],
                onChanged: (value) => setState(() => _isCalendar = value),
              ),
              const SizedBox(height: TokenSpace.lg),
              if (_isCalendar)
                ..._calendar(context, sessions, isTwoPane: isTwoPane)
              else
                ..._groupedList(context, sessions, isTwoPane: isTwoPane),
            ],
          );
    final selected = _selectedSessionId;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.historyTitle)),
      body: SafeArea(
        child: isTwoPane
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: HistoryScreen.listPaneWidth, child: list),
                  const VerticalDivider(width: 1),
                  Expanded(
                    child: selected == null
                        ? EmptyState(
                            icon: LucideIcons.history,
                            message: l10n.historySelectSession,
                          )
                        : SingleChildScrollView(
                            padding: const EdgeInsets.all(TokenSpace.xl),
                            child: SessionDetailView(
                              key: ValueKey(selected),
                              sessionId: selected,
                              onDeleted: () =>
                                  setState(() => _selectedSessionId = null),
                            ),
                          ),
                  ),
                ],
              )
            : list,
      ),
    );
  }

  List<Widget> _groupedList(
    BuildContext context,
    List<WorkoutSession> sessions, {
    required bool isTwoPane,
  }) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final widgets = <Widget>[];
    String? currentMonth;
    for (final session in sessions) {
      final month = DateFormat.yMMMM(locale).format(session.startedAt);
      if (month != currentMonth) {
        currentMonth = month;
        widgets.add(AppSectionHeader(month));
      }
      widgets
        ..add(
          SessionCard(
            session: session,
            isSelected: isTwoPane && session.id == _selectedSessionId,
            onTap: () => _open(session.id, isTwoPane: isTwoPane),
          ),
        )
        ..add(const SizedBox(height: TokenSpace.sm));
    }
    return widgets;
  }

  List<Widget> _calendar(
    BuildContext context,
    List<WorkoutSession> sessions, {
    required bool isTwoPane,
  }) {
    final l10n = AppLocalizations.of(context);
    final selectedDate = _selectedDate;
    final onDay = selectedDate == null
        ? const <WorkoutSession>[]
        : [
            for (final session in sessions)
              if (CalendarDate.fromDateTime(session.startedAt) == selectedDate)
                session,
          ];
    return [
      AppCard(
        child: TrainingCalendarView(
          month: _month,
          trainedDates: TrainingCalendar.trainedDates(sessions),
          selectedDate: selectedDate,
          onMonthChanged: (month) => setState(() => _month = month),
          onDateSelected: (date) => setState(() => _selectedDate = date),
        ),
      ),
      const SizedBox(height: TokenSpace.lg),
      if (selectedDate != null && onDay.isEmpty)
        Text(l10n.historyNoSessionsOnDay, style: context.textStyles.bodyMedium),
      for (final session in onDay) ...[
        SessionCard(
          session: session,
          isSelected: isTwoPane && session.id == _selectedSessionId,
          onTap: () => _open(session.id, isTwoPane: isTwoPane),
        ),
        const SizedBox(height: TokenSpace.sm),
      ],
    ];
  }
}

class _MonthStats extends ConsumerWidget {
  const new({required this.sessions});

  final List<WorkoutSession> sessions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final now = ref.watch(clockProvider).now();
    final format = WeightFormat.of(context, ref);
    final thisMonth = [
      for (final session in sessions)
        if (session.startedAt.year == now.year &&
            session.startedAt.month == now.month)
          session,
    ];
    final volumeKg = thisMonth.fold<double>(0, (sum, s) => sum + s.volumeKg);
    final volume = NumberText.trimmed(
      UnitConversion.toDisplayWeight(volumeKg, format.unit),
      step: 1,
    );
    return AppCard(
      color: context.colors.accentSoft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.historyThisMonth(thisMonth.length),
            style: context.textStyles.titleMedium,
          ),
          if (volumeKg > 0)
            Text(
              l10n.historyVolume(l10n.weightWithUnit(volume, format.unit.name)),
              style: context.textStyles.bodyMedium,
            ),
        ],
      ),
    );
  }
}
