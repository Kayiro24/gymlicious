abstract final class BackupReminder {
  static const staleAfter = Duration(days: 14);
  static const sessionsSinceStaleBackup = 5;
  static const sessionsWithoutAnyBackup = 3;
  static const dismissalLasts = Duration(days: 7);

  /// Spec 5.9: remind when the last backup is over 14 days old and at least
  /// five sessions were logged since, or never backed up after three. A
  /// dismissal quiets the banner for a week (D39).
  static bool isDue({
    required DateTime now,
    required DateTime? lastBackupAt,
    required DateTime? dismissedAt,
    required Iterable<DateTime> sessionStarts,
    required bool isEnabled,
  }) {
    if (!isEnabled) {
      return false;
    }
    if (dismissedAt != null && now.difference(dismissedAt) < dismissalLasts) {
      return false;
    }
    if (lastBackupAt == null) {
      return sessionStarts.length >= sessionsWithoutAnyBackup;
    }
    final isStale = now.difference(lastBackupAt) > staleAfter;
    final sessionsSince = sessionStarts
        .where((start) => start.isAfter(lastBackupAt))
        .length;
    return isStale && sessionsSince >= sessionsSinceStaleBackup;
  }

  /// Backups older than this are shown with a gentle warning style.
  static bool isOld({required DateTime now, required DateTime? lastBackupAt}) =>
      lastBackupAt == null || now.difference(lastBackupAt) > staleAfter;
}
