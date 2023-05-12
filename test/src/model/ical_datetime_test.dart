import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:test/test.dart';

void main() {
  group('IcalDateTime', () {
    const invalidDt = 'invalid';
    const dateWithLocalTime = '19980118T230000';
    const dateWithUtcTime = '19980119T070000Z';
    const dateWithTimezone = 'TZID=America/New_York:19980119T020000';

    group('parse', () {
      test('should be able to parse dateWithLocalTime', () {
        final dt = IcalDateTime.parse(dateWithLocalTime);

        expect(dt.tzid, isNull);
        expect(dt.dt, dateWithLocalTime);
      });

      test('should be able to parse dateWithUtcTime', () {
        final dt = IcalDateTime.parse(dateWithUtcTime);

        expect(dt.tzid, isNull);
        expect(dt.dt, dateWithUtcTime);
      });

      test('should be able to parse dateWithTimezone', () {
        final dt = IcalDateTime.parse(dateWithTimezone);

        expect(dt.tzid, 'America/New_York');
        expect(dt.dt, '19980119T020000');
      });

      test('should throw FormatException when invalid format', () {
        expect(() => IcalDateTime.parse(invalidDt), throwsFormatException);
      });
    });

    group('tryParse', () {
      test('should return null when invalid format', () {
        expect(IcalDateTime.tryParse(invalidDt), isNull);
      });

      test('should return IcalDateTime when valid format', () {
        expect(IcalDateTime.tryParse(dateWithLocalTime), isNotNull);
      });
    });
  });

  group('hashCode', () {
    test(
      'two object with the same properties should have the same hashCode',
      () {
        const d1 = IcalDateTime(tzid: 'Europe/Zurich', dt: '20220415T145500');
        const d2 = IcalDateTime(tzid: 'Europe/Zurich', dt: '20220415T145500');

        expect(d1.hashCode, d2.hashCode);
        expect(d1, d2);
      },
    );
  });
}
