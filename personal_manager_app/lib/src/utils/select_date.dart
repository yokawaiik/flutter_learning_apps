import 'package:flutter/material.dart';

Future<DateTime?> selectDate(
  BuildContext context, [
  DateTime? initialDate,
]) async {
  final now = DateTime.now();

  initialDate ??= DateTime.now();

  final selectDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(now.year - 1),
    lastDate: DateTime(now.year + 1),
  );

  return selectDate;
}
