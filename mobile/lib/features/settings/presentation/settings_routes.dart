abstract final class SettingsRoutes {
  static const root = '/settings';
  static const about = '/settings/about';
  static const privacy = '/settings/privacy';
}

/// Full-screen destinations owned by other features, linked from Settings.
abstract final class SettingsLinks {
  static const profile = '/profile';
  static const backup = '/backup';
  static const reset = '/backup/reset';
  static const wallpaper = '/wallpaper';
}
