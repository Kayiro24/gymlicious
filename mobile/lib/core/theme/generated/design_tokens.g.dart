// GENERATED FILE. Edit design-tokens/tokens.json and run `dart design-tokens/tool/generate_theme.dart` from the repo root.
// ignore_for_file: public_member_api_docs

import 'dart:ui';

abstract final class LightTokenColors {
  static const background = Color(0xFFFFF7EE);
  static const surface = Color(0xFFFFFCF8);
  static const surfaceMuted = Color(0xFFF7EADB);
  static const textPrimary = Color(0xFF2A1B14);
  static const textSecondary = Color(0xFF6B5446);
  static const accent = Color(0xFFC2410C);
  static const onAccent = Color(0xFFFFFFFF);
  static const accentSoft = Color(0xFFFFE9DC);
  static const ember = Color(0xFFF26B2D);
  static const onEmber = Color(0xFF2A1B14);
  static const gold = Color(0xFFF5A524);
  static const onGold = Color(0xFF2A1B14);
  static const goldText = Color(0xFF8A5300);
  static const highlight = Color(0xFFF47C7C);
  static const onHighlight = Color(0xFF2A1B14);
  static const highlightText = Color(0xFFB0353F);
  static const danger = Color(0xFFA8322A);
  static const onDanger = Color(0xFFFFFFFF);
  static const hairline = Color(0xFFF0E2D2);
  static const shadow = Color(0xFF5A2E12);
  static const heroGlow = Color(0xFFFFE3CC);

  static const byName = <String, Color>{
    'background': background,
    'surface': surface,
    'surfaceMuted': surfaceMuted,
    'textPrimary': textPrimary,
    'textSecondary': textSecondary,
    'accent': accent,
    'onAccent': onAccent,
    'accentSoft': accentSoft,
    'ember': ember,
    'onEmber': onEmber,
    'gold': gold,
    'onGold': onGold,
    'goldText': goldText,
    'highlight': highlight,
    'onHighlight': onHighlight,
    'highlightText': highlightText,
    'danger': danger,
    'onDanger': onDanger,
    'hairline': hairline,
    'shadow': shadow,
    'heroGlow': heroGlow,
  };
}

abstract final class DarkTokenColors {
  static const background = Color(0xFF0F0F0F);
  static const surface = Color(0xFF212121);
  static const surfaceMuted = Color(0xFF272727);
  static const textPrimary = Color(0xFFF1F1F1);
  static const textSecondary = Color(0xFFAAAAAA);
  static const accent = Color(0xFFFF8A4C);
  static const onAccent = Color(0xFF0F0F0F);
  static const accentSoft = Color(0xFF3B2B22);
  static const ember = Color(0xFFFF7A3D);
  static const onEmber = Color(0xFF0F0F0F);
  static const gold = Color(0xFFFFC14D);
  static const onGold = Color(0xFF0F0F0F);
  static const goldText = Color(0xFFFFC14D);
  static const highlight = Color(0xFFFF8F8F);
  static const onHighlight = Color(0xFF0F0F0F);
  static const highlightText = Color(0xFFFF9E9E);
  static const danger = Color(0xFFFF9B8A);
  static const onDanger = Color(0xFF0F0F0F);
  static const hairline = Color(0xFF3F3F3F);
  static const shadow = Color(0xFF000000);
  static const heroGlow = Color(0xFF2A201B);

  static const byName = <String, Color>{
    'background': background,
    'surface': surface,
    'surfaceMuted': surfaceMuted,
    'textPrimary': textPrimary,
    'textSecondary': textSecondary,
    'accent': accent,
    'onAccent': onAccent,
    'accentSoft': accentSoft,
    'ember': ember,
    'onEmber': onEmber,
    'gold': gold,
    'onGold': onGold,
    'goldText': goldText,
    'highlight': highlight,
    'onHighlight': onHighlight,
    'highlightText': highlightText,
    'danger': danger,
    'onDanger': onDanger,
    'hairline': hairline,
    'shadow': shadow,
    'heroGlow': heroGlow,
  };
}

abstract final class TokenSpace {
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 48.0;
}

abstract final class TokenRadius {
  static const double input = 18.0;
  static const double card = 24.0;
  static const double hero = 28.0;
  static const double sheet = 28.0;
  static const double pill = 999.0;
}

abstract final class TokenTypeScale {
  static const double hero = 56.0;
  static const double display = 32.0;
  static const double headline = 24.0;
  static const double title = 20.0;
  static const double body = 16.0;
  static const double label = 14.0;
  static const double caption = 13.0;
}

abstract final class TokenLayout {
  static const double compactMaxWidth = 600.0;
  static const double mediumMaxWidth = 840.0;
  static const double contentMaxWidth = 600.0;
  static const double minTouchTarget = 48.0;
  static const double primaryButtonHeight = 56.0;
  static const double heroTextScaleCap = 1.5;
}

abstract final class TokenElevation {
  static const double shadowBlur = 32.0;
  static const double shadowOpacity = 0.08;
  static const double shadowOffsetY = 12.0;
  static const double glowBlur = 24.0;
}

abstract final class TokenFlame {
  static const int tier1Days = 1;
  static const int tier2Days = 7;
  static const int tier3Days = 30;
  static const int tier4Days = 100;
  static const double baseSize = 40.0;
  static const double growthPerTier = 0.12;
  static const double pulseScale = 1.18;
}

abstract final class TokenMotion {
  static const fast = Duration(milliseconds: 200);
  static const normal = Duration(milliseconds: 250);
  static const slow = Duration(milliseconds: 300);
  static const pulse = Duration(milliseconds: 600);
  static const celebration = Duration(milliseconds: 1200);
}

abstract final class TokenYearDots {
  static const double gapRatio = 0.3;
  static const double aspect = 0.8;
  static const double cornerRatio = 0.25;
  static const int minColumns = 10;
  static const int maxColumns = 31;
  static const double todayOutlineRatio = 0.18;
}

class YearDotsPresetTokens {
  const YearDotsPresetTokens({
    required this.background,
    required this.done,
    required this.today,
    required this.left,
    required this.text,
  });

  final Color background;
  final Color done;
  final Color today;
  final Color left;
  final Color text;
}

abstract final class TokenYearDotsPresets {
  static const light = YearDotsPresetTokens(
    background: Color(0xFFFFF7EE),
    done: Color(0xFF2A1B14),
    today: Color(0xFFC2410C),
    left: Color(0xFFF0E2D2),
    text: Color(0xFF6B5446),
  );
  static const dark = YearDotsPresetTokens(
    background: Color(0xFF0F0F0F),
    done: Color(0xFFF1F1F1),
    today: Color(0xFFFF8A4C),
    left: Color(0xFF3F3F3F),
    text: Color(0xFFAAAAAA),
  );
  static const black = YearDotsPresetTokens(
    background: Color(0xFF000000),
    done: Color(0xFFF2E6DA),
    today: Color(0xFFFF8A4C),
    left: Color(0xFF2A211C),
    text: Color(0xFFB8A698),
  );
  static const ember = YearDotsPresetTokens(
    background: Color(0xFFF26B2D),
    done: Color(0xFF2A1B14),
    today: Color(0xFFFFF7EE),
    left: Color(0xFFF59A6B),
    text: Color(0xFF2A1B14),
  );
}

const tokenContrastPairs = <(String, String)>[
  ('textPrimary', 'background'),
  ('textPrimary', 'surface'),
  ('textPrimary', 'surfaceMuted'),
  ('textPrimary', 'accentSoft'),
  ('textPrimary', 'heroGlow'),
  ('textSecondary', 'background'),
  ('textSecondary', 'surface'),
  ('textSecondary', 'surfaceMuted'),
  ('textSecondary', 'heroGlow'),
  ('accent', 'background'),
  ('accent', 'surface'),
  ('onAccent', 'accent'),
  ('onEmber', 'ember'),
  ('onGold', 'gold'),
  ('goldText', 'background'),
  ('goldText', 'surface'),
  ('onHighlight', 'highlight'),
  ('highlightText', 'background'),
  ('highlightText', 'surface'),
  ('danger', 'background'),
  ('danger', 'surface'),
  ('onDanger', 'danger'),
];
