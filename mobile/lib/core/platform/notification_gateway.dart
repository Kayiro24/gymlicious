import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

/// Optional local reminders (weekly backup, daily check-in); nothing leaves
/// the device.
abstract interface class NotificationGateway {
  /// Returns false when notification permission is refused.
  Future<bool> enableWeeklyReminder({
    required String title,
    required String body,
    required String channelName,
  });

  Future<void> disableWeeklyReminder();

  /// Replaces all scheduled check-in reminders with one per time in [times].
  /// Returns false when notification permission is refused.
  Future<bool> scheduleCheckInReminders({
    required List<DateTime> times,
    required String title,
    required String body,
    required String channelName,
  });

  Future<void> cancelCheckInReminders();
}

class LocalNotificationGateway implements NotificationGateway {
  new([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const _reminderId = 1;
  static const _channelId = 'backup_reminder';
  static const _checkInChannelId = 'check_in_reminder';
  static const _checkInFirstId = 100;
  static const _checkInMaxCount = 8;

  final FlutterLocalNotificationsPlugin _plugin;
  bool _isInitialised = false;

  Future<void> _ensureInitialised() async {
    if (_isInitialised) {
      return;
    }
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
    _isInitialised = true;
  }

  Future<bool> _requestPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    return await ios?.requestPermissions(alert: true) ?? false;
  }

  @override
  Future<bool> enableWeeklyReminder({
    required String title,
    required String body,
    required String channelName,
  }) async {
    await _ensureInitialised();
    if (!await _requestPermission()) {
      return false;
    }
    await _plugin.periodicallyShow(
      id: _reminderId,
      title: title,
      body: body,
      repeatInterval: RepeatInterval.weekly,
      androidScheduleMode: AndroidScheduleMode.inexact,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          channelName,
          importance: Importance.low,
          priority: Priority.low,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
    return true;
  }

  @override
  Future<void> disableWeeklyReminder() async {
    await _ensureInitialised();
    await _plugin.cancel(id: _reminderId);
  }

  @override
  Future<bool> scheduleCheckInReminders({
    required List<DateTime> times,
    required String title,
    required String body,
    required String channelName,
  }) async {
    await _ensureInitialised();
    if (!await _requestPermission()) {
      return false;
    }
    await cancelCheckInReminders();
    for (final (index, time) in times.take(_checkInMaxCount).indexed) {
      // An absolute instant is DST-safe for one-off reminders, so the device
      // time-zone database isn't needed.
      await _plugin.zonedSchedule(
        id: _checkInFirstId + index,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(time.toUtc(), tz.UTC),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(_checkInChannelId, channelName),
          iOS: const DarwinNotificationDetails(),
        ),
      );
    }
    return true;
  }

  @override
  Future<void> cancelCheckInReminders() async {
    await _ensureInitialised();
    for (var index = 0; index < _checkInMaxCount; index++) {
      await _plugin.cancel(id: _checkInFirstId + index);
    }
  }
}
