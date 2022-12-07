import 'package:icalendar_parser/src/exceptions/icalendar_exception.dart';

/// Enumeration of all event statuses.
///
/// See doc: https://www.kanzaki.com/docs/ical/status.html
enum IcsStatus {
  tentative('TENTATIVE'),
  confirmed('CONFIRMED'),
  cancelled('CANCELLED'),
  needsAction('NEEDS-ACTION'),
  completed('COMPLETED'),
  inProcess('IN-PROCESS'),
  draft('DRAFT'),
  isFinal('FINAL');

  const IcsStatus(this.key);
  final String key;

  static IcsStatus fromString(String key) {
    final effectiveKey = key.toUpperCase();
    return IcsStatus.values.firstWhere(
      (e) => e.key == effectiveKey,
      orElse: () {
        throw ICalendarStatusParseException('Unknown IcsStatus: $key');
      },
    );
  }
}
