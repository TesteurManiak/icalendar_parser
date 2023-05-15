import 'package:icalendar_parser/src/utils/extensions.dart';

/// https://icalendar.org/iCalendar-RFC-5545/3-8-1-7-location.html
class Location {
  const Location({
    required this.value,
    this.altRep,
    this.language,
  });

  final String? altRep;
  final String? language;
  final String value;

  @override
  String toString() {
    final buffer = StringBuffer();
    final paramsMap = <String, String>{};

    if (altRep case final altRep?) paramsMap['ALTREP'] = altRep;
    if (language case final language?) paramsMap['LANGUAGE'] = language;

    if (paramsMap.isNotEmpty) {
      buffer
        ..write(paramsMap.concatenateParams())
        ..write(':');
    }

    buffer.write(value);

    return buffer.toString();
  }
}
