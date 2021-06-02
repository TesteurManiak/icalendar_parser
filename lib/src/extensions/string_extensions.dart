import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:icalendar_parser/src/model/ics_transp.dart';

extension IcsStringModifier on String {
  IcsStatus toIcsStatus() {
    switch (toUpperCase()) {
      case 'TENTATIVE':
        return IcsStatus.tentative;
      case 'CONFIRMED':
        return IcsStatus.confirmed;
      case 'CANCELLED':
        return IcsStatus.cancelled;
      case 'NEEDS-ACTION':
        return IcsStatus.needsAction;
      case 'COMPLETED':
        return IcsStatus.completed;
      case 'IN-PROCESS':
        return IcsStatus.inProcess;
      case 'DRAFT':
        return IcsStatus.draft;
      case 'FINAL':
        return IcsStatus.isFinal;
      default:
        throw ICalendarStatusParseException('Unknown IcsStatus: $this');
    }
  }

  IcsTransp toIcsTransp() {
    switch (toUpperCase()) {
      case 'OPAQUE':
        return IcsTransp.opaque;
      case 'TRANSPARENT':
        return IcsTransp.transparent;
      default:
        throw ICalendarTranspParseException('Unknown IcsTransp: $this');
    }
  }
}
