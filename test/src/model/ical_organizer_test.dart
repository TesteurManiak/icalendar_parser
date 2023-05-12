import 'package:icalendar_parser/src/model/ical_organizer.dart';
import 'package:test/test.dart';

void main() {
  group('ICalOrganizer', () {
    const validValue = 'CN=John Smith:mailto:jsmith@example.com';
    const validWithDir =
        'CN=JohnSmith;DIR="ldap://example.com:6666/o=DC%20Associates,c=US???(cn=John%20Smith)":mailto:jsmith@example.com';
    const invalidValue = ':: invalid value ::';

    group('parse', () {
      test('should parse a valid value', () {
        expect(
          () => ICalOrganizer.parse(validValue),
          returnsNormally,
        );
      });

      test('should throw when parsing an invalid value', () {
        expect(
          () => ICalOrganizer.parse(invalidValue),
          throwsFormatException,
        );
      });

      test('should parse validWithDir', () {
        expect(
          () => ICalOrganizer.parse(validWithDir),
          returnsNormally,
        );
      });
    });

    group('tryParse', () {
      test('should parse a valid value', () {
        expect(
          ICalOrganizer.tryParse(validValue),
          isNotNull,
        );
      });

      test('should return null when parsing an invalid value', () {
        expect(
          ICalOrganizer.tryParse(invalidValue),
          isNull,
        );
      });

      test('should return null when parsing a null value', () {
        expect(
          ICalOrganizer.tryParse(null),
          isNull,
        );
      });
    });

    group('toJson', () {
      const validWithSentBy =
          'SENT-BY="mailto:jane_doe@example.com":mailto:jsmith@example.com';

      test('JSON representation for validValue', () {
        final organizer = ICalOrganizer.parse(validValue);

        expect(
          organizer.toJson(),
          equals({
            'value': 'mailto:jsmith@example.com',
            'cn': 'John Smith',
          }),
        );
      });

      test('JSON representation for validWithDir', () {
        final organizer = ICalOrganizer.parse(validWithDir);

        expect(
          organizer.toJson(),
          equals({
            'value': 'mailto:jsmith@example.com',
            'cn': 'JohnSmith',
            'dir':
                '"ldap://example.com:6666/o=DC%20Associates,c=US???(cn=John%20Smith)"',
          }),
        );
      });

      test('JSON representation for validWithSentBy', () {
        final organizer = ICalOrganizer.parse(validWithSentBy);

        expect(
          organizer.toJson(),
          equals({
            'value': 'mailto:jsmith@example.com',
            'sentBy': '"mailto:jane_doe@example.com"',
          }),
        );
      });
    });
  });
}
