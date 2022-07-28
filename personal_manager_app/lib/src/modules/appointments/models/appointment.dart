import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/time_utils.dart' as timeUtils;

class Appointment {
  int? id;
  String? title;
  String? description;
  DateTime? apptDate;
  TimeOfDay? apptTime;

  Appointment({
    this.id,
    this.title,
    this.description,
    this.apptDate,
    this.apptTime,
  });

  String get date {
    if (apptDate == null) return "Date";

    return DateFormat.yMMMMd().format(apptDate!);
  }

  String get time {
    if (apptTime == null) return "Time";

    return "${apptTime!.hour}:${apptTime!.minute}";
  }

  @override
  String toString() {
    return "$id $title $description $apptDate";
  }

  Appointment.fromMap(data) {
    id = data["id"];
    title = data["title"];
    description = data["description"];
    apptDate = data["apptDate"] == null
        ? null
        : timeUtils.fromIntToDateTime(data["apptDate"]);

    apptTime = data["apptTime"] == null
        ? null
        : timeUtils.fromStringToTimeOfDay(data["apptTime"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "apptDate":
          apptDate == null ? null : timeUtils.fromDateTimeToInt(apptDate!),
      "apptTime":
          apptTime == null ? null : timeUtils.fromTimeOfDayToString(apptTime!),
    };
  }
}
