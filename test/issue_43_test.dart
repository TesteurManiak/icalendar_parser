import 'package:icalendar_parser/src/model/icalendar.dart';
import 'package:icalendar_parser/src/model/ics_datetime.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  group('Issue #43', () {
    test('Multi-line EXDATE', () {
      final eventText = readFileLines('multi_line_exdate.ics');
      final iCal = ICalendar.fromLines(eventText);

      final exdates =
          iCal.data.firstWhere((e) => e.containsKey('exdate'))['exdate'];

      expect(
        exdates,
        [
          const IcsDateTime(dt: "20221210T000000", tzid: "Europe/Berlin"),
          const IcsDateTime(dt: "20221208T000000", tzid: "Europe/Berlin"),
        ],
      );
    });
  });
}
