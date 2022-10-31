import 'package:caesar_cipher/src/pages/main_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caesar cipher',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        MainScreen.routeName: (context) => const MainScreen(),
      },
      initialRoute: MainScreen.routeName,
    );
  }
}
