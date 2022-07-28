import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_manager_app/src/modules/tasks/models/task.dart';
import 'package:personal_manager_app/src/modules/tasks/models/tasks.dart';
import 'package:personal_manager_app/src/modules/tasks/utils/tasks_db_helper.dart';
import 'package:personal_manager_app/src/modules/tasks/widget/add_task.dart';
import '../../../utils/select_date.dart' as selectDateUtil;

class TasksController extends GetxController {
  final _db = TasksDBHelper.instance;

  final _tasks = Tasks();

  final form = GlobalKey<FormState>();

  Tasks get tasks => _tasks;

  Task? get task => _tasks.selectedItem;

  bool get isEdit {
    return task?.id == null ? false : true;
  }

  @override
  void onInit() {
    super.onInit();

    getAll();
  }

  BuildContext? context;
  void addContext(BuildContext context) {
    this.context = context;
  }

  Future<void> getAll() async {
    try {
      tasks.items = await _db.getAll();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      update();
    }
  }

  Future<void> delete(int id) async {
    try {
      await _db.delete(id);

      (_tasks.items as List<Task>).removeWhere((Task item) => item.id! == id);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      update();
    }
  }

  void reset() {
    _tasks.selectedItem = null;
    _tasks.chosenDate = null;
    _tasks.stackIndex = 0;

    Get.back();

    update();
  }

  Future<void> selectItem(int id) async {
    try {
      final item = await _db.get(id);

      _tasks.selectedItem = item;
      _tasks.chosenDate = item?.dueDate;
      _tasks.stackIndex = 1;

      update();

      Get.bottomSheet(
        AddTask(),
        backgroundColor: Colors.white,
      );
    } catch (e) {
      reset();
      Get.snackbar("Error", e.toString());
    }
  }

  Future<Task> createTask() async {
    _tasks.selectedItem = Task();

    return Task();
  }

  Future<void> selectDate() async {
    _tasks.chosenDate = await selectDateUtil.selectDate(context!);

    (_tasks.selectedItem as Task).dueDate = _tasks.chosenDate;

    update();
  }

  Future<void> updateRow() async {
    try {
      await _db.update(task!);

      final index = (_tasks.items as List<Task>)
          .indexWhere((item) => item.id == task!.id);

      _tasks.items[index] = task!;

      reset();
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.white);
    }
  }

  Future<void> addRow() async {
    final insertedItem = await _db.create(task!);

    tasks.items.insert(0, insertedItem);

    reset();
  }

  Future<void> setStatus(Task task, bool? value) async {
    try {
      task.isCompleted = value!;
      await _db.updateStatus(task);

      final index =
          (_tasks.items as List<Task>).indexWhere((item) => item.id == task.id);

      (_tasks.items[index] as Task).isCompleted = value;

      update();
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.white,
      );
    }
  }
}
