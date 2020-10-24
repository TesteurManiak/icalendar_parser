import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:icalendar_parser/src/exceptions/icalendar_exception.dart';
import 'package:test/test.dart';

main() {
  final _valid =
      'BEGIN:VCALENDAR\nVERSION:2.0\nPRODID:-//hacksw/handcal//NONSGML v1.0//EN\nBEGIN:VEVENT\nUID:uid1@example.com\nDTSTAMP:19970714T170000Z\nORGANIZER;CN=John Doe:MAILTO:john.doe@example.com\nDTSTART:19970714T170000Z\nDTEND:19970715T035959Z\nSUMMARY:Bastille Day Party\nGEO:48.85299;2.36885\nEND:VEVENT\nEND:VCALENDAR';
  final _noCalendarBegin =
      'VERSION:2.0\nPRODID:-//hacksw/handcal//NONSGML v1.0//EN\nBEGIN:VEVENT\nUID:uid1@example.com\nDTSTAMP:19970714T170000Z\nORGANIZER;CN=John Doe:MAILTO:john.doe@example.com\nDTSTART:19970714T170000Z\nDTEND:19970715T035959Z\nSUMMARY:Bastille Day Party\nGEO:48.85299;2.36885\nEND:VEVENT\nEND:VCALENDAR';
  final _noCalendarEnd =
      'BEGIN:VCALENDAR\nVERSION:2.0\nPRODID:-//hacksw/handcal//NONSGML v1.0//EN\nBEGIN:VEVENT\nUID:uid1@example.com\nDTSTAMP:19970714T170000Z\nORGANIZER;CN=John Doe:MAILTO:john.doe@example.com\nDTSTART:19970714T170000Z\nDTEND:19970715T035959Z\nSUMMARY:Bastille Day Party\nGEO:48.85299;2.36885\nEND:VEVENT';

  test('Missing BEGIN:VCALENDAR', () {
    expect(() => ICalendar.fromString(_noCalendarBegin),
        throwsA(isA<ICalendarBeginException>()));
  });

  test('Missing END:VCALENDAR', () {
    expect(() => ICalendar.fromString(_noCalendarEnd),
        throwsA(isA<ICalendarEndException>()));
  });

  test('Valid calendar', () {
    expect(ICalendar.fromString(_valid).data.length, 1);
  });

  test('Valid calendar ending w/ newline: authorized empty line', () {
    expect(ICalendar.fromString(_valid + '\n').data.length, 1);
  });

  test('Valid calendar ending w/ newline: unauthorized empty line', () {
    expect(() => ICalendar.fromString(_valid + '\n', allowEmptyLine: false),
        throwsA(isA<ICalendarEndException>()));
  });
}
