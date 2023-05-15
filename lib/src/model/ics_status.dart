/// This property defines the overall status or confirmation for the calendar
/// component.
///
/// Example:
/// - `TENTATIVE`
/// - `NEEDS-ACTION`
///
/// See doc: https://icalendar.org/iCalendar-RFC-5545/3-8-1-11-status.html
enum IcsStatus {
  tentative('TENTATIVE'),
  confirmed('CONFIRMED'),
  cancelled('CANCELLED'),
  needsAction('NEEDS-ACTION'),
  completed('COMPLETED'),
  inProcess('IN-PROCESS'),
  draft('DRAFT'),
  isFinal('FINAL');

  const IcsStatus(this.value);

  final String value;

  static IcsStatus parse(String key) {
    final effectiveKey = key.toUpperCase();
    return IcsStatus.values.firstWhere(
      (e) => e.value == effectiveKey,
      orElse: () => throw ArgumentError.value(key, 'key', 'Invalid value.'),
    );
  }

  @override
  String toString() => value;
}
