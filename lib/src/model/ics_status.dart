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

extension IcsStatusModifier on IcsStatus {
  String get string {
    switch (this) {
      case IcsStatus.tentative:
        return 'TENTATIVE';
      case IcsStatus.confirmed:
        return 'CONFIRMED';
      case IcsStatus.cancelled:
        return 'CANCELLED';
      case IcsStatus.needsAction:
        return 'NEEDS-ACTION';
      case IcsStatus.completed:
        return 'COMPLETED';
      case IcsStatus.inProcess:
        return 'IN-PROCESS';
      case IcsStatus.draft:
        return 'DRAFT';
      case IcsStatus.isFinal:
        return 'FINAL';
    }
  }
}
