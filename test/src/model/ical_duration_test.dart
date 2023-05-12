import 'package:icalendar_parser/src/model/ical_duration.dart';
import 'package:test/test.dart';

void main() {
  group('IcalDuration', () {
    const accurateDuration = 'P15DT5H0M20S';
    const wantedAccurateDuration = Duration(
      days: 15,
      hours: 5,
      seconds: 20,
    );

    const nominalDuration = 'P7W';
    const wantedNominalDuration = Duration(days: 49);

    const invalidDuration = 'invalid';

    group('parse', () {
      test('should parse accurateDuration', () {
        final duration = IcalDuration.parse(accurateDuration);
        expect(duration, equals(wantedAccurateDuration));
      });

      test('should parse nominalDuration', () {
        final duration = IcalDuration.parse(nominalDuration);
        expect(duration, equals(wantedNominalDuration));
      });

      test('should throw FormatException', () {
        expect(
          () => IcalDuration.parse(invalidDuration),
          throwsFormatException,
        );
      });
    });

    group('tryParse', () {
      test('should parse accurateDuration', () {
        final duration = IcalDuration.tryParse(accurateDuration);
        expect(duration, equals(wantedAccurateDuration));
      });

      test('should parse nominalDuration', () {
        final duration = IcalDuration.tryParse(nominalDuration);
        expect(duration, equals(wantedNominalDuration));
      });

      test('should return null', () {
        final duration = IcalDuration.tryParse(invalidDuration);
        expect(duration, isNull);
      });
    });

    group('toString', () {
      test('should return accurateDuration', () {
        final duration = IcalDuration.parse(accurateDuration);
        expect(duration.toString(), equals(accurateDuration));
      });

      test('should return nominalDuration as days', () {
        final duration = IcalDuration.parse(nominalDuration);
        expect(duration.toString(), equals('P49D'));
      });
    });
  });
}
