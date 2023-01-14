import 'package:icalendar_parser/src/model/icalendar.dart';
import 'package:icalendar_parser/src/model/ics_datetime.dart';
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
        IcsDateTime(dt: "19960329T133000Z"),
      );
    });
  });
}
