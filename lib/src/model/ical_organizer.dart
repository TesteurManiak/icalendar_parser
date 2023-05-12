import 'package:icalendar_parser/src/model/calendar_user_address.dart';
import 'package:icalendar_parser/src/utils/extensions.dart';

/// This property defines the organizer for a calendar component.
///
/// Example: `CN=John Smith:mailto:jsmith@example.com`
///
/// See doc: https://icalendar.org/iCalendar-RFC-5545/3-8-4-3-organizer.html
class ICalOrganizer extends CalendarUserAddress {
  ICalOrganizer(
    super.value, {
    this.cn,
    this.dir,
    this.sentBy,
    this.other,
  });

  factory ICalOrganizer.parse(String value) {
    try {
      final mailtoIndex = value.indexOf(':mailto:');
      final mailto = Uri.parse(value.substring(mailtoIndex + 1));
      final parts = value.substring(0, mailtoIndex).split(';');
      final mappedParts = Map<String, String>.fromEntries(
        parts.map((part) {
          final keyValue = part.splitFirst('=');
          return MapEntry(keyValue[0], keyValue[1]);
        }),
      );

      return ICalOrganizer(
        mailto,
        cn: mappedParts['CN'],
        dir: mappedParts['DIR'],
        sentBy: mappedParts['SENT-BY'],
        other: mappedParts.entries
            .where((e) => e.key != 'CN' && e.key != 'DIR' && e.key != 'SENT-BY')
            .map((e) => '${e.key}=${e.value}')
            .toList(),
      );
    } catch (e) {
      throw FormatException('Invalid ICalOrganizer value: $value');
    }
  }

  final String? cn;
  final String? dir;
  final String? sentBy;
  final List<String>? other;

  static ICalOrganizer? tryParse(String? value) {
    if (value == null) return null;

    try {
      final parsedValue = ICalOrganizer.parse(value);
      return parsedValue;
    } on FormatException {
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'value': value.toString(),
      'cn': cn,
      'dir': dir,
      'sentBy': sentBy,
      'other': other,
    }.toValidMap();
  }
}
