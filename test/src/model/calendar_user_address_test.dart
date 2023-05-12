import 'package:icalendar_parser/src/model/calendar_user_address.dart';
import 'package:test/test.dart';

void main() {
  group('CalendarUserAddress', () {
    const validValue = 'mailto:jane_doe@example.com';
    const alternativeValidValue = 'mailto:john_doe@example.com';
    const invalidValue = ':: invalid value ::';

    group('parse', () {
      test('should parse a valid value', () {
        expect(
          () => CalendarUserAddress.parse(validValue),
          returnsNormally,
        );
      });

      test('should throw when parsing an invalid value', () {
        expect(
          () => CalendarUserAddress.parse(invalidValue),
          throwsFormatException,
        );
      });
    });

    group('tryParse', () {
      test('should parse a valid value', () {
        expect(
          CalendarUserAddress.tryParse(validValue),
          isNotNull,
        );
      });

      test('should return null when parsing an invalid value', () {
        expect(
          CalendarUserAddress.tryParse(invalidValue),
          isNull,
        );
      });

      test('should return null when parsing a null value', () {
        expect(
          CalendarUserAddress.tryParse(null),
          isNull,
        );
      });
    });

    group('equality', () {
      test('should be equal when values are equal', () {
        expect(
          CalendarUserAddress.parse(validValue),
          CalendarUserAddress.parse(validValue),
        );
      });

      test('should not be equal when values are not equal', () {
        expect(
          CalendarUserAddress.parse(validValue),
          isNot(CalendarUserAddress.parse(alternativeValidValue)),
        );
      });
    });

    group('hashCode', () {
      test('should be equal when values are equal', () {
        expect(
          CalendarUserAddress.parse(validValue).hashCode,
          CalendarUserAddress.parse(validValue).hashCode,
        );
      });

      test('should not be equal when values are not equal', () {
        expect(
          CalendarUserAddress.parse(validValue).hashCode,
          isNot(CalendarUserAddress.parse(alternativeValidValue).hashCode),
        );
      });
    });

    group('toString', () {
      test('should return the value', () {
        expect(
          CalendarUserAddress.parse(validValue).toString(),
          validValue,
        );
      });
    });
  });
}
