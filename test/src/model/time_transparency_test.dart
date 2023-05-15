import 'package:icalendar_parser/src/model/time_transparency.dart';
import 'package:test/test.dart';

void main() {
  group('TimeTransparency', () {
    test('value', () {
      expect(TimeTransparency.opaque.value, 'OPAQUE');
      expect(TimeTransparency.transparent.value, 'TRANSPARENT');
    });

    test('toString', () {
      for (final value in TimeTransparency.values) {
        expect(value.toString(), value.value);
      }
    });

    group('parse', () {
      test('should be able to parse a valid string', () {
        const key = 'OPAQUE';
        final result = TimeTransparency.parse(key);
        expect(result, TimeTransparency.opaque);
      });

      test('should throw an ArgumentError for an unknown value', () {
        const key = 'UNKNOWN';
        expect(() => TimeTransparency.parse(key), throwsArgumentError);
      });
    });
  });
}
