import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_manager_app/src/modules/appointments/state/appointments_controller.dart';
import 'package:personal_manager_app/src/modules/appointments/widgets/add_appointment.dart';
import 'package:personal_manager_app/src/modules/appointments/widgets/appointments_calendar.dart';
import 'package:personal_manager_app/src/modules/appointments/widgets/list_appointments_of_date.dart';

class AppointmentsScreen extends StatelessWidget {
  static const String routeName = "/appointments";

  AppointmentsScreen({Key? key}) : super(key: key);

  final _screens = [
    AppointmentsCalendar(),
    ListAppointmentsOfDate(),
    AddAppointment(),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppointmentsController>(
      init: Get.put(AppointmentsController())!..addContext(context),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.reset();
            return false;
          },
          child: Scaffold(
            body: PageView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: _screens.length,
              onPageChanged: (value) {
                controller.appointments.stackIndex = value;
              },
              controller: controller.pageController,
              itemBuilder: (_, index) {
                return _screens[index];
              },
            ),
            floatingActionButton: controller.appointments.stackIndex == 1
                ? FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      controller.createAppointment();
                    },
                  )
                : null,
          ),
        );
      },
    );
  }
}
