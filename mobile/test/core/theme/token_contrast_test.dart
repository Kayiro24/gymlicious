import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

/// WCAG 2.x relative luminance of a `#RRGGBB` colour.
double _luminance(String hex) {
  double channel(int start) {
    final value = int.parse(hex.substring(start, start + 2), radix: 16) / 255;
    return value <= 0.03928
        ? value / 12.92
        : pow((value + 0.055) / 1.055, 2.4).toDouble();
  }

  return 0.2126 * channel(1) + 0.7152 * channel(3) + 0.0722 * channel(5);
}

double _contrast(String a, String b) {
  final (la, lb) = (_luminance(a), _luminance(b));
  return (max(la, lb) + 0.05) / (min(la, lb) + 0.05);
}

void main() {
  final tokens = jsonDecode(
    File('../design-tokens/tokens.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  final colors = tokens['color'] as Map<String, dynamic>;
  final pairs = tokens['contrastPairs'] as List<dynamic>;

  for (final mode in ['light', 'dark']) {
    final palette = colors[mode] as Map<String, dynamic>;
    for (final pair in pairs.cast<List<dynamic>>()) {
      final [foreground as String, background as String] = pair;
      test('$mode $foreground on $background meets AA (4.5:1)', () {
        final ratio = _contrast(
          palette[foreground] as String,
          palette[background] as String,
        );
        expect(ratio, greaterThanOrEqualTo(4.5));
      });
    }
  }
}
