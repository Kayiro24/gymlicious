import 'dart:convert';

import 'package:crypto/crypto.dart';

/// UTF-8 JSON with object keys sorted recursively and no whitespace (D16).
abstract final class CanonicalJson {
  static String encode(Object? value) => jsonEncode(_sorted(value));

  static String sha256Hex(Object? value) =>
      sha256.convert(utf8.encode(encode(value))).toString();

  static Object? _sorted(Object? value) => switch (value) {
    final Map<String, dynamic> map => {
      for (final key in map.keys.toList()..sort()) key: _sorted(map[key]),
    },
    final List<dynamic> list => [for (final item in list) _sorted(item)],
    _ => value,
  };
}
