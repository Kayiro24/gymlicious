import 'dart:math';

abstract interface class IdGenerator {
  String next(String prefix);
}

class RandomIdGenerator implements IdGenerator {
  new([Random? random]) : _random = random ?? Random.secure();

  static const _length = 12;
  static const _alphabet = 'abcdefghijklmnopqrstuvwxyz0123456789';

  final Random _random;

  @override
  String next(String prefix) {
    final buffer = StringBuffer('${prefix}_');
    for (var i = 0; i < _length; i++) {
      buffer.write(_alphabet[_random.nextInt(_alphabet.length)]);
    }
    return buffer.toString();
  }
}
