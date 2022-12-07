import 'package:icalendar_parser/src/exceptions/icalendar_exception.dart';

/// Enumeration of all transparency types.
///
/// See doc: https://www.kanzaki.com/docs/ical/transp.html
enum IcsTransp {
  opaque('OPAQUE'),
  transparent('TRANSPARENT');

  const IcsTransp(this.key);
  final String key;

  static IcsTransp fromString(String key) {
    final effectiveKey = key.toUpperCase();
    return IcsTransp.values.firstWhere(
      (e) => e.key == effectiveKey,
      orElse: () {
        throw ICalendarTranspParseException('Unknown IcsTransp: $key');
      },
    );
  }
}
