import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_manager_app/src/modules/tasks/state/tasks_controller.dart';

class AddTask extends StatelessWidget {
  const AddTask({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TasksController>(
      init: Get.find<TasksController>(),
  
      builder: (controller) {
        return Container(
          child: Form(
            key: controller.form,
            child: Column(
              children: [
                ListView(
                  // padding: EdgeInsets.all(10),
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      leading: Icon(Icons.content_copy),
                      title: TextFormField(
                        keyboardType: TextInputType.text,
                        minLines: 1,
                        maxLines: 8,
                        initialValue: controller.task?.description,
                        decoration: InputDecoration(
                          hintText: "Content",
                        ),
                        onChanged: (value) {
                          controller.task!.description = value;
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
                      leading: Icon(Icons.today),
                      title: controller.task == null
                          ? null
                          : Text(controller.task!.date),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          controller.selectDate();
                        },
                      ),
                    ),
                  ],
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
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .fontSize),
                        ),
                      ),
                      TextButton(
                        onPressed: () => controller.isEdit
                            ? controller.updateRow()
                            : controller.addRow(),
                        child: Text(
                          controller.isEdit ? "Update" : "Add",
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .fontSize),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
