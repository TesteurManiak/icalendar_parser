part of 'ical_component.dart';

/// See doc: https://icalendar.org/iCalendar-RFC-5545/3-6-1-event-component.html
class VEvent extends ICalComponent {
  VEvent({
    required this.dtStamp,
    required this.uid,
    this.dtStart,
    this.classification = Classification.public,
    this.created,
    this.description,
    this.geo,
    this.lastModified,
    this.location,
    this.otherParams,
  }) : super('VEVENT');

  factory VEvent.parse(
    List<String> lines, {
    bool allowEmptyLines = true,
  }) {
    final params = genericParser(
      lines: lines,
      allowEmptyLines: allowEmptyLines,
      shouldStartWith: (line) => line.startsWith('BEGIN:VEVENT'),
      shouldEndWith: (line) => line.startsWith('END:VEVENT'),
    );

    // TODO: finish this
    throw UnimplementedError();
  }

  final IcalDateTime dtStamp;
  final String uid;
  final IcalDateTime? dtStart;
  final Classification classification;
  final IcalDateTime? created;
  final String? description;
  final (double, double)? geo;
  final IcalDateTime? lastModified;
  final Location? location;
  final Map<String, Object?>? otherParams;

  static VEvent? tryParse(List<String> lines) {
    try {
      return VEvent.parse(lines);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final localOtherParams = otherParams;

    return {
      'type': type,
      'dtStamp': dtStamp.toString(),
      'uid': uid,
      'dtStart': dtStart?.toString(),
      'classification': classification.toString(),
      'created': created?.toString(),
      'description': description,
      'geo': geo?.toJson(),
      'last-modified': lastModified?.toString(),
      'location': location?.toString(),
      if (localOtherParams != null) ...localOtherParams,
    }.toValidMap();
  }
}

extension on (double, double) {
  String toJson() => '${this.$1};${this.$2}';
}
