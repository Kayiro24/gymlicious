/// Typed errors that cross layer boundaries; widgets never see exceptions.
sealed class Failure {
  const new(this.debugMessage);

  final String debugMessage;

  @override
  String toString() => 'Failure: $debugMessage';
}

enum StorageFailureKind {
  readFailed,
  writeFailed,
  corrupted,
  unsupportedSchema,
}

class StorageFailure extends Failure {
  const new(this.kind, super.debugMessage);

  final StorageFailureKind kind;
}

class ValidationFailure extends Failure {
  const new(this.fieldErrors) : super('validation failed');

  final Map<String, String> fieldErrors;
}

class NetworkFailure extends Failure {
  const new(super.debugMessage, {this.isRateLimited = false});

  final bool isRateLimited;
}

enum BackupFailureKind {
  notABackup,
  damaged,
  newerSchema,
  invalidStructure,
  cancelled,
  writeFailed,
}

class BackupFailure extends Failure {
  const new(this.kind, super.debugMessage);

  final BackupFailureKind kind;
}

class PlatformFailure extends Failure {
  const new(super.debugMessage, {this.isCancelled = false});

  final bool isCancelled;
}
