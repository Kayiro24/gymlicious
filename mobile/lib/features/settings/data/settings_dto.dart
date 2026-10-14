import 'package:json_annotation/json_annotation.dart';

part 'settings_dto.g.dart';

@JsonSerializable(includeIfNull: true)
class YearDotsSettingsDto {
  const new({
    this.layout = 'continuous',
    this.colorPreset = 'light',
    this.textLine = 'left_and_percent',
    this.topMarginPercent = 22,
    this.padding = 24,
  });

  factory fromJson(Map<String, dynamic> json) =>
      _$YearDotsSettingsDtoFromJson(json);

  final String layout;
  final String colorPreset;
  final String textLine;
  final int topMarginPercent;
  final int padding;

  Map<String, dynamic> toJson() => _$YearDotsSettingsDtoToJson(this);
}

@JsonSerializable(includeIfNull: true)
class CheckInReminderDto {
  const new({
    this.isEnabled = false,
    this.time = CheckInReminderDto.defaultTime,
  });

  factory fromJson(Map<String, dynamic> json) =>
      _$CheckInReminderDtoFromJson(json);

  static const defaultTime = '19:00';

  final bool isEnabled;

  /// Local "HH:mm".
  final String time;

  Map<String, dynamic> toJson() => _$CheckInReminderDtoToJson(this);
}

@JsonSerializable(includeIfNull: true, explicitToJson: true)
class SettingsDto {
  const new({
    this.weightUnit = 'kg',
    this.heightUnit = 'cm',
    this.weightIncrement = 2.5,
    this.theme = 'system',
    this.quoteMode = 'mix',
    this.backupReminder = true,
    this.backupNotification = false,
    this.lastBackupAt,
    this.backupBannerDismissedAt,
    this.activeSplitId,
    this.yearDots = const YearDotsSettingsDto(),
    this.checkInReminder = const CheckInReminderDto(),
  });

  factory fromJson(Map<String, dynamic> json) => _$SettingsDtoFromJson(json);

  final String weightUnit;
  final String heightUnit;
  final double weightIncrement;
  final String theme;
  final String quoteMode;
  final bool backupReminder;
  final bool backupNotification;
  final String? lastBackupAt;
  final String? backupBannerDismissedAt;
  final String? activeSplitId;
  final YearDotsSettingsDto yearDots;
  final CheckInReminderDto checkInReminder;

  Map<String, dynamic> toJson() => _$SettingsDtoToJson(this);
}
