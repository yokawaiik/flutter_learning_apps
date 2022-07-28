import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:personal_manager_app/src/modules/notes/models/note.dart';
import 'package:personal_manager_app/src/modules/notes/state/notes_controller.dart';
import 'package:personal_manager_app/src/modules/notes/widgets/add_note.dart';

class NotesScreen extends StatelessWidget {
  static const String routeName = "/notes";

  NotesScreen({Key? key}) : super(key: key);

  Future<void> _deleteNote(BuildContext context, Note note) async {
    final _notesController = Get.find<NotesController>();

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Delete Note"),
          content: Text("Are you sure you want to delete note: ${note.title}"),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text("No")),
            ElevatedButton(
              onPressed: () async {
                await _notesController.delete(note.id!);
                
                Get.snackbar("Item was deleted", "It's done.",
                    backgroundColor: Colors.white);
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotesController>(
        init: Get.put(NotesController()),
        builder: (controller) {
          return WillPopScope(
            onWillPop: () async {
              controller.reset();
              return false;
            },
            child: Scaffold(
              body: controller.notes.stackIndex == 0
                  ? ListView.builder(
                      itemCount: controller.notes.items.length,
                      itemBuilder: (ctx, i) {
                        final note = controller.notes.items[i] as Note;

                        return Slidable(
                          key: ValueKey(note.id),
                          endActionPane: ActionPane(
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                spacing: 0,
                                // An action can be bigger than the others.
                                flex: 1,
                                onPressed: (_) => controller.delete(note.id!),
                                backgroundColor: Colors.transparent,
                                foregroundColor:
                                    Theme.of(context).colorScheme.error,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: Card(
                            elevation: 0,
                            color:
                                note.color == null ? null : Color(note.color!),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text("#${note.id}"),
                              ),
                              title: Text(note.title!),
                              subtitle: Text(note.content!),
                              onTap: () async {
                                await controller.selectItem(note.id!);
                              },
                            ),
                          ),
                        );
                      },
                    )
                  : AddNote(),
              floatingActionButton: controller.notes.stackIndex == 0
                  ? FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: () {
                        controller.createNote();
                      },
                    )
                  : null,
            ),
          );
        });
  }
}
