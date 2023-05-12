import 'package:icalendar_parser/src/components/ical_component.dart';
import 'package:icalendar_parser/src/utils/extensions.dart';

/// See doc: https://icalendar.org/iCalendar-RFC-5545/3-6-1-event-component.html
class VEvent extends ICalComponent {
  VEvent() : super('VEVENT');

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
    }.toValidMap();
  }
}
