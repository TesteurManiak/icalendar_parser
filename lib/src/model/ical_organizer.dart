import 'package:icalendar_parser/src/utils/extensions.dart';
import 'package:meta/meta.dart';

/// This property defines the organizer for a calendar component.
///
/// Example: `CN=John Smith:mailto:jsmith@example.com`
///
/// See doc: https://icalendar.org/iCalendar-RFC-5545/3-8-4-3-organizer.html
@immutable
class ICalOrganizer {
  const ICalOrganizer({
    this.cn,
    this.dir,
    this.sentBy,
    this.other,
    this.value,
    this.language,
  });

  factory ICalOrganizer.parse(String value) {
    try {
      final mailtoIndex = value.indexOf(':mailto:');
      final mailto = mailtoIndex != -1
          ? Uri.parse(value.substring(mailtoIndex + 1))
          : null;
      final parts = mailtoIndex != -1
          ? value.substring(0, mailtoIndex).split(';')
          : value.split(';');
      final mappedParts = Map<String, String>.fromEntries(
        parts.map((part) {
          final keyValue = part.splitFirst('=');
          return MapEntry(keyValue[0], keyValue[1]);
        }),
      );

      return ICalOrganizer(
        value: mailto,
        cn: mappedParts['CN'],
        dir: mappedParts['DIR'],
        sentBy: mappedParts['SENT-BY'],
        language: mappedParts['LANGUAGE'],
        other: mappedParts.entries
            .where((e) => e.key != 'CN' && e.key != 'DIR' && e.key != 'SENT-BY')
            .map((e) => '${e.key}=${e.value}')
            .toList(),
      );
    } catch (_) {
      throw FormatException('Invalid ICalOrganizer value: $value');
    }
  }

  final String? cn;
  final String? dir;
  final String? sentBy;
  final List<String>? other;
  final Uri? value;
  final String? language;

  static ICalOrganizer? tryParse(String? value) {
    if (value == null) return null;

    try {
      final parsedValue = ICalOrganizer.parse(value);
      return parsedValue;
    } on FormatException {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value?.toString(),
      'cn': cn,
      'dir': dir,
      'sentBy': sentBy,
      'other': other,
    }.toValidMap();
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ICalOrganizer &&
            cn == other.cn &&
            dir == other.dir &&
            sentBy == other.sentBy &&
            this.other == other.other &&
            value == other.value &&
            language == other.language;
  }

  @override
  int get hashCode => Object.hash(cn, dir, sentBy, other, value, language);
}
