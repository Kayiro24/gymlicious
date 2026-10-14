import 'dart:ui';

import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/features/settings/settings_domain.dart';

class YearDotsPalette {
  const new({
    required this.background,
    required this.done,
    required this.today,
    required this.left,
    required this.text,
  });

  /// The in-app Year tab follows the current theme (spec 5.10 A3).
  factory fromTheme(AppColors colors) => YearDotsPalette(
    background: colors.background,
    done: colors.textPrimary,
    today: colors.accent,
    left: colors.surfaceMuted,
    text: colors.textSecondary,
  );

  /// Wallpaper presets, shared with the Kotlin renderer via design tokens.
  factory fromPreset(YearDotsColorPreset preset) {
    final tokens = switch (preset) {
      YearDotsColorPreset.light => TokenYearDotsPresets.light,
      YearDotsColorPreset.dark => TokenYearDotsPresets.dark,
      YearDotsColorPreset.black => TokenYearDotsPresets.black,
      YearDotsColorPreset.ember => TokenYearDotsPresets.ember,
    };
    return YearDotsPalette(
      background: tokens.background,
      done: tokens.done,
      today: tokens.today,
      left: tokens.left,
      text: tokens.text,
    );
  }

  final Color background;
  final Color done;
  final Color today;
  final Color left;
  final Color text;
}
