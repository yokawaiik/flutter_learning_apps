import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_manager_app/src/modules/appointments/state/appointments_controller.dart';

class AddAppointment extends StatelessWidget {
  AddAppointment({
    Key? key,
  }) : super(key: key);

  // final controller = Get.find<AppointmentsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: GetBuilder<AppointmentsController>(
          init: Get.find<AppointmentsController>(),
          builder: (controller) {
            return Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Form(
                  key: controller.form,
                  child: ListView(
                    padding: EdgeInsets.all(10),
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        leading: Icon(Icons.title),
                        title: TextFormField(
                          keyboardType: TextInputType.text,
                          minLines: 1,
                          maxLines: 2,
                          decoration: InputDecoration(hintText: "Title"),
                          initialValue: controller.appointment?.title,
                          onChanged: (value) {
                            controller.appointment!.title = value;
                          },
                          validator: (value) {
                            if (value == null || value.length == 0) {
                              return "Write title here.";
                            }

                            return null;
                          },
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.content_copy),
                        title: TextFormField(
                          keyboardType: TextInputType.text,
                          minLines: 1,
                          maxLines: 8,
                          initialValue: controller.appointment?.description,
                          decoration: InputDecoration(hintText: "Description"),
                          onChanged: (value) {
                            controller.appointment!.description = value;
                          },
                          validator: (value) {
                            if (value == null || value.length == 0) {
                              return "Write your content here.";
                            }

                            return null;
                          },
                        ),
                      ),

                      ListTile(
                        leading: Icon(Icons.calendar_today),
                        title: Text("Date"),
                        subtitle: Text(controller.appointment!.date),
                        trailing: Icon(Icons.edit),
                        onTap: () => controller.setDate(),
                      ),
                      ListTile(
                        leading: Icon(Icons.timer),
                        title: Text("Time"),
                        subtitle: Text(controller.appointment!.time),
                        trailing: Icon(Icons.edit),
                        onTap: () => controller.setTime(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => controller.reset(),
                        child: Text(
                          "Back",
                          style: TextStyle(
                              fontSize:
                                  Theme.of(context).textTheme.headline6!.fontSize),
                        ),
                      ),
                      TextButton(
                        onPressed: () => controller.isEdit
                            ? controller.updateRow()
                            : controller.addRow(),
                        child: Text(
                          controller.isEdit ? "Update" : "Add",
                          style: TextStyle(
                              fontSize:
                                  Theme.of(context).textTheme.headline6!.fontSize),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          }
        ),
      ),
    );
  }
}
