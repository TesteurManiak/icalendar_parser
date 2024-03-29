import 'package:collection/collection.dart' show IterableExtension;
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  group('Missing elements', () {
    test('no begin', () {
      expect(
        () => ICalendar.fromLines(readFileLines('no_begin.ics')),
        throwsA(isA<ICalendarBeginException>()),
      );
    });

    test('no end', () {
      expect(
        () => ICalendar.fromLines(readFileLines('no_end.ics')),
        throwsA(isA<ICalendarFormatException>()),
      );
    });

    test('no version', () {
      expect(
        () => ICalendar.fromLines(readFileLines('no_version.ics')),
        throwsA(isA<ICalendarNoVersionException>()),
      );
    });
  });

  group('fromString', () {
    test('valid file', () {
      final dtFile = readFileString('datetime_parsing.ics');
      ICalendar.fromString(dtFile);
    });
  });

  group('Register fields', () {
    test('test field - default method', () {
      final valid = readFileLines('valid_with_custom_field.ics');

      ICalendar.registerField(field: 'TEST');
      expect(ICalendar.objects.containsKey('TEST'), true);

      final obj = ICalendar.fromLines(valid);
      final entry = obj.data.firstWhereOrNull((e) => e.containsKey('test'));

      expect(entry, isNotNull);
      expect(entry?['test'], 'This is a test content');
    });

    test('test2 field - custom method', () {
      final valid = readFileLines('valid_with_custom_field_2.ics');

      ICalendar.registerField(
        field: 'TEST2',
        function: (value, params, event, lastEvent) {
          lastEvent['test2'] = 'test';
          return lastEvent;
        },
      );
      expect(ICalendar.objects.containsKey('TEST2'), true);

      final obj = ICalendar.fromLines(valid);
      final entry = obj.data.firstWhereOrNull((e) => e.containsKey('test2'));

      expect(entry, isNotNull);
      expect(entry?['test2'], 'test');
    });

    test('already registered field', () {
      expect(ICalendar.objects.containsKey('TEST'), true);
      expect(
        () => ICalendar.registerField(field: 'TEST'),
        throwsA(isA<ICalendarFormatException>()),
      );
    });

    test('unregister field', () {
      expect(ICalendar.objects.containsKey('TEST'), true);
      ICalendar.unregisterField('TEST');
      expect(ICalendar.objects.containsKey('TEST'), false);
    });

    test('unregister non existing field', () {
      expect(ICalendar.objects.containsKey('TEST'), false);
      expect(
        () => ICalendar.unregisterField('TEST'),
        throwsA(isA<ICalendarFormatException>()),
      );
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

    test('American History', () {
      final eventText = readFileLines('american_history.ics');
      final iCalParsed = ICalendar.fromLines(eventText);
      expect(
        iCalParsed.data[2]['url'],
        equals(
          'https://americanhistorycalendar.com/eventscalendar/2,1853-emancipation-proclamation',
        ),
      );
    });
  });

  group('IcsDateTime', () {
    test('fromLines', () {
      final dtFile = readFileLines('datetime_parsing.ics');
      final obj = ICalendar.fromLines(dtFile);
      expect(obj.data.isNotEmpty, true);

      final dtstart = obj.data.first['dtstart'];
      if (dtstart is! IcsDateTime) {
        fail('dtstart is not IcsDateTime');
      }

      expect(dtstart.dt, '20210607T090000');
      expect(dtstart.tzid, 'Europe/Berlin');
      expect(dtstart.toDateTime(), isNotNull);
    });
  });
}
