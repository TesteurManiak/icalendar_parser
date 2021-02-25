import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:icalendar_parser/src/model/ics_transp.dart';

extension IcsStringModifier on String {
  IcsStatus toIcsStatus() {
    // ignore: unnecessary_this
    switch (this.toUpperCase()) {
      case 'TENTATIVE':
        return IcsStatus.TENTATIVE;
      case 'CONFIRMED':
        return IcsStatus.CONFIRMED;
      case 'CANCELLED':
        return IcsStatus.CANCELLED;
      case 'NEEDS-ACTION':
        return IcsStatus.NEEDS_ACTION;
      case 'COMPLETED':
        return IcsStatus.COMPLETED;
      case 'IN-PROCESS':
        return IcsStatus.IN_PROCESS;
      case 'DRAFT':
        return IcsStatus.DRAFT;
      case 'FINAL':
        return IcsStatus.FINAL;
      default:
        throw ICalendarStatusParseException('Unknown IcsStatus: $this');
    }
  }

  IcsTransp toIcsTransp() {
    // ignore: unnecessary_this
    switch (this.toUpperCase()) {
      case 'OPAQUE':
        return IcsTransp.OPAQUE;
      case 'TRANSPARENT':
        return IcsTransp.TRANSPARENT;
      default:
        throw ICalendarTranspParseException('Unknown IcsTransp: $this');
    }
  }
}
