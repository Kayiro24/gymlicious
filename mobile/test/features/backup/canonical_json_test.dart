import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/features/backup/domain/canonical_json.dart';

void main() {
  test('matches the ADR 0002 checksum vector', () {
    const input = {
      'b': true,
      'a': {
        'd': [1, 2.5],
        'c': 'x',
      },
    };
    expect(CanonicalJson.encode(input), '{"a":{"c":"x","d":[1,2.5]},"b":true}');
    expect(
      CanonicalJson.sha256Hex(input),
      '581a9cae457de5ab13a349174029ad804d18793f69fcdbf4548122c612d7ebdc',
    );
  });
}
