import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:test/test.dart';
import 'package:icalendar_parser/src/extensions/string_extensions.dart';

void main() {
  group('IcsStringModifier', () {
    group('toIcsStatus', () {
      test('IcsStatus.TENTATIVE', () {
        expect('tentative'.toIcsStatus(), IcsStatus.TENTATIVE);
        expect('TENTATIVE'.toIcsStatus(), IcsStatus.TENTATIVE);
      });

      test('IcsStatus.CONFIRMED', () {
        expect('confirmed'.toIcsStatus(), IcsStatus.CONFIRMED);
        expect('CONFIRMED'.toIcsStatus(), IcsStatus.CONFIRMED);
      });

      test('IcsStatus.CANCELLED', () {
        expect('cancelled'.toIcsStatus(), IcsStatus.CANCELLED);
        expect('CANCELLED'.toIcsStatus(), IcsStatus.CANCELLED);
      });

      test('unknown', () {
        expect(() => ''.toIcsStatus(),
            throwsA(const TypeMatcher<ICalendarStatusParseException>()));
      });
    });
  });
}
