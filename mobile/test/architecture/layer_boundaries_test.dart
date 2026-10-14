import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _package = 'package:gym_tracker/';

final _importPattern = RegExp(
  r'''^\s*(?:import|export)\s+['"]([^'"]+)['"]''',
  multiLine: true,
);

final _forbiddenInDomain = [
  'package:flutter/',
  'package:flutter_riverpod/',
  'package:dio/',
  'package:path_provider/',
  'package:image/',
  'dart:io',
  'dart:ui',
];

class _SourceFile {
  new(this.file)
    : path = file.path
          .replaceAll(r'\', '/')
          .replaceFirst(RegExp('^(.*/)?lib/'), ''),
      imports = _importPattern
          .allMatches(file.readAsStringSync())
          .map((match) => match.group(1)!)
          .toList();

  final File file;
  final String path;
  final List<String> imports;

  String? get feature =>
      path.startsWith('features/') ? path.split('/')[1] : null;

  bool get isDomain => path.contains('/domain/');

  Iterable<String> get internalImports => imports
      .where((uri) => uri.startsWith(_package))
      .map((uri) => uri.substring(_package.length));
}

List<_SourceFile> _sources() =>
    Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .where((file) => !file.path.endsWith('.g.dart'))
        .where((file) => !file.path.endsWith('.freezed.dart'))
        .map(_SourceFile.new)
        .toList();

String? _featureOf(String path) =>
    path.startsWith('features/') ? path.split('/')[1] : null;

bool _isPublicApi(String path, String feature) =>
    path == 'features/$feature/$feature.dart' ||
    path == 'features/$feature/${feature}_domain.dart';

void main() {
  final sources = _sources();

  test('domain layers are pure Dart', () {
    final violations = [
      for (final source in sources.where((item) => item.isDomain))
        for (final uri in source.imports)
          if (_forbiddenInDomain.any(uri.startsWith)) '${source.path} → $uri',
    ];
    expect(violations, isEmpty);
  });

  test('domain layers never reach into data or presentation', () {
    final violations = [
      for (final source in sources.where((item) => item.isDomain))
        for (final path in source.internalImports)
          if (path.contains('/data/') ||
              path.contains('/presentation/') ||
              path.startsWith('design_system/') ||
              path.startsWith('shared/') ||
              path.startsWith('app/'))
            '${source.path} → $path',
    ];
    expect(violations, isEmpty);
  });

  test('domain layers import other features only through *_domain.dart', () {
    final violations = [
      for (final source in sources.where((item) => item.isDomain))
        for (final path in source.internalImports)
          if (_featureOf(path) case final other?
              when other != source.feature &&
                  path != 'features/$other/${other}_domain.dart')
            '${source.path} → $path',
    ];
    expect(violations, isEmpty);
  });

  test('features use each other only through their public API files', () {
    final violations = [
      for (final source in sources.where((item) => item.feature != null))
        for (final path in source.internalImports)
          if (_featureOf(path) case final other?
              when other != source.feature && !_isPublicApi(path, other))
            '${source.path} → $path',
    ];
    expect(violations, isEmpty);
  });

  test('core, design_system and shared do not depend on features', () {
    final violations = [
      for (final source in sources)
        if (source.path.startsWith('core/') ||
            source.path.startsWith('design_system/') ||
            source.path.startsWith('shared/'))
          for (final path in source.internalImports)
            if (path.startsWith('features/') || path.startsWith('app/'))
              '${source.path} → $path',
    ];
    expect(violations, isEmpty);
  });

  test('design_system does not depend on shared', () {
    final violations = [
      for (final source in sources)
        if (source.path.startsWith('design_system/'))
          for (final path in source.internalImports)
            if (path.startsWith('shared/')) '${source.path} → $path',
    ];
    expect(violations, isEmpty);
  });
}
