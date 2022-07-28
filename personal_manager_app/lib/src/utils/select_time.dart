import 'package:flutter/material.dart';

Future<TimeOfDay?> selectTime(
  BuildContext context, [
  TimeOfDay? initialTime,
]) async {
  final now = TimeOfDay.now();

  if (initialTime == null) {
    initialTime = now;
  }

  final selectedTime = await showTimePicker(
    context: context,
    initialTime: initialTime,
    builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      );
    },
  );

  return selectedTime;
}
