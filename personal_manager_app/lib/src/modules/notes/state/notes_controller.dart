import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:personal_manager_app/src/modules/notes/models/note.dart';
import 'package:personal_manager_app/src/modules/notes/models/notes.dart';
import 'package:personal_manager_app/src/modules/notes/utils/notes_db_worker.dart';

class NotesController extends GetxController {
  final db = NotesDBWorker.instance;

  final notes = Notes();

  @override
  void onInit() {
    super.onInit();

    getAll();
  }

  bool get isEdit {
    return notes.selectedItem == null ? false : true;
  }

  Future<void> getAll() async {
    try {
      final db = NotesDBWorker.instance;

      notes.items = await db.getAll();
    } catch (e) {
      print("error $e");
      rethrow;
    } finally {
      update();
    }
  }

  Future<void> selectItem(int id) async {
    notes.selectedItem = await db.get(id) as Note;

    notes.setColor((notes.selectedItem as Note).color!);

    note = notes.selectedItem;

    notes.stackIndex = 1;
    update();
  }

  Future<void> delete(int id) async {
    await NotesDBWorker.instance.delete(id);

    notes.items.removeWhere((item) => item.id == id);

    update();
  }

  Future<void> updateRow() async {
    await NotesDBWorker.instance.update(note!);

    final index = notes.items.indexWhere((item) => item.id == note!.id);

    notes.items[index] = note;
    notes.stackIndex = 0;
    update();
  }

  void reset() {
    note = null;
    notes.selectedItem = null;
    notes.setColor(null);
    notes.stackIndex = 0;

    update();
  }

  // Form
  final formKey = GlobalKey<FormState>();
  Note? note;

  void setColor(int color) {
    note!.color = color;
    notes.setColor(color);

    update();
  }

  void createNote() {
    note = Note();

    notes.stackIndex = 1;

    update();
  }

  Future<void> add() async {
    final insertedNote = await NotesDBWorker.instance.create(note!);

    notes.items.insert(0, insertedNote);

    reset();
  }
}
