import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  group('Issue #33', () {
    test('No email in ORGANIZER - 1', () {
      final wantedOrganizer = ICalOrganizer(cn: 'Joe Jackson', value: Uri());
      final eventText = readFileLines('organizer_no_email.ics');
      final iCal = ICalendar.fromLines(eventText);

      final event = iCal.data[0];
      final organizer = event['organizer'] as ICalOrganizer;

      print('=${organizer.value}=');
      print(wantedOrganizer.toJson());

      expect(organizer, wantedOrganizer);
    });

    test('No email in ORGANIZER - 2', () {
      final eventText = readFileLines('organizer_no_email_2.ics');
      final iCal = ICalendar.fromLines(eventText);
      expect(iCal.data.length, 1);

      final event = iCal.data[0];
      final organizer = event['organizer'] as Map<String, dynamic>;
      expect(organizer['name'], 'Joe Jackson');
      expect(organizer['mail'], '');
    });
  });
}
