import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_theme.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_avatar.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/app_card.dart';
import 'package:gym_tracker/design_system/app_chip.dart';
import 'package:gym_tracker/design_system/app_icon_button.dart';
import 'package:gym_tracker/design_system/app_list_tile.dart';
import 'package:gym_tracker/design_system/app_loading_ring.dart';
import 'package:gym_tracker/design_system/app_section_header.dart';
import 'package:gym_tracker/design_system/app_segmented.dart';
import 'package:gym_tracker/design_system/app_skeleton.dart';
import 'package:gym_tracker/design_system/app_text_field.dart';
import 'package:gym_tracker/design_system/flame_icon.dart';
import 'package:gym_tracker/design_system/hero_card.dart';
import 'package:gym_tracker/design_system/number_choice_chips.dart';
import 'package:gym_tracker/design_system/progress_ring.dart';
import 'package:gym_tracker/design_system/step_indicator.dart';
import 'package:gym_tracker/shared/badge_tile.dart';
import 'package:gym_tracker/shared/celebration_overlay.dart';
import 'package:gym_tracker/shared/day_chip.dart';
import 'package:gym_tracker/shared/empty_state.dart';
import 'package:gym_tracker/shared/error_state.dart';
import 'package:gym_tracker/shared/exercise_tile.dart';
import 'package:gym_tracker/shared/month_calendar.dart';
import 'package:gym_tracker/shared/quote_card.dart';
import 'package:gym_tracker/shared/set_row.dart';
import 'package:gym_tracker/shared/split_day_chip.dart';
import 'package:gym_tracker/shared/stat_pill.dart';
import 'package:gym_tracker/shared/stat_tile.dart';
import 'package:gym_tracker/shared/streak_card.dart';
import 'package:gym_tracker/shared/week_strip.dart';
import 'package:gym_tracker/shared/xp_bar.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Design-system catalogue, kept out of the app build:
/// `flutter run -t catalogue/main.dart`. Sample text here is fixture data.
void main() => runApp(const CatalogueApp());

void _noop() {}

typedef _Entry = ({String name, WidgetBuilder builder});

const _weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

DayChipData _day(int day, DayChipState state, {bool isToday = false}) => (
  dayNumber: '$day',
  state: state,
  isToday: isToday,
  semanticLabel: '$day ${state.name}',
);

final List<DayChipData> _sampleWeek = [
  _day(12, DayChipState.done),
  _day(13, DayChipState.done),
  _day(14, DayChipState.noWorkout, isToday: true),
  _day(15, DayChipState.planned),
  _day(16, DayChipState.upcoming),
  _day(17, DayChipState.upcoming),
  _day(18, DayChipState.rest),
];

DayChipData _monthDay(CalendarDate date) {
  final state = switch (date.day) {
    < 14 when date.weekday == DateTime.sunday => DayChipState.rest,
    < 14 => date.day.isEven ? DayChipState.done : DayChipState.noWorkout,
    14 => DayChipState.done,
    16 || 20 => DayChipState.planned,
    _ => DayChipState.upcoming,
  };
  return _day(date.day, state, isToday: date.day == 14);
}

class _GoalPicker extends StatefulWidget {
  const new();

  @override
  State<_GoalPicker> createState() => _GoalPickerState();
}

class _GoalPickerState extends State<_GoalPicker> {
  int _goal = 4;

  @override
  Widget build(BuildContext context) => NumberChoiceChips(
    values: const [1, 2, 3, 4, 5, 6],
    selected: _goal,
    onChanged: (value) => setState(() => _goal = value),
  );
}

class _FlameStepper extends StatefulWidget {
  const new();

  @override
  State<_FlameStepper> createState() => _FlameStepperState();
}

class _FlameStepperState extends State<_FlameStepper> {
  int _days = 6;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      FlameIcon(streakDays: _days),
      const SizedBox(width: TokenSpace.lg),
      Expanded(
        child: AppButton(
          label: 'Streak $_days → ${_days + 1}',
          variant: AppButtonVariant.secondary,
          onPressed: () => setState(() => _days++),
        ),
      ),
    ],
  );
}

final List<_Entry> _entries = [
  (
    name: 'StreakCard',
    builder: (_) => const Column(
      children: [
        StreakCard(
          streakDays: 12,
          bestDays: 21,
          weeksOnTrack: 3,
          weekDone: 2,
          weekGoal: 4,
          statusText: '2 more to go this week',
          footer: XpBar(level: 4, xpIntoLevel: 280, xpForLevel: 400),
        ),
        SizedBox(height: TokenSpace.lg),
        StreakCard(
          streakDays: 0,
          bestDays: 7,
          weeksOnTrack: 0,
          weekDone: 0,
          weekGoal: 4,
          statusText: 'Fresh start today',
        ),
      ],
    ),
  ),
  (
    name: 'FlameIcon tiers',
    builder: (_) => const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: TokenSpace.lg,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            FlameIcon(streakDays: 0),
            FlameIcon(streakDays: 3),
            FlameIcon(streakDays: 10),
            FlameIcon(streakDays: 45),
            FlameIcon(streakDays: 120),
          ],
        ),
        SizedBox(height: TokenSpace.xl),
        _FlameStepper(),
      ],
    ),
  ),
  (
    name: 'ProgressRing',
    builder: (_) => const Wrap(
      spacing: TokenSpace.lg,
      runSpacing: TokenSpace.lg,
      children: [
        ProgressRing(
          value: 0,
          semanticLabel: '0 of 4 days',
          child: Text('0/4'),
        ),
        ProgressRing(
          value: 0.75,
          semanticLabel: '3 of 4 days',
          child: Text('3/4'),
        ),
        ProgressRing(
          value: 1,
          semanticLabel: '4 of 4 days',
          child: Text('4/4'),
        ),
      ],
    ),
  ),
  (
    name: 'DayChip and WeekStrip',
    builder: (_) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: TokenSpace.sm,
          children: [
            for (final state in DayChipState.values)
              DayChip(data: _day(14, state)),
            DayChip(data: _day(14, DayChipState.done, isToday: true)),
          ],
        ),
        const SizedBox(height: TokenSpace.xl),
        WeekStrip(
          days: _sampleWeek,
          weekdayLabels: _weekdays,
          onDayTap: (_) {},
        ),
      ],
    ),
  ),
  (
    name: 'MonthCalendar',
    builder: (_) => MonthCalendar(
      year: 2026,
      month: 10,
      weekdayLabels: _weekdays,
      dayData: _monthDay,
      onDayTap: (_) {},
    ),
  ),
  (
    name: 'XpBar',
    builder: (_) => const Column(
      children: [
        XpBar(level: 1, xpIntoLevel: 20, xpForLevel: 100),
        SizedBox(height: TokenSpace.lg),
        XpBar(level: 7, xpIntoLevel: 590, xpForLevel: 700),
      ],
    ),
  ),
  (
    name: 'BadgeTile',
    builder: (_) => const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: BadgeTile(
            icon: LucideIcons.flame,
            title: '7-day streak',
            detail: 'Earned 14 Oct',
            isEarned: true,
          ),
        ),
        SizedBox(width: TokenSpace.md),
        Expanded(
          child: BadgeTile(
            icon: LucideIcons.dumbbell,
            title: '10 workouts',
            detail: '7 of 10 workouts',
            isEarned: false,
            progress: 0.7,
          ),
        ),
      ],
    ),
  ),
  (
    name: 'StatTile and HeroCard',
    builder: (_) => const Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatTile(value: '86%', label: 'Consistency'),
            ),
            SizedBox(width: TokenSpace.md),
            Expanded(
              child: StatTile(value: '42', label: 'Total workouts'),
            ),
          ],
        ),
        SizedBox(height: TokenSpace.lg),
        HeroCard(
          child: Text('A hero card holds the one thing that matters most.'),
        ),
      ],
    ),
  ),
  (
    name: 'StepIndicator and NumberChoiceChips',
    builder: (_) => const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StepIndicator(current: 2, total: 4),
        SizedBox(height: TokenSpace.xl),
        _GoalPicker(),
      ],
    ),
  ),
  (
    name: 'CelebrationOverlay',
    builder: (context) => AppButton(
      label: 'Celebrate',
      icon: LucideIcons.sparkles,
      onPressed: () => CelebrationOverlay.show(
        context,
        title: '7-day streak!',
        message: 'A whole week of showing up.',
        leading: const FlameIcon(streakDays: 7, size: TokenSpace.xxxl * 1.5),
      ),
    ),
  ),
  (
    name: 'AppButton',
    builder: (_) => Wrap(
      spacing: TokenSpace.sm,
      runSpacing: TokenSpace.sm,
      children: [
        for (final variant in AppButtonVariant.values)
          AppButton(label: variant.name, variant: variant, onPressed: _noop),
        const AppButton(label: 'Disabled', onPressed: null),
        const AppButton(label: 'Saving', isLoading: true, onPressed: _noop),
        const AppButton(
          label: 'With icon',
          icon: LucideIcons.plus,
          onPressed: _noop,
        ),
      ],
    ),
  ),
  (
    name: 'AppIconButton',
    builder: (_) => const Row(
      children: [
        AppIconButton(
          icon: LucideIcons.pencil,
          tooltip: 'Edit',
          onPressed: _noop,
        ),
        AppIconButton(
          icon: LucideIcons.plus,
          tooltip: 'Add',
          isFilled: true,
          onPressed: _noop,
        ),
      ],
    ),
  ),
  (
    name: 'AppCard',
    builder: (_) => const AppCard(
      onTap: _noop,
      child: Text('A card holds one idea, with soft corners and no border.'),
    ),
  ),
  (
    name: 'AppChip and AppSegmented',
    builder: (_) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Wrap(
          spacing: TokenSpace.sm,
          children: [
            AppChip(label: 'Chest', isSelected: true, onSelected: _ignore),
            AppChip(label: 'Back', isSelected: false, onSelected: _ignore),
          ],
        ),
        const SizedBox(height: TokenSpace.lg),
        AppSegmented<int>(
          options: const [AppSegmentOption(0, 'kg'), AppSegmentOption(1, 'lb')],
          selected: 0,
          onChanged: (_) {},
        ),
      ],
    ),
  ),
  (
    name: 'AppTextField',
    builder: (_) => const Column(
      children: [
        AppTextField(label: 'Name', isRequired: true, hintText: 'Your name'),
        SizedBox(height: TokenSpace.lg),
        AppTextField(
          label: 'Weight',
          suffixText: 'kg',
          isNumeric: true,
          errorText: 'Enter a weight between 20 and 400 kg.',
        ),
      ],
    ),
  ),
  (
    name: 'AppListTile and AppSectionHeader',
    builder: (_) => const Column(
      children: [
        AppSectionHeader('Data'),
        AppListTile(
          title: 'Backup & restore',
          subtitle: 'Last backup 3 days ago',
          leadingIcon: LucideIcons.archive,
          onTap: _noop,
        ),
        AppListTile(
          title: 'Reset all data',
          leadingIcon: LucideIcons.trash2,
          isDestructive: true,
          onTap: _noop,
        ),
      ],
    ),
  ),
  (
    name: 'AppAvatar, AppLoadingRing, AppSkeleton',
    builder: (_) => const Row(
      children: [
        AppAvatar(name: 'Sam Lee'),
        SizedBox(width: TokenSpace.lg),
        AppLoadingRing(semanticLabel: 'Loading'),
        SizedBox(width: TokenSpace.lg),
        Expanded(child: AppSkeleton(height: TokenSpace.xl)),
      ],
    ),
  ),
  (
    name: 'StatPill',
    builder: (_) => const Wrap(
      spacing: TokenSpace.sm,
      children: [
        StatPill(label: 'Last', value: '60 kg'),
        StatPill(label: 'Max', value: '72.5 kg', isHighlighted: true),
      ],
    ),
  ),
  (
    name: 'QuoteCard',
    builder: (_) => const Column(
      children: [
        QuoteCard(text: 'Small steps, every week.', onRefresh: _noop),
        SizedBox(height: TokenSpace.lg),
        QuoteCard(
          text: "If you don't take risks, you can't create a future.",
          attribution: 'Monkey D. Luffy, One Piece',
          onRefresh: _noop,
        ),
        SizedBox(height: TokenSpace.lg),
        QuoteCard(text: '', isLoading: true, onRefresh: _noop),
      ],
    ),
  ),
  (
    name: 'ExerciseTile',
    builder: (_) => const Column(
      children: [
        ExerciseTile(
          name: 'Bench Press',
          subtitle: 'Chest · Barbell',
          lastText: 'Last 60 kg',
          maxText: 'Max 72.5 kg',
          onTap: _noop,
        ),
        ExerciseTile(
          name: 'Pull-Up',
          subtitle: 'Back · Bodyweight',
          lastText: 'Last BW',
          maxText: 'Max BW + 10 kg',
          isSelected: true,
        ),
      ],
    ),
  ),
  (
    name: 'SplitDayChip',
    builder: (_) => const Wrap(
      spacing: TokenSpace.sm,
      runSpacing: TokenSpace.sm,
      children: [
        SplitDayChip(name: 'Push', detail: '5 exercises', isUpNext: true),
        SplitDayChip(name: 'Pull', detail: '4 exercises'),
        SplitDayChip(name: 'Rest', detail: 'Recover', isRest: true),
      ],
    ),
  ),
  (
    name: 'SetRow',
    builder: (_) => Column(
      children: [
        for (final (index, isDone) in [false, true].indexed)
          SetRow(
            number: index + 1,
            weightText: '60',
            repsText: '8',
            unitLabel: 'kg',
            isWarmup: index == 0,
            isDone: isDone,
            isNewMax: isDone,
            onWeightChanged: (_) {},
            onRepsChanged: (_) {},
            onIncrement: _noop,
            onDecrement: _noop,
            onWarmupToggled: _noop,
            onDoneToggled: _noop,
            onRemove: _noop,
          ),
      ],
    ),
  ),
  (
    name: 'EmptyState and ErrorState',
    builder: (_) => const Column(
      children: [
        EmptyState(
          icon: LucideIcons.dumbbell,
          message: 'No workouts yet. Your first one will show up here.',
          actionLabel: 'Start a workout',
          onAction: _noop,
        ),
        ErrorState(message: "We couldn't load this.", onRetry: _noop),
      ],
    ),
  ),
];

void _ignore(bool _) {}

enum _Frame {
  phone('Phone', 390),
  tablet('Tablet', 1024),
  fill('Fill', double.infinity);

  new(this.label, this.width);

  final String label;
  final double width;
}

class CatalogueApp extends StatefulWidget {
  const new({super.key});

  @override
  State<CatalogueApp> createState() => _CatalogueAppState();
}

class _CatalogueAppState extends State<CatalogueApp> {
  bool _isDark = false;
  _Frame _frame = _Frame.phone;
  bool _largeText = false;
  int _selected = 0;

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light(),
    darkTheme: AppTheme.dark(),
    themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Builder(builder: _buildHome),
  );

  Widget _buildHome(BuildContext context) {
    final entry = _entries[_selected];
    final preview = MediaQuery.withClampedTextScaling(
      minScaleFactor: _largeText ? 2 : 1,
      maxScaleFactor: _largeText ? 2 : 1,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: _frame.width),
          child: ListView(
            padding: const EdgeInsets.all(TokenSpace.lg),
            children: [Builder(builder: entry.builder)],
          ),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(entry.name),
        actions: [
          PopupMenuButton<_Frame>(
            tooltip: 'Frame width',
            icon: const Icon(LucideIcons.smartphone),
            initialValue: _frame,
            onSelected: (frame) => setState(() => _frame = frame),
            itemBuilder: (_) => [
              for (final frame in _Frame.values)
                PopupMenuItem(value: frame, child: Text(frame.label)),
            ],
          ),
          IconButton(
            tooltip: 'Text size 200%',
            icon: const Icon(LucideIcons.aLargeSmall),
            isSelected: _largeText,
            onPressed: () => setState(() => _largeText = !_largeText),
          ),
          IconButton(
            tooltip: 'Dark theme',
            icon: Icon(_isDark ? LucideIcons.sun : LucideIcons.moon),
            onPressed: () => setState(() => _isDark = !_isDark),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            for (final (index, item) in _entries.indexed)
              ListTile(
                title: Text(item.name),
                selected: index == _selected,
                onTap: () {
                  setState(() => _selected = index);
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
      ),
      body: preview,
    );
  }
}
