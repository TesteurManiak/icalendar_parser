import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  test('Missing PRODID', () {
    final noProdidLines = readFileLines('no_prodid.ics');
    expect(
      () => ICalendar.fromLines(noProdidLines),
      throwsA(isA<ICalendarNoProdidException>()),
    );
  });

  group('Valid calendar', () {
    final valid = readFileLines('valid.ics');

    group('fromLines()', () {
      final validMultiline = readFileLines('valid_multiline.ics');
      final validWithAlarm = readFileLines('valid_with_alarm.ics');

      test('base valid', () {
        final obj = ICalendar.fromLines(valid);
        expect(obj.data.isNotEmpty, true);
      });

      test('ending w/ newline: authorized empty line', () {
        final lines = List<String>.from(valid)..add('');
        expect(ICalendar.fromLines(lines).data.length, 1);
      });

      test('ending w/ newline: unauthorized empty line', () {
        final lines = List<String>.from(valid)..add('');
        expect(
          () => ICalendar.fromLines(lines, allowEmptyLine: false),
          throwsA(isA<ICalendarEndException>()),
        );
      });

      test('w/ multiline description', () {
        final iCalendarLines = ICalendar.fromLines(validMultiline);
        expect(
          iCalendarLines.data.first['description'],
          equals(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit.Sed suscipit malesuada sodales.Ut viverra metus neque, ut ullamcorper felis fermentum vel.Sed sodales mauris nec.',
          ),
        );
      });

      test('parse TRIGGER', () {
        final iCalendar = ICalendar.fromLines(validWithAlarm);
        expect(iCalendar.data[1]['trigger'], '-PT1440M');
      });
    });

    group('Properties', () {
      final iCalendar = ICalendar.fromLines(valid);

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

    group('jsonEncodable()', () {
      test('IcsDateTime', () {
        final icsDt = IcsDateTime(dt: DateTime.now().toIso8601String());
        expect(ICalendar.jsonEncodable(icsDt), icsDt.toJson());
      });

      test('IcsTransp', () {
        expect(
          ICalendar.jsonEncodable(IcsTransp.opaque),
          IcsTransp.opaque.key,
        );
        expect(
          ICalendar.jsonEncodable(IcsTransp.transparent),
          IcsTransp.transparent.key,
        );
      });

      test('IcsStatus', () {
        expect(
          ICalendar.jsonEncodable(IcsStatus.tentative),
          IcsStatus.tentative.key,
        );
        expect(
          ICalendar.jsonEncodable(IcsStatus.confirmed),
          IcsStatus.confirmed.key,
        );
        expect(
          ICalendar.jsonEncodable(IcsStatus.cancelled),
          IcsStatus.cancelled.key,
        );
        expect(
          ICalendar.jsonEncodable(IcsStatus.needsAction),
          IcsStatus.needsAction.key,
        );
        expect(
          ICalendar.jsonEncodable(IcsStatus.completed),
          IcsStatus.completed.key,
        );
        expect(
          ICalendar.jsonEncodable(IcsStatus.inProcess),
          IcsStatus.inProcess.key,
        );
        expect(
          ICalendar.jsonEncodable(IcsStatus.draft),
          IcsStatus.draft.key,
        );
        expect(
          ICalendar.jsonEncodable(IcsStatus.isFinal),
          IcsStatus.isFinal.key,
        );
      });
    });

    test('toJson()', () {
      final iCal = ICalendar.fromLines(valid);
      final json = iCal.toJson();
      expect(json['version'], '2.0');
      expect(json['prodid'], '-//hacksw/handcal//NONSGML v1.0//EN');
      expect(json['calscale'], 'GREGORIAN');
      expect(json['method'], 'PUBLISH');
      expect(json.containsKey('data'), true);
    });

    test('without organizer name', () {
      final noOrganizerName = readFileLines('no_organizer_name.ics');
      final iCalendar = ICalendar.fromLines(noOrganizerName);
      final organizer = iCalendar.data
          .firstWhere((e) => e.containsKey('organizer'))['organizer'];

      if (organizer is! Map<String, dynamic>) {
        fail('organizer is not a Map<String, dynamic>');
      }

      expect(organizer.containsKey('name'), false);
      expect(organizer['mail'], 'john.doe@example.com');
    });

    test('with categories', () {
      final withCategories = readFileLines('with_categories.ics');
      final iCalendar = ICalendar.fromLines(withCategories);
      final categories = iCalendar.data
          .firstWhere((e) => e.containsKey('categories'))['categories'];

      if (categories is! List<String>) {
        fail('categories is not a List<String>');
      }

      expect(categories.length, 2);
      expect(categories, ['APPOINTMENT', 'EDUCATION']);
    });

    test('with attendee', () {
      final withAttendee = readFileLines('with_attendee.ics');
      final iCalendar = ICalendar.fromLines(withAttendee);
      final attendees = iCalendar.data
          .firstWhere((e) => e.containsKey('attendee'))['attendee'];

      if (attendees is! List) {
        fail('attendees is not a List');
      }

      expect(attendees.length, 1);

      final attendee = attendees[0];

      if (attendee is! Map<String, dynamic>) {
        fail('attendee is not a Map<String, dynamic>');
      }

      expect(attendee['mail'], 'joecool@host2.com');
      expect(attendee['name'], 'Henry Cabot');
      expect(attendee['role'], 'REQ-PARTICIPANT');
    });

    test('with transp', () {
      final withTransp = readFileLines('with_transp.ics');
      final iCalendar = ICalendar.fromLines(withTransp);
      final transp =
          iCalendar.data.firstWhere((e) => e.containsKey('transp'))['transp'];
      expect(transp, IcsTransp.transparent);
    });

    test('with status', () {
      final withStatus = readFileLines('with_status.ics');
      final iCal = ICalendar.fromLines(withStatus);
      final status =
          iCal.data.firstWhere((e) => e.containsKey('status'))['status'];
      expect(status, IcsStatus.tentative);
    });

    test('with rrule', () {
      final withStatus = readFileLines('with_rrule.ics');
      final iCal = ICalendar.fromLines(withStatus);
      final rrule =
          iCal.data.firstWhere((e) => e.containsKey('rrule'))['rrule'];
      expect(rrule, "FREQ=WEEKLY;INTERVAL=2;BYDAY=TU,TH;BYMONTH=12");
    });

    test('with exdate', () {
      final withStatus = readFileLines('with_exdate.ics');
      final iCal = ICalendar.fromLines(withStatus);
      final exdate =
          iCal.data.firstWhere((e) => e.containsKey('exdate'))['exdate'];
      expect(exdate, [
        const IcsDateTime(dt: "20220415T145500", tzid: "Europe/Zurich"),
        const IcsDateTime(dt: "20220527T145500", tzid: "Europe/Zurich"),
        const IcsDateTime(dt: "20220422T145500", tzid: "Europe/Zurich"),
      ]);
    });
  });
}
