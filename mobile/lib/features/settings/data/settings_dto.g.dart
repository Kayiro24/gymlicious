// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YearDotsSettingsDto _$YearDotsSettingsDtoFromJson(Map<String, dynamic> json) =>
    YearDotsSettingsDto(
      layout: json['layout'] as String? ?? 'continuous',
      colorPreset: json['colorPreset'] as String? ?? 'light',
      textLine: json['textLine'] as String? ?? 'left_and_percent',
      topMarginPercent: (json['topMarginPercent'] as num?)?.toInt() ?? 22,
      padding: (json['padding'] as num?)?.toInt() ?? 24,
    );

Map<String, dynamic> _$YearDotsSettingsDtoToJson(
  YearDotsSettingsDto instance,
) => <String, dynamic>{
  'layout': instance.layout,
  'colorPreset': instance.colorPreset,
  'textLine': instance.textLine,
  'topMarginPercent': instance.topMarginPercent,
  'padding': instance.padding,
};

CheckInReminderDto _$CheckInReminderDtoFromJson(Map<String, dynamic> json) =>
    CheckInReminderDto(
      isEnabled: json['isEnabled'] as bool? ?? false,
      time: json['time'] as String? ?? CheckInReminderDto.defaultTime,
    );

Map<String, dynamic> _$CheckInReminderDtoToJson(CheckInReminderDto instance) =>
    <String, dynamic>{'isEnabled': instance.isEnabled, 'time': instance.time};

SettingsDto _$SettingsDtoFromJson(Map<String, dynamic> json) => SettingsDto(
  weightUnit: json['weightUnit'] as String? ?? 'kg',
  heightUnit: json['heightUnit'] as String? ?? 'cm',
  weightIncrement: (json['weightIncrement'] as num?)?.toDouble() ?? 2.5,
  theme: json['theme'] as String? ?? 'system',
  quoteMode: json['quoteMode'] as String? ?? 'mix',
  backupReminder: json['backupReminder'] as bool? ?? true,
  backupNotification: json['backupNotification'] as bool? ?? false,
  lastBackupAt: json['lastBackupAt'] as String?,
  backupBannerDismissedAt: json['backupBannerDismissedAt'] as String?,
  activeSplitId: json['activeSplitId'] as String?,
  yearDots: json['yearDots'] == null
      ? const YearDotsSettingsDto()
      : YearDotsSettingsDto.fromJson(json['yearDots'] as Map<String, dynamic>),
  checkInReminder: json['checkInReminder'] == null
      ? const CheckInReminderDto()
      : CheckInReminderDto.fromJson(
          json['checkInReminder'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$SettingsDtoToJson(SettingsDto instance) =>
    <String, dynamic>{
      'weightUnit': instance.weightUnit,
      'heightUnit': instance.heightUnit,
      'weightIncrement': instance.weightIncrement,
      'theme': instance.theme,
      'quoteMode': instance.quoteMode,
      'backupReminder': instance.backupReminder,
      'backupNotification': instance.backupNotification,
      'lastBackupAt': instance.lastBackupAt,
      'backupBannerDismissedAt': instance.backupBannerDismissedAt,
      'activeSplitId': instance.activeSplitId,
      'yearDots': instance.yearDots.toJson(),
      'checkInReminder': instance.checkInReminder.toJson(),
    };
