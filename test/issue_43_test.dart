import 'package:icalendar_parser/src/model/icalendar.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  group('Issue #43', () {
    test('Multi-line EXDATE', () {
      final eventText = readFileLines('multi_line_exdate.ics');
      final iCal = ICalendar.fromLines(eventText);
    });
  });
}
