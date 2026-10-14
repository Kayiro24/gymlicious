/// Narrows decoded JSON with clear errors instead of untyped casts.
abstract final class JsonCast {
  static List<Map<String, dynamic>> objectList(Object? value, String what) {
    if (value is! List) {
      throw FormatException('$what must be a list');
    }
    return [
      for (final item in value)
        if (item is Map<String, dynamic>)
          item
        else
          throw FormatException('$what must contain objects'),
    ];
  }

  static Map<String, dynamic>? optionalObject(Object? value, String what) {
    if (value == null) {
      return null;
    }
    if (value is Map<String, dynamic>) {
      return value;
    }
    throw FormatException('$what must be an object');
  }

  static Map<String, dynamic> object(Object? value, String what) =>
      optionalObject(value, what) ??
      (throw FormatException('$what is missing'));
}
