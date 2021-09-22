/// Enumeration of all event statuses.
///
/// See doc: https://www.kanzaki.com/docs/ical/status.html
enum IcsStatus {
  tentative,
  confirmed,
  cancelled,
  needsAction,
  completed,
  inProcess,
  draft,
  isFinal
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
