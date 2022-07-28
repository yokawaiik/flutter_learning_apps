import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../state/contacts_controller.dart';

class AddContact extends StatelessWidget {
  const AddContact({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: GetBuilder<ContactsController>(
        init: Get.find<ContactsController>(),
        builder: (controller) {
          return Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  // height: mediaQuery.size.height / 5,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      controller.setImage();
                    },
                    child: ClipOval(
                      child: SizedBox.fromSize(
                        size: Size.fromRadius(90),
                        child: controller.contact?.pathToImage == null
                            ? Icon(
                                Icons.person,
                                size: 150,
                                color: colorScheme.onPrimary,
                              )
                            : Image.file(
                                File(controller.contact!.pathToImage!),
                                fit: BoxFit.fill,
                                // width: 180,
                                // height: 100.0,
                                // width: 100.0,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              Form(
                key: controller.form,
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  // padding: EdgeInsets.all(10),
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      leading: Icon(Icons.person),
                      title: TextFormField(
                        keyboardType: TextInputType.text,
                        minLines: 1,
                        maxLines: 8,
                        initialValue: controller.contact?.name,
                        decoration: InputDecoration(
                          hintText: "Name",
                        ),
                        onChanged: (value) {
                          controller.contact!.name = value;
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
                      leading: Icon(Icons.phone),
                      title: TextFormField(
                        keyboardType: TextInputType.text,
                        minLines: 1,
                        maxLines: 8,
                        initialValue: controller.contact?.phone,
                        decoration: InputDecoration(
                          hintText: "Phone",
                        ),
                        onChanged: (value) {
                          controller.contact!.phone = value;
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
                      leading: Icon(Icons.email),
                      title: TextFormField(
                        keyboardType: TextInputType.text,
                        minLines: 1,
                        maxLines: 8,
                        initialValue: controller.contact?.email,
                        decoration: InputDecoration(
                          hintText: "Email",
                        ),
                        onChanged: (value) {
                          controller.contact!.email = value;
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
                      title: controller.contact == null
                          ? null
                          : Text(controller.contact!.birthday),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          controller.setDate();
                        },
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
              )
            ],
          );
        },
      ),
    );
  }
}
