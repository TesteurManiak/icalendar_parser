/// This property defines whether or not an event is transparent to busy time
/// searches.
///
/// Example: `OPAQUE`
///
/// See doc: https://icalendar.org/iCalendar-RFC-5545/3-8-2-7-time-transparency.html
enum TimeTransparency {
  opaque('OPAQUE'),
  transparent('TRANSPARENT');

  const TimeTransparency(this.value);

  final String value;

  static TimeTransparency parse(String key) {
    final effectiveKey = key.toUpperCase();
    return TimeTransparency.values.firstWhere(
      (e) => e.value == effectiveKey,
      orElse: () => throw ArgumentError.value(key, 'key', 'Invalid value.'),
    );
  }

  @override
  String toString() => value;
}
