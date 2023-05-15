import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:test/test.dart';

void main() {
  group('IcsStringModifier', () {
    group('toIcsStatus', () {
      test('IcsStatus.TENTATIVE', () {
        expect('tentative'.toIcsStatus(), IcsStatus.tentative);
        expect('TENTATIVE'.toIcsStatus(), IcsStatus.tentative);
      });

      test('IcsStatus.CONFIRMED', () {
        expect('confirmed'.toIcsStatus(), IcsStatus.confirmed);
        expect('CONFIRMED'.toIcsStatus(), IcsStatus.confirmed);
      });

      test('IcsStatus.CANCELLED', () {
        expect('cancelled'.toIcsStatus(), IcsStatus.cancelled);
        expect('CANCELLED'.toIcsStatus(), IcsStatus.cancelled);
      });

      test('unknown', () {
        expect(
          () => ''.toIcsStatus(),
          throwsA(const TypeMatcher<ICalendarStatusParseException>()),
        );
      });
    });

    group('toIcsTransp()', () {
      test('IcsTransp.OPAQUE', () {
        expect('opaque'.toIcsTransp(), TimeTransparency.opaque);
        expect('OPAQUE'.toIcsTransp(), TimeTransparency.opaque);
      });

      test('IcsTransp.TRANSPARENT', () {
        expect('transparent'.toIcsTransp(), TimeTransparency.transparent);
        expect('TRANSPARENT'.toIcsTransp(), TimeTransparency.transparent);
      });

      test('unknown', () {
        expect(
          () => ''.toIcsTransp(),
          throwsArgumentError,
        );
      });
    });
  });
}
