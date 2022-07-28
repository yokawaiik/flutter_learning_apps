import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:personal_manager_app/src/modules/contacts/models/contact.dart';

import '../models/contacts.dart';
import '../state/contacts_controller.dart';

class ListContacts extends StatelessWidget {
  const ListContacts({Key? key}) : super(key: key);

  Future<void> _delete(Contact contact) async {
    try {
      final controller = Get.find<ContactsController>();

      await showDialog(
        context: controller.context!,
        builder: (ctx) {
          return AlertDialog(
            title: Text("Delete Contact"),
            content: Text(
                "Are you sure you want to delete contact: ${contact.name}"),
            actions: [
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("No")),
              ElevatedButton(
                onPressed: () async {
                  await controller.delete(contact.id!);
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
    return GetBuilder<ContactsController>(
      init: Get.find<ContactsController>(),
      builder: (controller) {
        return ListView.builder(
          itemCount: controller.contacts.items.length,
          itemBuilder: (ctx, i) {
            final contact = controller.contacts.items[i] as Contact;

            return Slidable(
              key: ValueKey(contact.id),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    spacing: 0,
                    // An action can be bigger than the others.
                    flex: 1,
                    onPressed: (_) => _delete(contact),
                    backgroundColor: Colors.transparent,
                    foregroundColor: Theme.of(context).colorScheme.error,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                  SlidableAction(
                    spacing: 0,
                    // An action can be bigger than the others.
                    flex: 1,
                    onPressed: (_) => controller.selectItem(contact.id!),
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
                    // radius: 18,
                    child: ClipOval(
                      child: contact.pathToImage == null
                          ? Icon(Icons.person)
                          : Image.file(
                              File(
                                contact.pathToImage!,
                              ),
                              fit: BoxFit.fill,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                    ),
                  ),
                  title: Text(contact.name!),
                  subtitle: Text(contact.birthday),
                  onTap: () {
                    controller.selectItem(contact.id!);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
