import 'package:icalendar_parser/src/utils/extensions.dart';

/// https://icalendar.org/iCalendar-RFC-5545/3-8-1-7-location.html
class Location {
  const Location({
    required this.value,
    this.altRep,
    this.language,
  });

  factory Location.parse(String str) {
    // - Conference Room - F123\, Bldg. 002
    // - ALTREP="http://xyzcorp.com/conf-rooms/f123.vcf":Conference Room - F123\, Bldg. 002
    // - LANGUAGE=en:Conference Room - F123\, Bldg. 002

    final params = <String, String>{};
    final parts = str.splitLast(':');
    final value = parts.last;

    if (parts.first != value) {
      final paramParts = parts.first.split(';');
      for (final part in paramParts) {
        final param = part.splitFirst('=');
        params[param[0].toUpperCase()] = param[1];
      }
    }

    return Location(
      value: value,
      altRep: params['ALTREP'],
      language: params['LANGUAGE'],
    );
  }

  final String? altRep;
  final String? language;
  final String value;

  static Location? tryParse(String? str) {
    if (str == null) return null;
    try {
      return Location.parse(str);
    } catch (_) {
      return null;
    }
  }

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
