import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:icalendar_parser/src/model/ical_duration.dart';

/// This value type is used to identify values that contain a precise period of
/// time.
///
/// The [start] MUST be before the [end].
///
/// [end] can be either a [IcalDateTime] or a [Duration].
///
/// See doc: https://icalendar.org/iCalendar-RFC-5545/3-3-9-period-of-time.html
class PeriodOfTime {
  const PeriodOfTime({
    required this.start,
    required this.end,
  });

  factory PeriodOfTime.parse(String value) {
    final parts = value.split('/');

    if (parts.length != 2) {
      throw FormatException('Invalid period of time format: $value');
    }

    final start = IcalDateTime.parse(parts[0]);

    final EndOfPeriod end;
    final endDt = IcalDateTime.tryParse(parts[1]);
    final endDuration = IcalDuration.tryParse(parts[1]);
    if (endDt != null) {
      if (endDt.isBefore(start)) {
        throw FormatException('Invalid period of time format: $value');
      }

      end = EndOfPeriodDateTime(endDt);
    } else if (endDuration != null) {
      end = EndOfPeriodDuration(IcalDuration.parse(parts[1]));
    } else {
      throw FormatException('Invalid period of time format: $value');
    }

    return PeriodOfTime(start: start, end: end);
  }

  final IcalDateTime start;
  final EndOfPeriod end;

  static PeriodOfTime? tryParse(String? value) {
    if (value == null) {
      return null;
    }

    try {
      return PeriodOfTime.parse(value);
    } on FormatException {
      return null;
    }
  }
}

/// Union type for [IcalDateTime] and [Duration].
sealed class EndOfPeriod {
  const EndOfPeriod();

  T when<T extends Object?>({
    required T Function(IcalDateTime) dateTime,
    required T Function(Duration) duration,
  }) {
    final expression = this;
    switch (expression) {
      case EndOfPeriodDateTime(value: final value):
        return dateTime(value);
      case EndOfPeriodDuration(value: final value):
        return duration(value);
    }
  }
}

class EndOfPeriodDateTime extends EndOfPeriod {
  const EndOfPeriodDateTime(this.value);

  final IcalDateTime value;
}

class EndOfPeriodDuration extends EndOfPeriod {
  const EndOfPeriodDuration(this.value);

  final Duration value;
}
