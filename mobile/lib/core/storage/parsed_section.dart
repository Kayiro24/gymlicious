import 'package:gym_tracker/core/storage/data_section.dart';

/// A section whose validity is "the data layer can parse it".
class ParsedSection implements DataSection {
  const new({
    required this.key,
    required this.emptyValue,
    required this.parse,
    this.isBackedUp = true,
  });

  @override
  final String key;

  @override
  final Object? emptyValue;

  @override
  final bool isBackedUp;

  final Object? Function(Object? raw) parse;

  @override
  String? validate(Object? value) {
    try {
      parse(value);
      return null;
    } on Object catch (error) {
      return '$error';
    }
  }
}
