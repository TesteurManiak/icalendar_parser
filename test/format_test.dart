import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:icalendar_parser/src/exceptions/icalendar_exception.dart';
import 'package:test/test.dart';

void main() {
  final _valid =
      'BEGIN:VCALENDAR\nVERSION:2.0\nPRODID:-//hacksw/handcal//NONSGML v1.0//EN\nBEGIN:VEVENT\nUID:uid1@example.com\nDTSTAMP:19970714T170000Z\nORGANIZER;CN=John Doe:MAILTO:john.doe@example.com\nDTSTART:19970714T170000Z\nDTEND:19970715T035959Z\nSUMMARY:Bastille Day Party\nGEO:48.85299;2.36885\nEND:VEVENT\nEND:VCALENDAR';
  final _noCalendarBegin =
      'VERSION:2.0\nPRODID:-//hacksw/handcal//NONSGML v1.0//EN\nBEGIN:VEVENT\nUID:uid1@example.com\nDTSTAMP:19970714T170000Z\nORGANIZER;CN=John Doe:MAILTO:john.doe@example.com\nDTSTART:19970714T170000Z\nDTEND:19970715T035959Z\nSUMMARY:Bastille Day Party\nGEO:48.85299;2.36885\nEND:VEVENT\nEND:VCALENDAR';
  final _noCalendarEnd =
      'BEGIN:VCALENDAR\nVERSION:2.0\nPRODID:-//hacksw/handcal//NONSGML v1.0//EN\nBEGIN:VEVENT\nUID:uid1@example.com\nDTSTAMP:19970714T170000Z\nORGANIZER;CN=John Doe:MAILTO:john.doe@example.com\nDTSTART:19970714T170000Z\nDTEND:19970715T035959Z\nSUMMARY:Bastille Day Party\nGEO:48.85299;2.36885\nEND:VEVENT';

  test('Missing BEGIN:VCALENDAR', () {
    final lines = _noCalendarBegin.split('\n');
    expect(() => ICalendar.fromLines(lines),
        throwsA(isA<ICalendarBeginException>()));
  });

  test('Missing END:VCALENDAR', () {
    final lines = _noCalendarEnd.split('\n');
    expect(() => ICalendar.fromLines(lines),
        throwsA(isA<ICalendarEndException>()));
  });

  test('Valid calendar', () {
    final lines = _valid.split('\n');
    expect(ICalendar.fromLines(lines).data.length, 1);
  });

  test('Valid calendar ending w/ newline: authorized empty line', () {
    final lines = (_valid + '\n').split('\n');
    expect(ICalendar.fromLines(lines).data.length, 1);
  });

  test('Valid calendar ending w/ newline: unauthorized empty line', () {
    final lines = (_valid + '\n').split('\n');
    expect(() => ICalendar.fromLines(lines, allowEmptyLine: false),
        throwsA(isA<ICalendarEndException>()));
  });
}
