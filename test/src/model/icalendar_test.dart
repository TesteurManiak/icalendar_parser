import 'dart:convert';

import 'package:icalendar_parser/src/model/icalendar.dart';
import 'package:test/test.dart';

import '../../test_utils.dart';

void main() {
  group('ICalendar', () {
    test('toString', () {
      final iCal = ICalendar.fromLines(readFileLines('created.ics'));
      final wantedJson = jsonEncode(jsonDecode(readFileString('created.json')));

      expect(iCal.toString(), wantedJson);
    });
  });
}
