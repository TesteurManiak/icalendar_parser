import 'dart:io';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:test/test.dart';

void main() {
  String fixture(String name) => File('test/fixtures/$name').readAsStringSync();

  group('Missing elements', () {
    final noBeginFile = File('test_resources/no_begin.ics');
    final noEndFile = File('test_resources/no_end.ics');
    final noVersionFile = File('test_resources/no_version.ics');

    test('Missing BEGIN:VCALENDAR', () {
      expect(() async => ICalendar.fromLines(await noBeginFile.readAsLines()),
          throwsA(isA<ICalendarBeginException>()));
      expect(() async => ICalendar.fromString(await noBeginFile.readAsString()),
          throwsA(isA<ICalendarBeginException>()));
    });

    test('Missing END:VCALENDAR', () {
      expect(() async => ICalendar.fromLines(await noEndFile.readAsLines()),
          throwsA(isA<ICalendarEndException>()));
      expect(() async => ICalendar.fromString(await noEndFile.readAsString()),
          throwsA(isA<ICalendarEndException>()));
    });

    test('Missing VERSION', () {
      expect(() async => ICalendar.fromLines(await noVersionFile.readAsLines()),
          throwsA(isA<ICalendarNoVersionException>()));
      expect(
          () async => ICalendar.fromString(await noVersionFile.readAsString()),
          throwsA(isA<ICalendarNoVersionException>()));
    });
  });

  group('Register fields', () {
    test('test field - default method', () {
      final _valid =
          'BEGIN:VCALENDAR\r\nVERSION:2.0\r\nPRODID:-//hacksw/handcal//NONSGML v1.0//EN\r\nCALSCALE:GREGORIAN\r\nMETHOD:PUBLISH\r\nBEGIN:VEVENT\r\nUID:uid1@example.com\r\nDTSTAMP:19970714T170000Z\r\nORGANIZER;CN=John Doe:MAILTO:john.doe@example.com\r\nTEST:This is a test content\r\nDTSTART:19970714T170000Z\r\nDTEND:19970715T035959Z\r\nSUMMARY:Bastille Day Party\r\nGEO:48.85299;2.36885\r\nEND:VEVENT\r\nEND:VCALENDAR';

      ICalendar.registerField(field: 'TEST');
      expect(ICalendar.objects.containsKey('TEST'), true);

      final obj = ICalendar.fromString(_valid);
      final entry =
          obj.data!.firstWhereOrNull((e) => e.containsKey('test'))!;
      expect(entry, isNotNull);
      expect(entry['test'], 'This is a test content');
    });

    test('test2 field - custom method', () {
      final _valid =
          'BEGIN:VCALENDAR\r\nVERSION:2.0\r\nPRODID:-//hacksw/handcal//NONSGML v1.0//EN\r\nCALSCALE:GREGORIAN\r\nMETHOD:PUBLISH\r\nBEGIN:VEVENT\r\nUID:uid1@example.com\r\nDTSTAMP:19970714T170000Z\r\nORGANIZER;CN=John Doe:MAILTO:john.doe@example.com\r\nTEST2:This is a test content\r\nDTSTART:19970714T170000Z\r\nDTEND:19970715T035959Z\r\nSUMMARY:Bastille Day Party\r\nGEO:48.85299;2.36885\r\nEND:VEVENT\r\nEND:VCALENDAR';

      ICalendar.registerField(
        field: 'TEST2',
        function: (value, params, event, lastEvent) {
          lastEvent['test2'] = 'test';
          return lastEvent;
        },
      );
      expect(ICalendar.objects.containsKey('TEST2'), true);

      final obj = ICalendar.fromString(_valid);
      final entry = obj.data!
          .firstWhereOrNull((e) => e.containsKey('test2'))!;
      expect(entry, isNotNull);
      expect(entry['test2'], 'test');
    });

    test('unregister field', () {
      ICalendar.unregisterField('TEST');
      expect(ICalendar.objects.containsKey('TEST'), false);
    });

    test('Multiple line DESCRIPTION containing colon should not loose line of text', () async {
      final eventText = fixture('MultiLineDescriptionContainingColon.txt');
      final iCalParsed = ICalendar.fromString(eventText);
      expect(iCalParsed.data?[3]['description'], equals(r'Voorbereiden: 1.5.1 Speekselklieren: tekening benoemen op p. 60\n\n+\n\n1.6 Bouw van endocriene secretieklieren en aanpassing aan hun functie: tekening p. 63 --> benoem de aangeduide delen.'));

    }
    );
  });
}
