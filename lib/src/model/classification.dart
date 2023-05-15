/// This property defines the access classification for a calendar component.
///
/// If not specified in a component that allows this property, the default value
/// is [Classification.public].
///
/// Example: `CLASS:PUBLIC`
///
/// See doc: https://icalendar.org/iCalendar-RFC-5545/3-8-1-3-classification.html
enum Classification {
  public('PUBLIC'),
  private('PRIVATE'),
  confidential('CONFIDENTIAL');

  const Classification(this.value);

  final String value;

  /// Parse a [String] to an [Classification] object.
  ///
  /// Applications MUST treat x-name and iana-token values they don't recognize
  /// the same way as they would the [Classification.private] value.
  static Classification parse(String str) {
    return Classification.values.firstWhere(
      (e) => e.value == str.toUpperCase(),
      orElse: () => Classification.private,
    );
  }

  @override
  String toString() => value;
}
