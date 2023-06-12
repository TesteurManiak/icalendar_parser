/// This value type is used to identify properties that contain a duration of
/// time.
///
/// See doc: https://icalendar.org/iCalendar-RFC-5545/3-3-6-duration.html
class IcalDuration extends Duration {
  const IcalDuration({
    super.days,
    super.hours,
    super.minutes,
    super.seconds,
  });

  /// {@template ical_duration.parse}
  /// Parses a duration from a string.
  ///
  /// The format can represent nominal durations (weeks and days) and accurate
  /// durations (hours, minutes and seconds), here's some examples:
  /// - P15DT5H0M20S -> 15 days, 5 hours, 0 minutes, 20 seconds
  /// - P7W -> 7 weeks
  /// {@endtemplate}
  ///
  /// Throws a [FormatException] if the value is not a valid duration.
  factory IcalDuration.parse(String value) {
    final regex = RegExp(
      r'(?<=P)(?:(?:(?<weeks>\d+)W)?(?:(?<days>\d+)D)?)?(?:T(?:(?<hours>\d+)H)?(?:(?<minutes>\d+)M)?(?:(?<seconds>\d+)S)?)?',
    );

    final match = regex.firstMatch(value);
    if (match == null) {
      throw FormatException('Invalid duration format: $value');
    }

    final weeks = int.tryParse(match.namedGroup('weeks') ?? '') ?? 0;
    final days = int.tryParse(match.namedGroup('days') ?? '') ?? 0;
    final hours = int.tryParse(match.namedGroup('hours') ?? '') ?? 0;
    final minutes = int.tryParse(match.namedGroup('minutes') ?? '') ?? 0;
    final seconds = int.tryParse(match.namedGroup('seconds') ?? '') ?? 0;

    return IcalDuration(
      days: weeks * 7 + days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    );
  }

  /// {@macro ical_duration.parse}
  ///
  /// If a [FormatException] is thrown, returns `null`.
  static IcalDuration? tryParse(String? value) {
    if (value == null) {
      return null;
    }

    try {
      return IcalDuration.parse(value);
    } on FormatException {
      return null;
    }
  }

  /// A string representation of this duration.
  ///
  /// As the [Duration] object does not support weeks, this method will always
  /// represent weeks as days.
  ///
  /// Examples:
  /// - 15 days, 5 hours, 0 minutes, 20 seconds -> P15DT5H0M20S
  /// - 7 weeks -> P49D
  @override
  String toString() {
    final days = inDays;
    final hours = inHours % Duration.hoursPerDay;
    final minutes = inMinutes % Duration.minutesPerHour;
    final seconds = inSeconds % Duration.secondsPerMinute;

    final buffer = StringBuffer('P');

    if (days > 0) {
      buffer.write('$days' 'D');
    }

    if (hours > 0 || minutes > 0 || seconds > 0) {
      buffer
        ..write('T')
        ..write('$hours' 'H')
        ..write('$minutes' 'M')
        ..write('$seconds' 'S');
    }

    return buffer.toString();
  }
}
