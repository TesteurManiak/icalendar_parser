import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:test/test.dart';

void main() {
  group('IcsDateTime', () {
    group('hashCode', () {
      test(
        'two object with the same properties should have the same hashCode',
        () {
          const d1 = IcsDateTime(tzid: 'Europe/Zurich', dt: '20220415T145500');
          const d2 = IcsDateTime(tzid: 'Europe/Zurich', dt: '20220415T145500');

          expect(d1.hashCode, d2.hashCode);
          expect(d1, d2);
        },
      );
    });

    test('toString', () {
      const d1 = IcsDateTime(tzid: 'Europe/Zurich', dt: '20220415T145500');
      expect(
        d1.toString(),
        'IcsDateTime{tzid: Europe/Zurich, dt: 20220415T145500}',
      );
    });
  });
}
