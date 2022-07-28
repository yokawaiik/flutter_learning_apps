import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:personal_manager_app/src/modules/appointments/models/appointment.dart';
import 'package:personal_manager_app/src/modules/appointments/state/appointments_controller.dart';

class ListAppointmentsOfDate extends StatelessWidget {
  const ListAppointmentsOfDate({Key? key}) : super(key: key);

  Future<void> _delete(Appointment task) async {
    try {
      final _controller = Get.find<AppointmentsController>();

      await showDialog(
        context: _controller.context!,
        builder: (ctx) {
          return AlertDialog(
            title: Text("Delete Note"),
            content: Text(
                "Are you sure you want to delete note: ${task.description}"),
            actions: [
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("No")),
              ElevatedButton(
                onPressed: () async {
                  await _controller.delete(task.id!);
                  Get.back();
                  Get.snackbar("Item was deleted", "It's done.",
                      backgroundColor: Colors.white);
                },
                child: Text("Yes"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppointmentsController>(
        init: Get.find<AppointmentsController>(),
        builder: (controller) {
          return ListView.builder(
            itemCount: controller.listAppointmentsOfDate.length,
            itemBuilder: (ctx, i) {
              // final appointment =
              //     controller.appointments.items[i] as Appointment;
              final appointment = controller.listAppointmentsOfDate[i];

              // print(appointment);

              return Slidable(
                key: ValueKey(appointment.id),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      spacing: 0,
                      // An action can be bigger than the others.
                      flex: 1,
                      onPressed: (_) => _delete(appointment),
                      backgroundColor: Colors.transparent,
                      foregroundColor: Theme.of(context).colorScheme.error,
                      icon: Icons.delete,
                      label: 'Delete',
                 
                    ),
                    SlidableAction(
                      spacing: 0,
                      // An action can be bigger than the others.
                      flex: 1,
                      onPressed: (_) => controller.selectItem(appointment.id!),
                      backgroundColor: Colors.transparent,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                  ],
                ),
                child: Card(
                  elevation: 0,
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text("#${appointment.id}"),
                    ),
                    title: Text(appointment.description!),
                    subtitle: Text(appointment.date),
                    onTap: () {
                      controller.selectItem(appointment.id!);
                    },
                  ),
                ),
              );
            },
          );
        });
  }
}
