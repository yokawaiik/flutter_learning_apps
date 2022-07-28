import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_manager_app/src/modules/notes/state/notes_controller.dart';

import '../constants/notes.dart' as notes;

class AddNote extends StatelessWidget {
  AddNote({
    Key? key,
  }) : super(key: key);

  final controller = Get.find<NotesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: controller.notes.color == null
          ? null
          : Color(controller.notes.color!),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: controller.formKey,
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
                      initialValue: controller.note?.title,
                      onChanged: (value) {
                        controller.note!.title = value;
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
                      initialValue: controller.note?.content,
                      decoration: InputDecoration(hintText: "Content"),
                      onChanged: (value) {
                        controller.note!.content = value;
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
                    leading: Icon(Icons.palette),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: notes.colorPalette
                          .map(
                            (color) => InkWell(
                              child: Container(
                                decoration: ShapeDecoration(
                                  shape: Border.all(
                                    width: 20,
                                    color: Color(color),
                                  ),
                                ),
                              ),
                              onTap: () {
                                controller.setColor(color);
                              },
                            ),
                          )
                          .toList(),
                    ),
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
                        : controller.add(),
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
        ),
      ),
    );
  }
}
