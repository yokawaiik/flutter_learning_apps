import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_manager_app/src/modules/appointments/screens/appointments_screen.dart';
import 'package:personal_manager_app/src/modules/contacts/screens/contacts_screen.dart';
import 'package:personal_manager_app/src/modules/notes/screens/notes_screen.dart';
import 'package:personal_manager_app/src/modules/tasks/screens/tasks_screen.dart';

import 'modules/navigation/screens/navigation_screen.dart';


class PersonalManagerApp extends StatelessWidget {
  const PersonalManagerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: NavigationScreen.routeName,
      getPages: [
        GetPage(
          name: NavigationScreen.routeName,
          page: () => NavigationScreen(),
        ),

        GetPage(
          name: AppointmentsScreen.routeName,
          page: () => AppointmentsScreen(),
        ),
        GetPage(
          name: TasksScreen.routeName,
          page: () => TasksScreen(),
        ),
        GetPage(
          name: NotesScreen.routeName,
          page: () => NotesScreen(),
        ),

        GetPage(
          name: ContactsScreen.routeName,
          page: () => ContactsScreen(),
        ),
      ],
    );
  }
}
