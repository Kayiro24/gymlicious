import 'package:flutter/material.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';

/// Colour roles from `tokens.json`. `ember`, `gold` and `highlight` are fills
/// for graphics; text on them uses the matching `on…` role.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const new({
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
    required this.onAccent,
    required this.accentSoft,
    required this.ember,
    required this.onEmber,
    required this.gold,
    required this.onGold,
    required this.goldText,
    required this.highlight,
    required this.onHighlight,
    required this.highlightText,
    required this.danger,
    required this.onDanger,
    required this.hairline,
    required this.shadow,
    required this.heroGlow,
  });

  factory _fromList(List<Color> values) => AppColors(
    background: values[0],
    surface: values[1],
    surfaceMuted: values[2],
    textPrimary: values[3],
    textSecondary: values[4],
    accent: values[5],
    onAccent: values[6],
    accentSoft: values[7],
    ember: values[8],
    onEmber: values[9],
    gold: values[10],
    onGold: values[11],
    goldText: values[12],
    highlight: values[13],
    onHighlight: values[14],
    highlightText: values[15],
    danger: values[16],
    onDanger: values[17],
    hairline: values[18],
    shadow: values[19],
    heroGlow: values[20],
  );

  static const light = AppColors(
    background: LightTokenColors.background,
    surface: LightTokenColors.surface,
    surfaceMuted: LightTokenColors.surfaceMuted,
    textPrimary: LightTokenColors.textPrimary,
    textSecondary: LightTokenColors.textSecondary,
    accent: LightTokenColors.accent,
    onAccent: LightTokenColors.onAccent,
    accentSoft: LightTokenColors.accentSoft,
    ember: LightTokenColors.ember,
    onEmber: LightTokenColors.onEmber,
    gold: LightTokenColors.gold,
    onGold: LightTokenColors.onGold,
    goldText: LightTokenColors.goldText,
    highlight: LightTokenColors.highlight,
    onHighlight: LightTokenColors.onHighlight,
    highlightText: LightTokenColors.highlightText,
    danger: LightTokenColors.danger,
    onDanger: LightTokenColors.onDanger,
    hairline: LightTokenColors.hairline,
    shadow: LightTokenColors.shadow,
    heroGlow: LightTokenColors.heroGlow,
  );

  static const dark = AppColors(
    background: DarkTokenColors.background,
    surface: DarkTokenColors.surface,
    surfaceMuted: DarkTokenColors.surfaceMuted,
    textPrimary: DarkTokenColors.textPrimary,
    textSecondary: DarkTokenColors.textSecondary,
    accent: DarkTokenColors.accent,
    onAccent: DarkTokenColors.onAccent,
    accentSoft: DarkTokenColors.accentSoft,
    ember: DarkTokenColors.ember,
    onEmber: DarkTokenColors.onEmber,
    gold: DarkTokenColors.gold,
    onGold: DarkTokenColors.onGold,
    goldText: DarkTokenColors.goldText,
    highlight: DarkTokenColors.highlight,
    onHighlight: DarkTokenColors.onHighlight,
    highlightText: DarkTokenColors.highlightText,
    danger: DarkTokenColors.danger,
    onDanger: DarkTokenColors.onDanger,
    hairline: DarkTokenColors.hairline,
    shadow: DarkTokenColors.shadow,
    heroGlow: DarkTokenColors.heroGlow,
  );

  final Color background;
  final Color surface;
  final Color surfaceMuted;
  final Color textPrimary;
  final Color textSecondary;
  final Color accent;
  final Color onAccent;
  final Color accentSoft;
  final Color ember;
  final Color onEmber;
  final Color gold;
  final Color onGold;
  final Color goldText;
  final Color highlight;
  final Color onHighlight;
  final Color highlightText;
  final Color danger;
  final Color onDanger;
  final Color hairline;
  final Color shadow;
  final Color heroGlow;

  bool get isDark => background.computeLuminance() < 0.5;

  /// The warm wash behind hero cards and the welcome screen.
  LinearGradient get heroGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surface, heroGlow],
  );

  /// Ember into gold, for rings, the flame and XP bars.
  List<Color> get fireColors => [ember, gold];

  List<Color> get _all => [
    background,
    surface,
    surfaceMuted,
    textPrimary,
    textSecondary,
    accent,
    onAccent,
    accentSoft,
    ember,
    onEmber,
    gold,
    onGold,
    goldText,
    highlight,
    onHighlight,
    highlightText,
    danger,
    onDanger,
    hairline,
    shadow,
    heroGlow,
  ];

  @override
  AppColors copyWith({Color? accent}) {
    final values = _all;
    values[5] = accent ?? this.accent;
    return AppColors._fromList(values);
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) {
      return this;
    }
    final mine = _all;
    final theirs = other._all;
    return AppColors._fromList([
      for (var index = 0; index < mine.length; index++)
        Color.lerp(mine[index], theirs[index], t)!,
    ]);
  }
}

extension AppColorsContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;

  TextTheme get textStyles => Theme.of(this).textTheme;
}
