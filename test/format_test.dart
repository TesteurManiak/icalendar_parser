import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:icalendar_parser/src/exceptions/icalendar_exception.dart';
import 'package:test/test.dart';

void main() {
  final _noCalendarBegin =
      'VERSION:2.0\r\nPRODID:-//hacksw/handcal//NONSGML v1.0//EN\r\nBEGIN:VEVENT\r\nUID:uid1@example.com\r\nDTSTAMP:19970714T170000Z\r\nORGANIZER;CN=John Doe:MAILTO:john.doe@example.com\r\nDTSTART:19970714T170000Z\r\nDTEND:19970715T035959Z\r\nSUMMARY:Bastille Day Party\r\nGEO:48.85299;2.36885\r\nEND:VEVENT\r\nEND:VCALENDAR';
  final _noCalendarEnd =
      'BEGIN:VCALENDAR\r\nVERSION:2.0\r\nPRODID:-//hacksw/handcal//NONSGML v1.0//EN\r\nBEGIN:VEVENT\r\nUID:uid1@example.com\r\nDTSTAMP:19970714T170000Z\r\nORGANIZER;CN=John Doe:MAILTO:john.doe@example.com\r\nDTSTART:19970714T170000Z\r\nDTEND:19970715T035959Z\r\nSUMMARY:Bastille Day Party\r\nGEO:48.85299;2.36885\r\nEND:VEVENT';
  final _noVersion =
      'BEGIN:VCALENDAR\r\nPRODID:-//hacksw/handcal//NONSGML v1.0//EN\r\nBEGIN:VEVENT\r\nUID:uid1@example.com\r\nDTSTAMP:19970714T170000Z\r\nORGANIZER;CN=John Doe:MAILTO:john.doe@example.com\r\nDTSTART:19970714T170000Z\r\nDTEND:19970715T035959Z\r\nSUMMARY:Bastille Day Party\r\nGEO:48.85299;2.36885\r\nEND:VEVENT\r\nEND:VCALENDAR';
  final _noProdid =
      'BEGIN:VCALENDAR\r\nVERSION:2.0\r\nBEGIN:VEVENT\r\nUID:uid1@example.com\r\nDTSTAMP:19970714T170000Z\r\nORGANIZER;CN=John Doe:MAILTO:john.doe@example.com\r\nDTSTART:19970714T170000Z\r\nDTEND:19970715T035959Z\r\nSUMMARY:Bastille Day Party\r\nGEO:48.85299;2.36885\r\nEND:VEVENT\r\nEND:VCALENDAR';

  test('Missing BEGIN:VCALENDAR', () {
    final lines = _noCalendarBegin.split('\r\n');
    expect(() => ICalendar.fromLines(lines),
        throwsA(isA<ICalendarBeginException>()));
    expect(() => ICalendar.fromString(_noCalendarBegin),
        throwsA(isA<ICalendarBeginException>()));
  });

  test('Missing END:VCALENDAR', () {
    final lines = _noCalendarEnd.split('\r\n');
    expect(() => ICalendar.fromLines(lines),
        throwsA(isA<ICalendarEndException>()));
    expect(() => ICalendar.fromString(_noCalendarEnd),
        throwsA(isA<ICalendarEndException>()));
  });

  test('Missing VERSION', () {
    final lines = _noVersion.split('\r\n');
    expect(() => ICalendar.fromLines(lines),
        throwsA(isA<ICalendarNoVersionException>()));
    expect(() => ICalendar.fromString(_noVersion),
        throwsA(isA<ICalendarNoVersionException>()));
  });

  test('Missing PRODID', () {
    final lines = _noProdid.split('\r\n');
    expect(() => ICalendar.fromLines(lines),
        throwsA(isA<ICalendarNoProdidException>()));
    expect(() => ICalendar.fromString(_noProdid),
        throwsA(isA<ICalendarNoProdidException>()));
  });

  group('Valid calendar', () {
    final _valid =
        'BEGIN:VCALENDAR\r\nVERSION:2.0\r\nPRODID:-//hacksw/handcal//NONSGML v1.0//EN\r\nCALSCALE:GREGORIAN\r\nMETHOD:PUBLISH\r\nBEGIN:VEVENT\r\nUID:uid1@example.com\r\nDTSTAMP:19970714T170000Z\r\nORGANIZER;CN=John Doe:MAILTO:john.doe@example.com\r\nDTSTART:19970714T170000Z\r\nDTEND:19970715T035959Z\r\nSUMMARY:Bastille Day Party\r\nGEO:48.85299;2.36885\r\nEND:VEVENT\r\nEND:VCALENDAR';
    final _validMultiline =
        'BEGIN:VCALENDAR\r\nVERSION:2.0\r\nPRODID:-//hacksw/handcal//NONSGML v1.0//EN\r\nBEGIN:VEVENT\r\nUID:uid1@example.com\r\nDTSTAMP:19970714T170000Z\r\nORGANIZER;CN=John Doe:MAILTO:john.doe@example.com\r\nDTSTART:19970714T170000Z\r\nDTEND:19970715T035959Z\r\nSUMMARY:Bastille Day Party\r\nDESCRIPTION:Lorem ipsum dolor sit amet, consectetur adipiscing elit.\nSed suscipit malesuada sodales.\nUt viverra metus neque, ut ullamcorper felis fermentum vel.\nSed sodales mauris nec.\r\nGEO:48.85299;2.36885\r\nEND:VEVENT\r\nEND:VCALENDAR';
    final _validWithAlarm =
        'BEGIN:VCALENDAR\r\nVERSION:2.0\r\nPRODID:-//hacksw/handcal//NONSGML v1.0//EN\r\nBEGIN:VEVENT\r\nUID:uid1@example.com\r\nDTSTAMP:19970714T170000Z\r\nORGANIZER;CN=John Doe:MAILTO:john.doe@example.com\r\nDTSTART:19970714T170000Z\r\nDTEND:19970715T035959Z\r\nSUMMARY:Bastille Day Party\r\nGEO:48.85299;2.36885\r\nEND:VEVENT\r\nBEGIN:VALARM\r\nTRIGGER:-PT1440M\r\nACTION:DISPLAY\r\nDESCRIPTION:Reminder\r\nEND:VALARM\r\nEND:VCALENDAR';
    final _noOrganizerName =
        'BEGIN:VCALENDAR\r\nVERSION:2.0\r\nPRODID:-//hacksw/handcal//NONSGML v1.0//EN\r\nCALSCALE:GREGORIAN\r\nMETHOD:PUBLISH\r\nBEGIN:VEVENT\r\nUID:uid1@example.com\r\nDTSTAMP:19970714T170000Z\r\nORGANIZER:MAILTO:john.doe@example.com\r\nDTSTART:19970714T170000Z\r\nDTEND:19970715T035959Z\r\nSUMMARY:Bastille Day Party\r\nGEO:48.85299;2.36885\r\nEND:VEVENT\r\nEND:VCALENDAR';
    final _withCategories =
        'BEGIN:VCALENDAR\r\nVERSION:2.0\r\nPRODID:-//hacksw/handcal//NONSGML v1.0//EN\r\nCALSCALE:GREGORIAN\r\nMETHOD:PUBLISH\r\nBEGIN:VEVENT\r\nUID:uid1@example.com\r\nDTSTAMP:19970714T170000Z\r\nORGANIZER:MAILTO:john.doe@example.com\r\nCATEGORIES:APPOINTMENT,EDUCATION\r\nDTSTART:19970714T170000Z\r\nDTEND:19970715T035959Z\r\nSUMMARY:Bastille Day Party\r\nGEO:48.85299;2.36885\r\nEND:VEVENT\r\nEND:VCALENDAR';
    final _withAttendee =
        'BEGIN:VCALENDAR\r\nVERSION:2.0\r\nPRODID:-//hacksw/handcal//NONSGML v1.0//EN\r\nCALSCALE:GREGORIAN\r\nMETHOD:PUBLISH\r\nBEGIN:VEVENT\r\nUID:uid1@example.com\r\nDTSTAMP:19970714T170000Z\r\nORGANIZER;CN=John Doe:MAILTO:john.doe@example.com\r\nATTENDEE;ROLE=REQ-PARTICIPANT;PARTSTAT=TENTATIVE;CN=Henry Cabot\n:MAILTO:joecool@host2.com\r\nDTSTART:19970714T170000Z\r\nDTEND:19970715T035959Z\r\nSUMMARY:Bastille Day Party\r\nGEO:48.85299;2.36885\r\nEND:VEVENT\r\nEND:VCALENDAR';

    group('fromLines()', () {
      test('base valid', () {
        final lines = _valid.split('\r\n');
        expect(ICalendar.fromLines(lines).data.length, 1);
      });

      test('ending w/ newline: authorized empty line', () {
        final testString = _valid + '\r\n';
        final lines = testString.split('\r\n');
        expect(ICalendar.fromLines(lines).data.length, 1);
      });

      test('ending w/ newline: unauthorized empty line', () {
        final testString = _valid + '\r\n';
        final lines = testString.split('\r\n');
        expect(() => ICalendar.fromLines(lines, allowEmptyLine: false),
            throwsA(isA<ICalendarEndException>()));
      });

      test('w/ multiline description', () {
        final lines = _validMultiline.split('\r\n');
        final iCalendarLines = ICalendar.fromLines(lines);
        expect(
            (iCalendarLines.data.first['description'] as String).length, 172);
      });
    });

    group('fromString()', () {
      test('base valid', () {
        expect(ICalendar.fromString(_valid).data.length, 1);
      });

      test('ending w/ newline: authorized empty line', () {
        final testString = _valid + '\r\n';
        expect(ICalendar.fromString(testString).data.length, 1);
      });

      test('ending w/ newline: unauthorized empty line', () {
        final testString = _valid + '\r\n';
        expect(() => ICalendar.fromString(testString, allowEmptyLine: false),
            throwsA(isA<ICalendarEndException>()));
      });

      test('w/ multiline description', () {
        final iCalendarString = ICalendar.fromString(_validMultiline);
        expect(
            (iCalendarString.data.first['description'] as String).length, 172);
      });

      test('parse TRIGGER', () {
        final iCalendar = ICalendar.fromString(_validWithAlarm);
        expect(iCalendar.data[1]['trigger'], '-PT1440M');
      });
    });

    group('Properties', () {
      final iCalendar = ICalendar.fromString(_valid);

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

    test('without organizer name', () {
      final iCalendar = ICalendar.fromString(_noOrganizerName);
      final Map<String, dynamic> organizer = iCalendar.data
          .firstWhere((e) => e.containsKey('organizer'))['organizer'];
      expect(organizer.containsKey('name'), false);
      expect(organizer['mail'], 'john.doe@example.com');
    });

    test('with categories', () {
      final iCalendar = ICalendar.fromString(_withCategories);
      final List<String> categories = iCalendar.data
          .firstWhere((e) => e.containsKey('categories'))['categories'];
      expect(categories.length, 2);
      expect(categories, ['APPOINTMENT', 'EDUCATION']);
    });

    test('with attendee', () {
      final iCalendar = ICalendar.fromString(_withAttendee);
      final List attendee = iCalendar.data
          .firstWhere((e) => e.containsKey('attendee'))['attendee'];
      expect(attendee.length, 1);
    });
  });
}
