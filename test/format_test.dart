import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:icalendar_parser/src/exceptions/icalendar_exception.dart';
import 'package:test/test.dart';

void main() {
  final _valid =
      'BEGIN:VCALENDAR\r\nVERSION:2.0\r\nPRODID:-//hacksw/handcal//NONSGML v1.0//EN\r\nBEGIN:VEVENT\r\nUID:uid1@example.com\r\nDTSTAMP:19970714T170000Z\r\nORGANIZER;CN=John Doe:MAILTO:john.doe@example.com\r\nDTSTART:19970714T170000Z\r\nDTEND:19970715T035959Z\r\nSUMMARY:Bastille Day Party\r\nGEO:48.85299;2.36885\r\nEND:VEVENT\r\nEND:VCALENDAR';
  final _noCalendarBegin =
      'VERSION:2.0\r\nPRODID:-//hacksw/handcal//NONSGML v1.0//EN\r\nBEGIN:VEVENT\r\nUID:uid1@example.com\r\nDTSTAMP:19970714T170000Z\r\nORGANIZER;CN=John Doe:MAILTO:john.doe@example.com\r\nDTSTART:19970714T170000Z\r\nDTEND:19970715T035959Z\r\nSUMMARY:Bastille Day Party\r\nGEO:48.85299;2.36885\r\nEND:VEVENT\r\nEND:VCALENDAR';
  final _noCalendarEnd =
      'BEGIN:VCALENDAR\r\nVERSION:2.0\r\nPRODID:-//hacksw/handcal//NONSGML v1.0//EN\r\nBEGIN:VEVENT\r\nUID:uid1@example.com\r\nDTSTAMP:19970714T170000Z\r\nORGANIZER;CN=John Doe:MAILTO:john.doe@example.com\r\nDTSTART:19970714T170000Z\r\nDTEND:19970715T035959Z\r\nSUMMARY:Bastille Day Party\r\nGEO:48.85299;2.36885\r\nEND:VEVENT';
  final _validMultiline =
      'BEGIN:VCALENDAR\r\nVERSION:2.0\r\nPRODID:-//hacksw/handcal//NONSGML v1.0//EN\r\nBEGIN:VEVENT\r\nUID:uid1@example.com\r\nDTSTAMP:19970714T170000Z\r\nORGANIZER;CN=John Doe:MAILTO:john.doe@example.com\r\nDTSTART:19970714T170000Z\r\nDTEND:19970715T035959Z\r\nSUMMARY:Bastille Day Party\r\nDESCRIPTION:Lorem ipsum dolor sit amet, consectetur adipiscing elit.\nSed suscipit malesuada sodales.\nUt viverra metus neque, ut ullamcorper felis fermentum vel.\nSed sodales mauris nec.\r\nGEO:48.85299;2.36885\r\nEND:VEVENT\r\nEND:VCALENDAR';
  final _validWithAlarm =
      'BEGIN:VCALENDAR\r\nVERSION:2.0\r\nPRODID:-//hacksw/handcal//NONSGML v1.0//EN\r\nBEGIN:VEVENT\r\nUID:uid1@example.com\r\nDTSTAMP:19970714T170000Z\r\nORGANIZER;CN=John Doe:MAILTO:john.doe@example.com\r\nDTSTART:19970714T170000Z\r\nDTEND:19970715T035959Z\r\nSUMMARY:Bastille Day Party\r\nGEO:48.85299;2.36885\r\nEND:VEVENT\r\nBEGIN:VALARM\r\nTRIGGER:-PT1440M\r\nACTION:DISPLAY\r\nDESCRIPTION:Reminder\r\nEND:VALARM\r\nEND:VCALENDAR';

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

  test('Valid calendar', () {
    final lines = _valid.split('\r\n');
    expect(ICalendar.fromLines(lines).data.length, 1);
    expect(ICalendar.fromString(_valid).data.length, 1);
  });

  test('Valid calendar ending w/ newline: authorized empty line', () {
    final testString = _valid + '\r\n';
    final lines = testString.split('\r\n');
    expect(ICalendar.fromLines(lines).data.length, 1);
    expect(ICalendar.fromString(testString).data.length, 1);
  });

  test('Valid calendar ending w/ newline: unauthorized empty line', () {
    final testString = _valid + '\r\n';
    final lines = testString.split('\r\n');
    expect(() => ICalendar.fromLines(lines, allowEmptyLine: false),
        throwsA(isA<ICalendarEndException>()));
    expect(() => ICalendar.fromString(testString, allowEmptyLine: false),
        throwsA(isA<ICalendarEndException>()));
  });

  test('Valid calendar w/ multiline description', () {
    final iCalendarString = ICalendar.fromString(_validMultiline);
    expect((iCalendarString.data.first['description'] as String).length, 172);

    final lines = _validMultiline.split('\r\n');
    final iCalendarLines = ICalendar.fromLines(lines);
    expect((iCalendarLines.data.first['description'] as String).length, 172);
  });

  test('Valid calendar parse TRIGGER', () {
    final iCalendar = ICalendar.fromString(_validWithAlarm);
    print(iCalendar.data[1]);
    expect(iCalendar.data[1]['trigger'], '-PT1440M');
  });
}
