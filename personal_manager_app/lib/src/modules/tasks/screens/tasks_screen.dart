import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import 'package:personal_manager_app/src/modules/tasks/models/task.dart';
import 'package:personal_manager_app/src/modules/tasks/state/tasks_controller.dart';
import 'package:personal_manager_app/src/modules/tasks/widget/add_task.dart';

class TasksScreen extends StatelessWidget {
  static const String routeName = "/tasks";

  TasksScreen({Key? key}) : super(key: key);

  Future<void> _delete(Task task) async {
    try {
      final _tasksController = Get.find<TasksController>();

      await showDialog(
        context: _tasksController.context!,
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
                  await _tasksController.delete(task.id!);
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
    return GetBuilder<TasksController>(
        init: Get.put(TasksController())!..addContext(context),
        builder: (controller) {
          return WillPopScope(
            onWillPop: () async {
              controller.reset();
              return false;
            },
            child: Scaffold(
              body: ListView.builder(
                itemCount: controller.tasks.items.length,
                itemBuilder: (ctx, i) {
                  final task = controller.tasks.items[i] as Task;

                  return Slidable(
                    key: ValueKey(task.id),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          spacing: 0,
                          // An action can be bigger than the others.
                          flex: 1,
                          onPressed: (_) => _delete(task),
                          backgroundColor: Colors.transparent,
                          foregroundColor: Theme.of(context).colorScheme.error,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                        SlidableAction(
                          spacing: 0,
                          // An action can be bigger than the others.
                          flex: 1,
                          onPressed: (_) => controller.selectItem(task.id!),
                          backgroundColor: Colors.transparent,
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                      ],
                    ),
                    child: Card(
                      elevation: 0,
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text("#${task.id}"),
                        ),
                        title: Text(task.description!),
                        subtitle: Text(task.date),
                        onTap: () {
                          controller.selectItem(task.id!);
                        },
                        trailing: Checkbox(
                          value: task.isCompleted,
                          onChanged: (bool? value) {
                            controller.setStatus(task, value);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              floatingActionButton: controller.tasks.stackIndex == 0
                  ? FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: () {
                        controller.createTask();
                        Get.bottomSheet(
                          AddTask(),
                          backgroundColor: Colors.white,
                        );
                      },
                    )
                  : null,
            ),
          );
        });
  }
}
