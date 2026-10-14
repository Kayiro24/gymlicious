import 'dart:developer' as developer;

enum LogLevel { debug, info, warning, error }

/// Local-only logger. Never log personal data.
abstract interface class AppLogger {
  void log(LogLevel level, String message, [Object? error]);
}

class DeveloperLogger implements AppLogger {
  const new({required this.minimumLevel});

  final LogLevel minimumLevel;

  @override
  void log(LogLevel level, String message, [Object? error]) {
    if (level.index < minimumLevel.index) {
      return;
    }
    developer.log(message, name: 'gym_tracker.${level.name}', error: error);
  }
}

class SilentLogger implements AppLogger {
  const new();

  @override
  void log(LogLevel level, String message, [Object? error]) {}
}
