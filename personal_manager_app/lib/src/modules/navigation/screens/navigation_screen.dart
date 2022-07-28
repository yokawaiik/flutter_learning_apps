import 'package:flutter/material.dart';
import 'package:personal_manager_app/src/modules/appointments/screens/appointments_screen.dart';
import 'package:personal_manager_app/src/modules/contacts/screens/contacts_screen.dart';
import 'package:personal_manager_app/src/modules/notes/screens/notes_screen.dart';
import 'package:personal_manager_app/src/modules/tasks/screens/tasks_screen.dart';

class NavigationScreen extends StatelessWidget {
  static const String routeName = "/";
  NavigationScreen({Key? key}) : super(key: key);

  final screens = [
    AppointmentsScreen(),
    ContactsScreen(),
    NotesScreen(),
    TasksScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: screens.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Personal Manager"),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.date_range),
                text: "Appointments",
              ),
              Tab(
                icon: Icon(Icons.contacts),
                text: "Contacts",
              ),
              Tab(
                icon: Icon(Icons.note),
                text: "Notes",
              ),
              Tab(
                icon: Icon(Icons.assignment_turned_in),
                text: "Tasks",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ...screens
          ],
        ),
      ),
    );
  }
}
