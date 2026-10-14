/// One section of a backup payload, owned by the feature that owns the data.
abstract interface class BackupContributor {
  String get payloadKey;

  /// Whether a backup without this key is still valid.
  bool get isOptional;

  Future<Object?> export();

  /// Returns a reason when [value] is invalid, otherwise null.
  String? validate(Object? value);

  /// Stages [value] (null when absent from an optional section).
  Future<void> restore(Object? value);
}
