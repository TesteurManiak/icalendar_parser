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
