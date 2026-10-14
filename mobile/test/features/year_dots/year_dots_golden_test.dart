import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/app_theme.dart';
import 'package:gym_tracker/features/settings/settings_domain.dart';
import 'package:gym_tracker/features/year_dots/domain/dot_layout.dart';
import 'package:gym_tracker/features/year_dots/domain/year_progress.dart';
import 'package:gym_tracker/features/year_dots/presentation/wallpaper_image_renderer.dart';
import 'package:gym_tracker/features/year_dots/presentation/widgets/year_dots_grid.dart';
import 'package:gym_tracker/features/year_dots/presentation/widgets/year_dots_palette.dart';
import 'package:gym_tracker/features/year_dots/presentation/year_dots_text.dart';
import 'package:intl/intl.dart';

final _progress = YearProgress(const CalendarDate(2026, 10, 14));

Widget _localized(ThemeData theme, Widget child) => Localizations(
  locale: const Locale('en'),
  delegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ],
  child: Theme(
    data: theme,
    child: ColoredBox(color: theme.scaffoldBackgroundColor, child: child),
  ),
);

class _WallpaperPainter extends CustomPainter {
  new(this.settings);

  final YearDotsSettings settings;

  @override
  void paint(Canvas canvas, Size size) {
    final l10n = lookupAppLocalizations(const Locale('en'));
    WallpaperImageRenderer.paint(
      canvas,
      size,
      settings: settings,
      progress: _progress,
      textLine: YearDotsText.line(l10n, _progress, settings.textLine),
      monthInitials: [
        for (var month = 1; month <= 12; month++)
          DateFormat('MMMMM', 'en').format(DateTime(2001, month)),
      ],
      pixelRatio: 1,
    );
  }

  @override
  bool shouldRepaint(_WallpaperPainter oldDelegate) => false;
}

Future<void> main() async {
  const sizes = {'phone': Size(360, 520), 'tablet': Size(900, 560)};
  final themes = {
    'light': (AppTheme.light(), AppColors.light),
    'dark': (AppTheme.dark(), AppColors.dark),
  };

  await goldenTest(
    'Year tab grid at phone and tablet sizes, both layouts and themes',
    fileName: 'year_dots_grid',
    builder: () => GoldenTestGroup(
      columns: 2,
      children: [
        for (final MapEntry(key: sizeName, value: size) in sizes.entries)
          for (final kind in DotLayoutKind.values)
            for (final MapEntry(key: themeName, value: (theme, colors))
                in themes.entries)
              GoldenTestScenario(
                name: '$sizeName ${kind.name} $themeName',
                child: SizedBox.fromSize(
                  size: size,
                  child: _localized(
                    theme,
                    YearDotsGrid(
                      progress: _progress,
                      kind: kind,
                      palette: YearDotsPalette.fromTheme(colors),
                      isInteractive: false,
                    ),
                  ),
                ),
              ),
      ],
    ),
  );

  await goldenTest(
    'Wallpaper in every colour preset and layout',
    fileName: 'year_dots_wallpaper',
    builder: () => GoldenTestGroup(
      columns: 4,
      children: [
        for (final layout in YearDotsLayout.values)
          for (final preset in YearDotsColorPreset.values)
            GoldenTestScenario(
              name: '${layout.name} ${preset.name}',
              child: CustomPaint(
                size: const Size(240, 520),
                painter: _WallpaperPainter(
                  YearDotsSettings(
                    layout: layout,
                    colorPreset: preset,
                    padding: 16,
                  ),
                ),
              ),
            ),
      ],
    ),
  );
}
