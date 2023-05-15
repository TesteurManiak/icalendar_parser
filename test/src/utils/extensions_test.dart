import 'package:icalendar_parser/src/utils/extensions.dart';
import 'package:test/test.dart';

void main() {
  group('MapExtensions', () {
    group('toValidMap', () {
      const wantedMap = <String, dynamic>{'b': 'test'};

      test('should remove null values', () {
        final map = <String, dynamic>{'a': null, 'b': 'test'};
        expect(map.toValidMap(), equals(wantedMap));
      });

      test('should remove empty strings', () {
        final map = <String, dynamic>{'a': '', 'b': 'test'};
        expect(map.toValidMap(), equals(wantedMap));
      });

      test('should remove empty lists', () {
        final map = <String, dynamic>{'a': <Object?>[], 'b': 'test'};
        expect(map.toValidMap(), equals(wantedMap));
      });
    });
  });

  group('StringExtensions', () {
    group('splitFirst', () {
      test('should split the string on the first separator only', () {
        const str = 'a:b:c';
        expect(str.splitFirst(':'), equals(['a', 'b:c']));
      });

      test('if the separator is not found should return the string', () {
        const str = 'abc';
        expect(str.splitFirst(':'), equals(['abc']));
      });
    });
  });
}
