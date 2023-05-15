/// See doc: https://icalendar.org/iCalendar-RFC-5545/3-8-1-6-geographic-position.html
final class GeographicPosition {
  const GeographicPosition._();

  static (double, double) parse(String value) {
    final parts = value.split(';');
    final latitude = double.parse(parts[0]);
    final longitude = double.parse(parts[1]);
    return (latitude, longitude);
  }

  static (double, double)? tryParse(String? value) {
    if (value == null) return null;
    try {
      return parse(value);
    } on FormatException {
      return null;
    }
  }
}
