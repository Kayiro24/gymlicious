import 'dart:convert';
import 'dart:io';

const _header =
    'GENERATED FILE. Edit design-tokens/tokens.json and run '
    '`dart design-tokens/tool/generate_theme.dart` from the repo root.';
const _dartOut = 'mobile/lib/core/theme/generated/design_tokens.g.dart';
const _kotlinOut =
    'mobile/android/app/src/main/kotlin/com/kayiro/gym_tracker/'
    'wallpaper/YearDotsTokens.kt';

void main() {
  final tokens = jsonDecode(
    File('design-tokens/tokens.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  File(_dartOut)
    ..createSync(recursive: true)
    ..writeAsStringSync(_dart(tokens));
  File(_kotlinOut)
    ..createSync(recursive: true)
    ..writeAsStringSync(_kotlin(tokens));
  stdout.writeln('Wrote $_dartOut and $_kotlinOut');
}

String _argb(String hex) => '0xFF${hex.substring(1).toUpperCase()}';

String _num(Object value) {
  final number = value as num;
  return number == number.roundToDouble() && number is int
      ? '$number.0'
      : '$number';
}

String _colorClass(String name, Map<String, dynamic> colors) {
  final buffer = StringBuffer('abstract final class $name {\n');
  colors.forEach((key, value) {
    buffer.writeln('  static const $key = Color(${_argb(value as String)});');
  });
  buffer
    ..writeln()
    ..writeln('  static const byName = <String, Color>{');
  for (final key in colors.keys) {
    buffer.writeln("    '$key': $key,");
  }
  buffer
    ..writeln('  };')
    ..writeln('}');
  return buffer.toString();
}

String _doubleClass(String name, Map<String, dynamic> values) {
  final buffer = StringBuffer('abstract final class $name {\n');
  values.forEach((key, value) {
    buffer.writeln('  static const double $key = ${_num(value as Object)};');
  });
  buffer.writeln('}');
  return buffer.toString();
}

/// Ints stay ints (counts, thresholds); everything else is a double.
String _numberClass(String name, Map<String, dynamic> values) {
  final buffer = StringBuffer()..writeln('abstract final class $name {');
  values.forEach((key, value) {
    final type = value is int ? 'int' : 'double';
    buffer.writeln('  static const $type $key = $value;');
  });
  buffer.writeln('}');
  return buffer.toString();
}

String _dart(Map<String, dynamic> tokens) {
  final color = tokens['color'] as Map<String, dynamic>;
  final motion = tokens['motion'] as Map<String, dynamic>;
  final yearDots = tokens['yearDots'] as Map<String, dynamic>;
  final presets = yearDots['presets'] as Map<String, dynamic>;
  final pairs = (tokens['contrastPairs'] as List<dynamic>)
      .cast<List<dynamic>>();

  final buffer = StringBuffer()
    ..writeln('// $_header')
    ..writeln('// ignore_for_file: public_member_api_docs')
    ..writeln()
    ..writeln("import 'dart:ui';")
    ..writeln()
    ..writeln(
      _colorClass('LightTokenColors', color['light'] as Map<String, dynamic>),
    )
    ..writeln(
      _colorClass('DarkTokenColors', color['dark'] as Map<String, dynamic>),
    )
    ..writeln(
      _doubleClass('TokenSpace', tokens['space'] as Map<String, dynamic>),
    )
    ..writeln(
      _doubleClass('TokenRadius', tokens['radius'] as Map<String, dynamic>),
    )
    ..writeln(
      _doubleClass('TokenTypeScale', tokens['type'] as Map<String, dynamic>),
    )
    ..writeln(
      _doubleClass('TokenLayout', tokens['layout'] as Map<String, dynamic>),
    )
    ..writeln(
      _doubleClass(
        'TokenElevation',
        tokens['elevation'] as Map<String, dynamic>,
      ),
    )
    ..writeln(
      _numberClass('TokenFlame', tokens['flame'] as Map<String, dynamic>),
    )
    ..writeln('abstract final class TokenMotion {');
  motion.forEach((key, value) {
    final name = key.replaceAll('Ms', '');
    buffer.writeln('  static const $name = Duration(milliseconds: $value);');
  });
  buffer
    ..writeln('}')
    ..writeln()
    ..writeln('abstract final class TokenYearDots {');
  for (final key in yearDots.keys.where((key) => key != 'presets')) {
    final value = yearDots[key] as num;
    final type = value is int ? 'int' : 'double';
    buffer.writeln('  static const $type $key = $value;');
  }
  buffer
    ..writeln('}')
    ..writeln()
    ..writeln('class YearDotsPresetTokens {')
    ..writeln('  const YearDotsPresetTokens({')
    ..writeln('    required this.background,')
    ..writeln('    required this.done,')
    ..writeln('    required this.today,')
    ..writeln('    required this.left,')
    ..writeln('    required this.text,')
    ..writeln('  });')
    ..writeln()
    ..writeln('  final Color background;')
    ..writeln('  final Color done;')
    ..writeln('  final Color today;')
    ..writeln('  final Color left;')
    ..writeln('  final Color text;')
    ..writeln('}')
    ..writeln()
    ..writeln('abstract final class TokenYearDotsPresets {');
  presets.forEach((name, value) {
    final preset = value as Map<String, dynamic>;
    buffer.writeln('  static const $name = YearDotsPresetTokens(');
    preset.forEach((key, hex) {
      buffer.writeln('    $key: Color(${_argb(hex as String)}),');
    });
    buffer.writeln('  );');
  });
  buffer
    ..writeln('}')
    ..writeln()
    ..writeln('const tokenContrastPairs = <(String, String)>[');
  for (final pair in pairs) {
    buffer.writeln("  ('${pair[0]}', '${pair[1]}'),");
  }
  buffer.writeln('];');
  return buffer.toString();
}

String _kotlin(Map<String, dynamic> tokens) {
  final yearDots = tokens['yearDots'] as Map<String, dynamic>;
  final presets = yearDots['presets'] as Map<String, dynamic>;
  final buffer = StringBuffer()
    ..writeln('// $_header')
    ..writeln('package com.kayiro.gym_tracker.wallpaper')
    ..writeln()
    ..writeln('object YearDotsTokens {');
  for (final key in yearDots.keys.where((key) => key != 'presets')) {
    final value = yearDots[key] as num;
    final literal = value is int ? '$value' : '${value}f';
    final name = key.replaceAllMapped(
      RegExp('[A-Z]'),
      (match) => '_${match[0]}',
    );
    buffer.writeln('    const val ${name.toUpperCase()} = $literal');
  }
  buffer
    ..writeln()
    ..writeln('    val presets: Map<String, YearDotsPalette> = mapOf(');
  presets.forEach((name, value) {
    final preset = value as Map<String, dynamic>;
    final args = preset.entries
        .map(
          (entry) => '${entry.key} = ${_argb(entry.value as String)}.toInt()',
        )
        .join(', ');
    buffer.writeln('        "$name" to YearDotsPalette($args),');
  });
  buffer
    ..writeln('    )')
    ..writeln('}')
    ..writeln()
    ..writeln('data class YearDotsPalette(')
    ..writeln('    val background: Int,')
    ..writeln('    val done: Int,')
    ..writeln('    val today: Int,')
    ..writeln('    val left: Int,')
    ..writeln('    val text: Int,')
    ..writeln(')');
  return buffer.toString();
}
