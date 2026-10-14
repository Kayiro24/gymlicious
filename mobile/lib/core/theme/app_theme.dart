import 'package:flutter/material.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';

abstract final class AppTheme {
  static const fontFamily = 'PlusJakartaSans';

  /// Headings and big numbers (D43).
  static const displayFontFamily = 'BricolageGrotesque';
  static const tabularFigures = [FontFeature.tabularFigures()];

  static ThemeData light() => _build(AppColors.light, Brightness.light);

  static ThemeData dark() => _build(AppColors.dark, Brightness.dark);

  static TextTheme textTheme(AppColors colors) {
    TextStyle style(double size, FontWeight weight, Color color) => TextStyle(
      fontFamily: fontFamily,
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: 1.35,
    );
    TextStyle display(double size, FontWeight weight) => TextStyle(
      fontFamily: displayFontFamily,
      fontSize: size,
      fontWeight: weight,
      color: colors.textPrimary,
      fontFeatures: tabularFigures,
      height: 1.1,
    );
    return TextTheme(
      displayLarge: display(TokenTypeScale.hero, FontWeight.w800),
      displaySmall: display(TokenTypeScale.display, FontWeight.w800),
      headlineSmall: display(TokenTypeScale.headline, FontWeight.w700),
      titleLarge: display(TokenTypeScale.title, FontWeight.w700),
      titleMedium: style(
        TokenTypeScale.body,
        FontWeight.w600,
        colors.textPrimary,
      ),
      bodyLarge: style(
        TokenTypeScale.body,
        FontWeight.w400,
        colors.textPrimary,
      ),
      bodyMedium: style(
        TokenTypeScale.label,
        FontWeight.w400,
        colors.textPrimary,
      ),
      bodySmall: style(
        TokenTypeScale.caption,
        FontWeight.w400,
        colors.textSecondary,
      ),
      labelLarge: style(
        TokenTypeScale.body,
        FontWeight.w600,
        colors.textPrimary,
      ),
      labelMedium: style(
        TokenTypeScale.label,
        FontWeight.w500,
        colors.textPrimary,
      ),
      labelSmall: style(
        TokenTypeScale.caption,
        FontWeight.w500,
        colors.textSecondary,
      ),
    );
  }

  static ThemeData _build(AppColors colors, Brightness brightness) {
    final text = textTheme(colors);
    final inputRadius = BorderRadius.circular(TokenRadius.input);
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: colors.accent,
      onPrimary: colors.onAccent,
      secondary: colors.accent,
      onSecondary: colors.onAccent,
      error: colors.danger,
      onError: colors.onDanger,
      surface: colors.surface,
      onSurface: colors.textPrimary,
      surfaceContainerHighest: colors.surfaceMuted,
      onSurfaceVariant: colors.textSecondary,
      outline: colors.hairline,
      shadow: colors.shadow,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      fontFamily: fontFamily,
      textTheme: text,
      scaffoldBackgroundColor: colors.background,
      canvasColor: colors.background,
      extensions: [colors],
      splashFactory: InkSparkle.splashFactory,
      dividerTheme: DividerThemeData(color: colors.hairline, thickness: 1),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceMuted,
        focusColor: colors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: TokenSpace.lg + TokenSpace.xs,
          vertical: TokenSpace.lg,
        ),
        border: OutlineInputBorder(
          borderRadius: inputRadius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: inputRadius,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: inputRadius,
          borderSide: BorderSide(color: colors.accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: inputRadius,
          borderSide: BorderSide(color: colors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: inputRadius,
          borderSide: BorderSide(color: colors.danger, width: 1.5),
        ),
        labelStyle: text.bodyMedium?.copyWith(color: colors.textSecondary),
        hintStyle: text.bodyMedium?.copyWith(color: colors.textSecondary),
        errorStyle: text.bodySmall?.copyWith(color: colors.danger),
        helperStyle: text.bodySmall,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.surface,
        indicatorColor: colors.accentSoft,
        elevation: 0,
        height: TokenLayout.minTouchTarget + TokenSpace.xxl,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? text.labelSmall?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w700,
                )
              : text.labelSmall,
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? colors.accent
                : colors.textSecondary,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colors.surface,
        indicatorColor: colors.accentSoft,
        selectedLabelTextStyle: text.labelSmall?.copyWith(
          color: colors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        selectedIconTheme: IconThemeData(color: colors.accent),
        unselectedIconTheme: IconThemeData(color: colors.textSecondary),
        unselectedLabelTextStyle: text.labelSmall,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.textPrimary,
        contentTextStyle: text.bodyMedium?.copyWith(color: colors.background),
        behavior: SnackBarBehavior.floating,
        shape: const StadiumBorder(),
        elevation: 0,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        showDragHandle: true,
        dragHandleColor: colors.hairline,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(TokenRadius.sheet),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TokenRadius.card),
        ),
        titleTextStyle: text.titleLarge,
        contentTextStyle: text.bodyLarge,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colors.onAccent
              : colors.textSecondary,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colors.accent
              : colors.surfaceMuted,
        ),
        trackOutlineColor: WidgetStatePropertyAll(colors.hairline),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TokenSpace.sm),
        ),
        side: BorderSide(color: colors.textSecondary, width: 1.5),
      ),
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
    );
  }
}
