import 'package:icalendar_parser/src/exceptions/icalendar_exception.dart';

List<ParsedLine> genericParser({
  required List<String> lines,
  bool Function(String)? shouldStartWith,
  bool Function(String)? shouldEndWith,
  bool allowEmptyLines = true,
}) {
  if (shouldStartWith != null && !shouldStartWith(lines.first)) {
    throw ArgumentError('Invalid component.');
  } else if (shouldEndWith != null && !shouldEndWith(lines.last)) {
    throw ArgumentError('Invalid component.');
  }

  final data = <Map<String, dynamic>>[];

  for (int i = 0; i < lines.length; i++) {
    final line = StringBuffer(lines[i].trim());

    if (line.isEmpty && !allowEmptyLines) {
      throw const EmptyLineException();
    }

    final exp = RegExp('^ ');
    while (i + 1 < lines.length && exp.hasMatch(lines[i + 1])) {
      i += 1;
      line.write(lines[i].trim());
    }

    final dataLine = line.toString().split(':');
    // TODO: finish this
  }

  // TODO: finish this
  return [];
}

class ParsedLine {
  const ParsedLine({
    required this.name,
    this.params,
    this.value,
  });

  final String name;
  final Map<String, dynamic>? params;
  final String? value;
}
