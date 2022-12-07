import 'package:icalendar_parser/src/model/ics_transp.dart';
import 'package:test/test.dart';

void main() {
  group('IcsTranspModifier', () {
    test('string', () {
      expect(IcsTransp.opaque.key, 'OPAQUE');
      expect(IcsTransp.transparent.key, 'TRANSPARENT');
    });
  });
}
