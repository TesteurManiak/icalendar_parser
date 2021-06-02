import 'package:icalendar_parser/icalendar_parser.dart';

extension IcsTranspModifier on IcsTransp {
  String get string => toString().split('.').last.toUpperCase();
}

extension IcsStatusModifier on IcsStatus {
  String get string => toString().split('.').last.toUpperCase();
}
