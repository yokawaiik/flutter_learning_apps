import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_manager_app/src/modules/contacts/widgets/add_contact.dart';
import 'package:personal_manager_app/src/modules/contacts/widgets/list_contacts.dart';



import '../state/contacts_controller.dart';

class ContactsScreen extends StatelessWidget {
  static const String routeName = "/contacts";

  ContactsScreen({Key? key}) : super(key: key);

  final _screens = [
    ListContacts(),
    AddContact(),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ContactsController>(
        init: Get.put(ContactsController())!..addContext(context),
        builder: (controller) {
          return WillPopScope(
            onWillPop: () async {
            controller.reset();
            return false;
          },
            child: Scaffold(
              body: PageView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: _screens.length,
                onPageChanged: (value) {
                  controller.contacts.stackIndex = value;
                },
                controller: controller.pageController,
                itemBuilder: (_, index) {
                  return _screens[index];
                },
              ),
              floatingActionButton: controller.contacts.stackIndex == 0
                  ? FloatingActionButton(
                      child: Icon(Icons.person_add),
                      onPressed: () {
                        controller.createContact();
                      },
                    )
                  : null,
            ),
          );
        });
  }
}
