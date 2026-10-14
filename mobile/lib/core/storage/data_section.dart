/// A top-level section of the app document owned by one feature.
abstract interface class DataSection {
  String get key;

  /// Value used when the section is absent (first launch or after reset).
  Object? get emptyValue;

  /// Whether the section is exported in backups.
  bool get isBackedUp;

  /// Returns a reason when [value] is structurally invalid, otherwise null.
  String? validate(Object? value);
}
