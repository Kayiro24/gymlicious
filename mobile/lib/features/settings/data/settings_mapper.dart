import 'package:gym_tracker/core/clock/iso_date_time.dart';
import 'package:gym_tracker/core/units/units.dart';
import 'package:gym_tracker/features/checkin/checkin_domain.dart';
import 'package:gym_tracker/features/settings/data/settings_dto.dart';
import 'package:gym_tracker/features/settings/domain/app_settings.dart';

abstract final class SettingsMapper {
  static AppSettings fromDto(SettingsDto dto) => AppSettings(
    weightUnit: WeightUnit.fromName(dto.weightUnit),
    heightUnit: HeightUnit.fromName(dto.heightUnit),
    weightIncrement: dto.weightIncrement,
    theme: ThemePreference.fromName(dto.theme),
    quoteMode: QuoteMode.fromName(dto.quoteMode),
    isBackupReminderOn: dto.backupReminder,
    isBackupNotificationOn: dto.backupNotification,
    lastBackupAt: IsoDateTime.tryParse(dto.lastBackupAt),
    backupBannerDismissedAt: IsoDateTime.tryParse(dto.backupBannerDismissedAt),
    activeSplitId: dto.activeSplitId,
    yearDots: YearDotsSettings(
      layout: YearDotsLayout.fromName(dto.yearDots.layout),
      colorPreset: YearDotsColorPreset.fromName(dto.yearDots.colorPreset),
      textLine: YearDotsTextLine.fromName(dto.yearDots.textLine),
      topMarginPercent: dto.yearDots.topMarginPercent.clamp(
        YearDotsSettings.minTopMarginPercent,
        YearDotsSettings.maxTopMarginPercent,
      ),
      padding: dto.yearDots.padding.clamp(
        YearDotsSettings.minPadding,
        YearDotsSettings.maxPadding,
      ),
    ),
    isCheckInReminderOn: dto.checkInReminder.isEnabled,
    checkInReminderMinutes: _minutes(dto.checkInReminder.time),
  );

  static int _minutes(String time) {
    try {
      return DayTime.parse(time).minutesSinceMidnight;
    } on FormatException {
      return AppSettings.defaultReminderMinutes;
    }
  }

  static String _time(int minutes) => DayTime(
    minutes ~/ Duration.minutesPerHour,
    minutes % Duration.minutesPerHour,
  ).toStorage();

  static SettingsDto toDto(AppSettings settings) {
    final lastBackupAt = settings.lastBackupAt;
    final dismissedAt = settings.backupBannerDismissedAt;
    return SettingsDto(
      weightUnit: settings.weightUnit.name,
      heightUnit: settings.heightUnit.name,
      weightIncrement: settings.weightIncrement,
      theme: settings.theme.name,
      quoteMode: settings.quoteMode.name,
      backupReminder: settings.isBackupReminderOn,
      backupNotification: settings.isBackupNotificationOn,
      lastBackupAt: lastBackupAt == null
          ? null
          : IsoDateTime.format(lastBackupAt),
      backupBannerDismissedAt: dismissedAt == null
          ? null
          : IsoDateTime.format(dismissedAt),
      activeSplitId: settings.activeSplitId,
      yearDots: YearDotsSettingsDto(
        layout: settings.yearDots.layout.name,
        colorPreset: settings.yearDots.colorPreset.name,
        textLine: settings.yearDots.textLine.storageName,
        topMarginPercent: settings.yearDots.topMarginPercent,
        padding: settings.yearDots.padding,
      ),
      checkInReminder: CheckInReminderDto(
        isEnabled: settings.isCheckInReminderOn,
        time: _time(settings.checkInReminderMinutes),
      ),
    );
  }
}
