import 'dart:convert';

import 'package:icalendar_parser/src/model/classification.dart';
import 'package:icalendar_parser/src/model/ical_datetime.dart';
import 'package:icalendar_parser/src/model/ical_organizer.dart';
import 'package:icalendar_parser/src/model/location.dart';
import 'package:icalendar_parser/src/model/period_of_time.dart';
import 'package:icalendar_parser/src/utils/extensions.dart';

part 'v_event.dart';
part 'v_free_busy.dart';
part 'v_todo.dart';

sealed class ICalComponent {
  const ICalComponent(this.type);

  final String type;

  Map<String, dynamic> toJson();
}
