import 'package:icalendar_parser/src/model/ical_datetime.dart';
import 'package:icalendar_parser/src/model/icalendar.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  group('Issue #46', () {
    test('CREATED property', () {
      final eventText = readFileLines('created.ics');
      final iCal = ICalendar.fromLines(eventText);

      final created =
          iCal.data.firstWhere((e) => e.containsKey('created'))['created'];

      expect(
        created,
        const IcalDateTime(dt: "19960329T133000Z"),
      );
    });
  });
}
