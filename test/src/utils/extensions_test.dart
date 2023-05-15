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
}
