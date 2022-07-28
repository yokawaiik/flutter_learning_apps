import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:get/get.dart';
import 'package:personal_manager_app/src/modules/appointments/models/appointment.dart';
import 'package:personal_manager_app/src/modules/appointments/state/appointments_controller.dart';

class AppointmentsCalendar extends StatelessWidget {
  AppointmentsCalendar({Key? key}) : super(key: key);

  // final EventList<Event> _markedDatesMap = EventList(events: {});

  EventList<Event> _fillMarkedDatesMap() {
    final EventList<Event> markedDatesMap = EventList(events: {});

    // print("_fillMarkedDatesMap");
    final controller = Get.find<AppointmentsController>();

    // start initial

    // controller.(DateTime.now());

    for (int i = 0; i < controller.appointments.items.length; i++) {
      final appointment = controller.appointments.items[i] as Appointment;

      markedDatesMap.add(
        appointment.apptDate!,
        Event(
          date: appointment.apptDate!,
          icon: Container(
            decoration: BoxDecoration(color: Colors.blue),
          ),
        ),
      );
    }

    return markedDatesMap;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: GetBuilder<AppointmentsController>(
              init: Get.find<AppointmentsController>(),
              builder: (controller) {
                _fillMarkedDatesMap();

                return CalendarCarousel(
                  thisMonthDayBorderColor: Colors.grey,
                  daysHaveCircularBorder: false,
                  markedDatesMap: _fillMarkedDatesMap(),
                  onDayPressed: (DateTime date, List<Event> events) {
                    // print("date: $date, ${date}");
                    // print("events: $events");

                    controller.showListAppointmentsOfDate(date);
                  },
                  onCalendarChanged: (DateTime date) {
                    // await controller.monthEventLoad(date);
                    controller.getAll(date);
                  },
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
