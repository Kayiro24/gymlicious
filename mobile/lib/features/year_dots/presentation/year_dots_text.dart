import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/features/settings/settings_domain.dart';
import 'package:gym_tracker/features/year_dots/domain/year_progress.dart';

abstract final class YearDotsText {
  static String summary(AppLocalizations l10n, YearProgress progress) =>
      l10n.yearSummaryLine(
        progress.dayOfYear,
        progress.daysInYear,
        progress.daysLeft,
        progress.percentDone,
      );

  static String? line(
    AppLocalizations l10n,
    YearProgress progress,
    YearDotsTextLine textLine,
  ) => switch (textLine) {
    YearDotsTextLine.leftAndPercent => summary(l10n, progress),
    YearDotsTextLine.leftOnly => l10n.yearLeftOnlyLine(progress.daysLeft),
    YearDotsTextLine.none => null,
  };

  static const _daySentinel = 900001;
  static const _totalSentinel = 900002;
  static const _leftSentinel = 900003;
  static const _percentSentinel = 900004;

  /// Localised templates with `{day}`, `{total}`, `{left}`, `{percent}`
  /// tokens, so the native wallpaper can fill in numbers each day.
  static ({String summary, String leftOnly}) nativeTemplates(
    AppLocalizations l10n,
  ) {
    String tokenise(String text) => text
        .replaceAll('$_daySentinel', '{day}')
        .replaceAll('$_totalSentinel', '{total}')
        .replaceAll('$_leftSentinel', '{left}')
        .replaceAll('$_percentSentinel', '{percent}');
    return (
      summary: tokenise(
        l10n.yearSummaryLine(
          _daySentinel,
          _totalSentinel,
          _leftSentinel,
          _percentSentinel,
        ),
      ),
      leftOnly: tokenise(l10n.yearLeftOnlyLine(_leftSentinel)),
    );
  }
}
