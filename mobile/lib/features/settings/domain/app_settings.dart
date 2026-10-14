import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gym_tracker/core/units/units.dart';

part 'app_settings.freezed.dart';

enum ThemePreference {
  system,
  light,
  dark;

  static ThemePreference fromName(String? name) =>
      values.asNameMap()[name] ?? ThemePreference.system;
}

enum QuoteMode {
  gym,
  anime,
  mix,
  off;

  /// Older files used "both" for what is now Mix.
  static QuoteMode fromName(String? name) => name == 'both'
      ? QuoteMode.mix
      : values.asNameMap()[name] ?? QuoteMode.mix;
}

enum YearDotsLayout {
  continuous,
  months;

  static YearDotsLayout fromName(String? name) =>
      values.asNameMap()[name] ?? YearDotsLayout.continuous;
}

enum YearDotsColorPreset {
  light,
  dark,
  black,
  ember;

  /// Sage was replaced by Ember in the warm redesign (D53).
  static YearDotsColorPreset fromName(String? name) => name == 'sage'
      ? YearDotsColorPreset.ember
      : values.asNameMap()[name] ?? YearDotsColorPreset.light;
}

enum YearDotsTextLine {
  leftAndPercent('left_and_percent'),
  leftOnly('left_only'),
  none('none');

  new(this.storageName);

  final String storageName;

  static YearDotsTextLine fromName(String? name) => values.firstWhere(
    (value) => value.storageName == name,
    orElse: () => YearDotsTextLine.leftAndPercent,
  );
}

@freezed
abstract class YearDotsSettings with _$YearDotsSettings {
  const factory({
    @Default(YearDotsLayout.continuous) YearDotsLayout layout,
    @Default(YearDotsColorPreset.light) YearDotsColorPreset colorPreset,
    @Default(YearDotsTextLine.leftAndPercent) YearDotsTextLine textLine,
    @Default(22) int topMarginPercent,
    @Default(24) int padding,
  }) = _YearDotsSettings;

  static const minTopMarginPercent = 0;
  static const maxTopMarginPercent = 40;
  static const minPadding = 8;
  static const maxPadding = 64;
}

@freezed
abstract class AppSettings with _$AppSettings {
  const factory({
    @Default(WeightUnit.kg) WeightUnit weightUnit,
    @Default(HeightUnit.cm) HeightUnit heightUnit,
    @Default(2.5) double weightIncrement,
    @Default(ThemePreference.system) ThemePreference theme,
    @Default(QuoteMode.mix) QuoteMode quoteMode,
    @Default(true) bool isBackupReminderOn,
    @Default(false) bool isBackupNotificationOn,
    DateTime? lastBackupAt,
    DateTime? backupBannerDismissedAt,
    String? activeSplitId,
    @Default(YearDotsSettings()) YearDotsSettings yearDots,
    @Default(false) bool isCheckInReminderOn,
    @Default(AppSettings.defaultReminderMinutes) int checkInReminderMinutes,
  }) = _AppSettings;

  const new _();

  /// 19:00, as minutes after midnight.
  static const int defaultReminderMinutes = 19 * 60;

  /// Switching units resets the increment to that unit's sensible default.
  AppSettings withWeightUnit(WeightUnit unit) => unit == weightUnit
      ? this
      : copyWith(weightUnit: unit, weightIncrement: unit.defaultIncrement);
}
