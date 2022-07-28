import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

TimeOfDay fromStringToTimeOfDay(String inTime) {
  final numbers = inTime.split(":");

  return TimeOfDay(
    hour: int.parse(numbers[0]),
    minute: int.parse(numbers[1]),
  );
}

DateTime fromStringToDate(String inTime) {
  return DateTime.parse(inTime);
}

String fromTimeOfDayToString(TimeOfDay inTime) {


  return "${inTime.hour}:${inTime.minute}";
}

TimeOfDay fromDateTimeToTimeOfDay(DateTime inDateTime) {
  return TimeOfDay(hour: inDateTime.hour, minute: inDateTime.minute);
}

String fromDateTimeToString(DateTime inDate) {
  return inDate.toString();
}

DateTime fromIntToDateTime(int inDate) {
  return DateTime.fromMillisecondsSinceEpoch(inDate);
}

int fromDateTimeToInt(DateTime inDate) {
  return inDate.millisecondsSinceEpoch;
}
