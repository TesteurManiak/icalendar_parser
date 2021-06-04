import 'package:collection/collection.dart' show IterableExtension;
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:icalendar_parser/src/model/ics_datetime.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  test('Missing elements', () {
    expect(() => ICalendar.fromLines(readFileLines('no_begin.ics')),
        throwsA(isA<ICalendarBeginException>()));

    expect(() => ICalendar.fromLines(readFileLines('no_end.ics')),
        throwsA(isA<ICalendarFormatException>()));

    expect(() => ICalendar.fromLines(readFileLines('no_version.ics')),
        throwsA(isA<ICalendarNoVersionException>()));
  });

  group('Register fields', () {
    test('test field - default method', () {
      final _valid = readFileLines('valid_with_custom_field.ics');

      ICalendar.registerField(field: 'TEST');
      expect(ICalendar.objects.containsKey('TEST'), true);

      final obj = ICalendar.fromLines(_valid);
      final entry = obj.data.firstWhereOrNull((e) => e.containsKey('test'))!;
      expect(entry, isNotNull);
      expect(entry['test'], 'This is a test content');
    });

    test('test2 field - custom method', () {
      final _valid = readFileLines('valid_with_custom_field_2.ics');

      ICalendar.registerField(
        field: 'TEST2',
        function: (value, params, event, lastEvent) {
          lastEvent['test2'] = 'test';
          return lastEvent;
        },
      );
      expect(ICalendar.objects.containsKey('TEST2'), true);

      final obj = ICalendar.fromLines(_valid);
      final entry = obj.data.firstWhereOrNull((e) => e.containsKey('test2'))!;
      expect(entry, isNotNull);
      expect(entry['test2'], 'test');
    });

    test('unregister field', () {
      ICalendar.unregisterField('TEST');
      expect(ICalendar.objects.containsKey('TEST'), false);
    });

    test(
        'Multiple line DESCRIPTION containing colon should not loose line of text',
        () async {
      final eventText =
          readFileLines('MultiLineDescriptionContainingColon.ics');
      final iCalParsed = ICalendar.fromLines(eventText);
      expect(
        iCalParsed.data[3]['description'],
        equals(
          r'Voorbereiden: 1.5.1 Speekselklieren: tekening benoemen op p. 60\n\n+\n\n1.6 Bouw van endocriene secretieklieren en aanpassing aan hun functie: tekening p. 63 --> benoem de aangeduide delen.',
        ),
      );
    });

    test('American History', () async {
      final eventText = readFileLines('american_history.ics');
      final iCalParsed = ICalendar.fromLines(eventText);
      expect(
          iCalParsed.data[2]['url'],
          equals(
              'https://americanhistorycalendar.com/eventscalendar/2,1853-emancipation-proclamation'));
    });
  });

  group('IcsDateTime', () {
    final dateTimeParsing1 = readFileLines('datetime_parsing.ics');

    test('test 1', () {
      final obj = ICalendar.fromLines(dateTimeParsing1);
      expect(obj.data.isNotEmpty, true);

      final dtstart = obj.data.first['dtstart'] as IcsDateTime;
      expect(dtstart.dt, '20210607T090000');
      expect(dtstart.tzid, 'Europe/Berlin');
      expect(dtstart.toDateTime(), isNotNull);
    });
  });
}
