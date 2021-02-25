import 'package:icalendar_parser/src/exceptions/icalendar_exception.dart';
import 'package:test/test.dart';

void main() {
  group('ICalendarFormatException', () {
    test('toString()', () {
      final e = const ICalendarFormatException('Test error');
      expect(e.toString(), 'ICalendarFormatException: Test error');
    });
  });
}
