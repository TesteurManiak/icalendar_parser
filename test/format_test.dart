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
    // final _validWithAlarm = readFileString('valid_with_alarm.ics');
    // final _noOrganizerName = readFileString('no_organizer_name.ics');
    // const _withCategories =
    //     'BEGIN:VCALENDAR\r\nVERSION:2.0\r\nPRODID:-//hacksw/handcal//NONSGML v1.0//EN\r\nCALSCALE:GREGORIAN\r\nMETHOD:PUBLISH\r\nBEGIN:VEVENT\r\nUID:uid1@example.com\r\nDTSTAMP:19970714T170000Z\r\nORGANIZER:MAILTO:john.doe@example.com\r\nCATEGORIES:APPOINTMENT,EDUCATION\r\nDTSTART:19970714T170000Z\r\nDTEND:19970715T035959Z\r\nSUMMARY:Bastille Day Party\r\nGEO:48.85299;2.36885\r\nEND:VEVENT\r\nEND:VCALENDAR';
    // const _withAttendee =
    //     'BEGIN:VCALENDAR\r\nVERSION:2.0\r\nPRODID:-//hacksw/handcal//NONSGML v1.0//EN\r\nCALSCALE:GREGORIAN\r\nMETHOD:PUBLISH\r\nBEGIN:VEVENT\r\nUID:uid1@example.com\r\nDTSTAMP:19970714T170000Z\r\nORGANIZER;CN=John Doe:MAILTO:john.doe@example.com\r\nATTENDEE;ROLE=REQ-PARTICIPANT;PARTSTAT=TENTATIVE;CN=Henry Cabot\n:MAILTO:joecool@host2.com\r\nDTSTART:19970714T170000Z\r\nDTEND:19970715T035959Z\r\nSUMMARY:Bastille Day Party\r\nGEO:48.85299;2.36885\r\nEND:VEVENT\r\nEND:VCALENDAR';
    // const _withTransp =
    //     'BEGIN:VCALENDAR\r\nVERSION:2.0\r\nPRODID:-//hacksw/handcal//NONSGML v1.0//EN\r\nCALSCALE:GREGORIAN\r\nMETHOD:PUBLISH\r\nBEGIN:VEVENT\r\nUID:uid1@example.com\r\nDTSTAMP:19970714T170000Z\r\nTRANSP:TRANSPARENT\r\nORGANIZER;CN=John Doe:MAILTO:john.doe@example.com\r\nDTSTART:19970714T170000Z\r\nDTEND:19970715T035959Z\r\nSUMMARY:Bastille Day Party\r\nGEO:48.85299;2.36885\r\nEND:VEVENT\r\nEND:VCALENDAR';
    // const _withStatus =
    //     'BEGIN:VCALENDAR\r\nVERSION:2.0\r\nPRODID:-//hacksw/handcal//NONSGML v1.0//EN\r\nCALSCALE:GREGORIAN\r\nMETHOD:PUBLISH\r\nBEGIN:VEVENT\r\nUID:uid1@example.com\r\nSTATUS:TENTATIVE\r\nDTSTAMP:19970714T170000Z\r\nORGANIZER;CN=John Doe:MAILTO:john.doe@example.com\r\nDTSTART:19970714T170000Z\r\nDTEND:19970715T035959Z\r\nSUMMARY:Bastille Day Party\r\nGEO:48.85299;2.36885\r\nEND:VEVENT\r\nEND:VCALENDAR';

    group('fromLines()', () {
      final _valid = readFileLines('valid.ics');
      final _validMultiline = readFileLines('valid_multiline.ics');

      test('base valid', () {
        expect(ICalendar.fromLines(_valid).data.length, 1);
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
    });

    // group('fromString()', () {
    //   test('base valid', () {
    //     expect(ICalendar.fromString(_valid).data.length, 1);
    //   });

    //   test('ending w/ newline: authorized empty line', () {
    //     final testString = '$_valid\r\n';
    //     expect(ICalendar.fromString(testString).data.length, 1);
    //   });

    //   test('ending w/ newline: unauthorized empty line', () {
    //     final testString = '$_valid\r\n';
    //     expect(() => ICalendar.fromString(testString, allowEmptyLine: false),
    //         throwsA(isA<ICalendarEndException>()));
    //   });

    //   test('parse TRIGGER', () {
    //     final iCalendar = ICalendar.fromString(_validWithAlarm);
    //     expect(iCalendar.data[1]['trigger'], '-PT1440M');
    //   });
    // });

    // group('Properties', () {
    //   final iCalendar = ICalendar.fromString(_valid);

    //   test('version', () {
    //     expect(iCalendar.version, '2.0');
    //   });

    //   test('prodid', () {
    //     expect(iCalendar.prodid, '-//hacksw/handcal//NONSGML v1.0//EN');
    //   });

    //   test('calscale', () {
    //     expect(iCalendar.calscale, 'GREGORIAN');
    //   });

    //   test('method', () {
    //     expect(iCalendar.method, 'PUBLISH');
    //   });
    // });

    // test('toString()', () {
    //   final iCal = ICalendar.fromString(_valid);
    //   final str = iCal.toString();
    //   expect(str.contains('iCalendar - VERSION: 2.0 - PRODID: '), true);
    // });

    // test('toJson()', () {
    //   final iCal = ICalendar.fromString(_valid);
    //   final json = iCal.toJson();
    //   expect(json['version'], '2.0');
    //   expect(json['prodid'], '-//hacksw/handcal//NONSGML v1.0//EN');
    //   expect(json['calscale'], 'GREGORIAN');
    //   expect(json['method'], 'PUBLISH');
    //   expect(json.containsKey('data'), true);
    // });

    // test('without organizer name', () {
    //   final iCalendar = ICalendar.fromString(_noOrganizerName);
    //   final Map<String, dynamic> organizer = iCalendar.data
    //           .firstWhere((e) => e.containsKey('organizer'))['organizer']
    //       as Map<String, dynamic>;
    //   expect(organizer.containsKey('name'), false);
    //   expect(organizer['mail'], 'john.doe@example.com');
    // });

    // test('with categories', () {
    //   final iCalendar = ICalendar.fromString(_withCategories);
    //   final List<String> categories = iCalendar.data
    //           .firstWhere((e) => e.containsKey('categories'))['categories']
    //       as List<String>;
    //   expect(categories.length, 2);
    //   expect(categories, ['APPOINTMENT', 'EDUCATION']);
    // });

    // test('with attendee', () {
    //   final iCalendar = ICalendar.fromString(_withAttendee);
    //   final List attendee = iCalendar.data
    //       .firstWhere((e) => e.containsKey('attendee'))['attendee'] as List;
    //   expect(attendee.length, 1);
    //   expect(attendee[0]['mail'], 'joecool@host2.com');
    //   expect(attendee[0]['name'], 'Henry Cabot');
    //   expect(attendee[0]['role'], 'REQ-PARTICIPANT');
    // });

    // test('with transp', () {
    //   final iCalendar = ICalendar.fromString(_withTransp);
    //   final transp =
    //       iCalendar.data.firstWhere((e) => e.containsKey('transp'))['transp'];
    //   expect(transp, IcsTransp.transparent);
    // });

    // test('with status', () {
    //   final iCal = ICalendar.fromString(_withStatus);
    //   final status =
    //       iCal.data.firstWhere((e) => e.containsKey('status'))['status'];
    //   expect(status, IcsStatus.tentative);
    // });
  });
}
