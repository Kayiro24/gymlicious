import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_theme.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/flame_icon.dart';
import 'package:gym_tracker/design_system/number_choice_chips.dart';
import 'package:gym_tracker/design_system/progress_ring.dart';
import 'package:gym_tracker/design_system/step_indicator.dart';
import 'package:gym_tracker/shared/badge_tile.dart';
import 'package:gym_tracker/shared/celebration_overlay.dart';
import 'package:gym_tracker/shared/day_chip.dart';
import 'package:gym_tracker/shared/streak_card.dart';
import 'package:gym_tracker/shared/week_strip.dart';
import 'package:gym_tracker/shared/xp_bar.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

const _width = 360.0;
const _weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

DayChipData _day(int day, DayChipState state, {bool isToday = false}) =>
    (dayNumber: '$day', state: state, isToday: isToday, semanticLabel: '$day');

final List<DayChipData> _week = [
  _day(12, DayChipState.done),
  _day(13, DayChipState.done),
  _day(14, DayChipState.noWorkout, isToday: true),
  _day(15, DayChipState.planned),
  _day(16, DayChipState.upcoming),
  _day(17, DayChipState.upcoming),
  _day(18, DayChipState.rest),
];

Widget _frame(
  ThemeData theme,
  Widget child, {
  double textScale = 1,
  bool reduceMotion = false,
}) => Localizations(
  locale: const Locale('en'),
  delegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ],
  child: MediaQuery(
    data: MediaQueryData(
      textScaler: TextScaler.linear(textScale),
      disableAnimations: reduceMotion,
    ),
    child: Theme(
      data: theme,
      child: Material(
        color: theme.scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(TokenSpace.lg),
          child: SizedBox(width: _width, child: child),
        ),
      ),
    ),
  ),
);

Widget _components() => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const StreakCard(
      streakDays: 12,
      bestDays: 21,
      weeksOnTrack: 3,
      weekDone: 3,
      weekGoal: 4,
      statusText: '1 more to go this week',
      footer: XpBar(level: 4, xpIntoLevel: 280, xpForLevel: 400),
    ),
    const SizedBox(height: TokenSpace.lg),
    WeekStrip(days: _week, weekdayLabels: _weekdays),
    const SizedBox(height: TokenSpace.lg),
    const Row(
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
    const SizedBox(height: TokenSpace.lg),
    const StepIndicator(current: 2, total: 4),
    const SizedBox(height: TokenSpace.lg),
    NumberChoiceChips(
      values: const [1, 2, 3, 4, 5, 6],
      selected: 4,
      onChanged: (_) {},
    ),
    const SizedBox(height: TokenSpace.lg),
    AppButton(label: 'I worked out today', isExpanded: true, onPressed: () {}),
  ],
);

Widget _flames() => const Wrap(
  spacing: TokenSpace.lg,
  runSpacing: TokenSpace.lg,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    FlameIcon(streakDays: 0),
    FlameIcon(streakDays: 3),
    FlameIcon(streakDays: 10),
    FlameIcon(streakDays: 45),
    FlameIcon(streakDays: 120),
    ProgressRing(value: 0.5, semanticLabel: '2 of 4', child: Text('2/4')),
    ProgressRing(value: 1, semanticLabel: '4 of 4', child: Text('4/4')),
  ],
);

Widget _celebration() => const SizedBox(
  height: 360,
  child: CelebrationOverlay(
    title: '7-day streak!',
    message: 'A whole week of showing up.',
    leading: FlameIcon(streakDays: 7, size: TokenSpace.xxxl * 1.5),
  ),
);

Future<void> main() async {
  final themes = {'light': AppTheme.light(), 'dark': AppTheme.dark()};

  await goldenTest(
    'Warm components in light and dark, normal and 200% text',
    fileName: 'warm_components',
    builder: () => GoldenTestGroup(
      columns: 2,
      children: [
        for (final scale in [1.0, 2.0])
          for (final MapEntry(key: name, value: theme) in themes.entries)
            GoldenTestScenario(
              name: '$name ${scale}x',
              child: _frame(theme, _components(), textScale: scale),
            ),
      ],
    ),
  );

  await goldenTest(
    'Flame tiers and progress rings',
    fileName: 'warm_flames',
    builder: () => GoldenTestGroup(
      columns: 2,
      children: [
        for (final MapEntry(key: name, value: theme) in themes.entries)
          GoldenTestScenario(name: name, child: _frame(theme, _flames())),
      ],
    ),
  );

  await goldenTest(
    'Celebration card, animated and reduced motion',
    fileName: 'warm_celebration',
    builder: () => GoldenTestGroup(
      columns: 2,
      children: [
        GoldenTestScenario(
          name: 'light',
          child: _frame(themes['light']!, _celebration()),
        ),
        GoldenTestScenario(
          name: 'dark, reduced motion',
          child: _frame(themes['dark']!, _celebration(), reduceMotion: true),
        ),
      ],
    ),
  );
}
