import 'package:icalendar_parser/icalendar_parser.dart';

extension IcsTranspModifier on IcsTransp {
  String get string => toString().split('.').last.toUpperCase();
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
