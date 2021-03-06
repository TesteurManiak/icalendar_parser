import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:icalendar_parser/src/exceptions/icalendar_exception.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  test('Missing PRODID', () {
    final noProdidLines = readFileLines('no_prodid.ics');
    expect(() => ICalendar.fromLines(noProdidLines),
        throwsA(isA<ICalendarNoProdidException>()));
  });

  group('Valid calendar', () {
    final _valid = readFileLines('valid.ics');

    group('fromLines()', () {
      final _validMultiline = readFileLines('valid_multiline.ics');
      final _validWithAlarm = readFileLines('valid_with_alarm.ics');

      test('base valid', () {
        final obj = ICalendar.fromLines(_valid);
        expect(obj.data.isNotEmpty, true);
      });

      test('ending w/ newline: authorized empty line', () {
        final lines = List<String>.from(_valid)..add('');
        expect(ICalendar.fromLines(lines).data.length, 1);
      });

      test('ending w/ newline: unauthorized empty line', () {
        final lines = List<String>.from(_valid)..add('');
        expect(() => ICalendar.fromLines(lines, allowEmptyLine: false),
            throwsA(isA<ICalendarEndException>()));
      });

      test('w/ multiline description', () {
        final iCalendarLines = ICalendar.fromLines(_validMultiline);
        expect(
          iCalendarLines.data.first['description'] as String,
          equals(
            r'Lorem ipsum dolor sit amet, consectetur adipiscing elit.Sed suscipit malesuada sodales.Ut viverra metus neque, ut ullamcorper felis fermentum vel.Sed sodales mauris nec.',
          ),
        );
      });

      test('parse TRIGGER', () {
        final iCalendar = ICalendar.fromLines(_validWithAlarm);
        expect(iCalendar.data[1]['trigger'], '-PT1440M');
      });
    });

    group('Properties', () {
      final iCalendar = ICalendar.fromLines(_valid);

      test('version', () {
        expect(iCalendar.version, '2.0');
      });

      test('prodid', () {
        expect(iCalendar.prodid, '-//hacksw/handcal//NONSGML v1.0//EN');
      });

      test('calscale', () {
        expect(iCalendar.calscale, 'GREGORIAN');
      });

      test('method', () {
        expect(iCalendar.method, 'PUBLISH');
      });
    });

    test('toString()', () {
      final iCal = ICalendar.fromLines(_valid);
      final str = iCal.toString();
      expect(str.contains('iCalendar - VERSION: 2.0 - PRODID: '), true);
    });

    test('toJson()', () {
      final iCal = ICalendar.fromLines(_valid);
      final json = iCal.toJson();
      expect(json['version'], '2.0');
      expect(json['prodid'], '-//hacksw/handcal//NONSGML v1.0//EN');
      expect(json['calscale'], 'GREGORIAN');
      expect(json['method'], 'PUBLISH');
      expect(json.containsKey('data'), true);
    });

    test('without organizer name', () {
      final _noOrganizerName = readFileLines('no_organizer_name.ics');
      final iCalendar = ICalendar.fromLines(_noOrganizerName);
      final Map<String, dynamic> organizer = iCalendar.data
              .firstWhere((e) => e.containsKey('organizer'))['organizer']
          as Map<String, dynamic>;
      expect(organizer.containsKey('name'), false);
      expect(organizer['mail'], 'john.doe@example.com');
    });

    test('with categories', () {
      final _withCategories = readFileLines('with_categories.ics');
      final iCalendar = ICalendar.fromLines(_withCategories);
      final List<String> categories = iCalendar.data
              .firstWhere((e) => e.containsKey('categories'))['categories']
          as List<String>;
      expect(categories.length, 2);
      expect(categories, ['APPOINTMENT', 'EDUCATION']);
    });

    test('with attendee', () {
      final _withAttendee = readFileLines('with_attendee.ics');
      final iCalendar = ICalendar.fromLines(_withAttendee);
      final List attendee = iCalendar.data
          .firstWhere((e) => e.containsKey('attendee'))['attendee'] as List;
      expect(attendee.length, 1);
      expect(attendee[0]['mail'], 'joecool@host2.com');
      expect(attendee[0]['name'], 'Henry Cabot');
      expect(attendee[0]['role'], 'REQ-PARTICIPANT');
    });

    test('with transp', () {
      final _withTransp = readFileLines('with_transp.ics');
      final iCalendar = ICalendar.fromLines(_withTransp);
      final transp =
          iCalendar.data.firstWhere((e) => e.containsKey('transp'))['transp'];
      expect(transp, IcsTransp.transparent);
    });

    test('with status', () {
      final _withStatus = readFileLines('with_status.ics');
      final iCal = ICalendar.fromLines(_withStatus);
      final status =
          iCal.data.firstWhere((e) => e.containsKey('status'))['status'];
      expect(status, IcsStatus.tentative);
    });
  });
}
