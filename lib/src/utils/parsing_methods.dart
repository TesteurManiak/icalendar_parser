import 'package:icalendar_parser/src/model/ics_datetime.dart';

Function(String, Map<String, String>, List, Map<String, dynamic>)
    generateDateFunction(String name) {
  return (
    String value,
    Map<String, String> params,
    List events,
    Map<String, dynamic> lastEvent,
  ) {
    lastEvent[name] = IcsDateTime(dt: value, tzid: params['TZID']);
    return lastEvent;
  };
}

/// Generate a method that return the [lastEvent] with a new entry at [name]
/// containing the [value] as [String].
Function(String, Map<String, String>, List, Map<String, dynamic>)
    generateSimpleParamFunction(String name) {
  return (
    String value,
    Map<String, String> params,
    List events,
    Map<String, dynamic> lastEvent,
  ) {
    lastEvent[name] = value.replaceAll(RegExp(r'/\\n/g'), '\n');
    return lastEvent;
  };
}
