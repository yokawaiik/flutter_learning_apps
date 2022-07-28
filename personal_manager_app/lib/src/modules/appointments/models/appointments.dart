import 'package:flutter/material.dart';
import 'package:personal_manager_app/src/models/base.dart';

import '../utils/time_utils.dart' as timeUtils;

class Appointments extends Base {
  
  TimeOfDay? apptTime;

  void setApptTime(DateTime inApptTime) {
    apptTime = timeUtils.fromDateTimeToTimeOfDay(inApptTime);
  }

}