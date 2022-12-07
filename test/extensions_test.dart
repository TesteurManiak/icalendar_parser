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
        expect('opaque'.toIcsTransp(), IcsTransp.opaque);
        expect('OPAQUE'.toIcsTransp(), IcsTransp.opaque);
      });

      test('IcsTransp.TRANSPARENT', () {
        expect('transparent'.toIcsTransp(), IcsTransp.transparent);
        expect('TRANSPARENT'.toIcsTransp(), IcsTransp.transparent);
      });

      test('unknown', () {
        expect(
          () => ''.toIcsTransp(),
          throwsA(const TypeMatcher<ICalendarTranspParseException>()),
        );
      });
    });
  });

  group('IcsTranspModifier', () {
    test('string', () {
      expect(IcsTransp.opaque.string, 'OPAQUE');
      expect(IcsTransp.transparent.string, 'TRANSPARENT');
    });
  });

  group('IcsStatusModifier', () {
    test('string', () {
      expect(IcsStatus.cancelled.key, 'CANCELLED');
      expect(IcsStatus.completed.key, 'COMPLETED');
      expect(IcsStatus.confirmed.key, 'CONFIRMED');
      expect(IcsStatus.draft.key, 'DRAFT');
      expect(IcsStatus.inProcess.key, 'IN-PROCESS');
      expect(IcsStatus.isFinal.key, 'FINAL');
      expect(IcsStatus.needsAction.key, 'NEEDS-ACTION');
      expect(IcsStatus.tentative.key, 'TENTATIVE');
    });
  });
}
