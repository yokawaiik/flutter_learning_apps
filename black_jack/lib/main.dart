import 'package:flutter/material.dart';

import './screens/black_jack_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Black Jack',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: BlackJackScreen(),
    );
  }
}