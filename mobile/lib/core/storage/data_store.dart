typedef JsonMap = Map<String, Object?>;

/// Persists the whole app document; the only component that touches its file.
abstract interface class DataStore {
  /// Loads the document, falling back to the backup copy when the primary
  /// fails to parse or [isValid] rejects it.
  Future<StoreLoadResult> load({required bool Function(JsonMap) isValid});

  Future<void> save(JsonMap document);

  Future<void> deleteAll();
}

sealed class StoreLoadResult {
  const new();
}

final class StoreLoaded extends StoreLoadResult {
  const new(this.document, {required this.isRecoveredFromBackup});

  final JsonMap document;
  final bool isRecoveredFromBackup;
}

final class StoreEmpty extends StoreLoadResult {
  const new();
}

final class StoreCorrupted extends StoreLoadResult {
  const new(this.reason);

  final String reason;
}
