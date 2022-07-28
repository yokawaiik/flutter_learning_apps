// библиотека material с виджетами, 
//имеющими дизайн material design
import 'package:flutter/material.dart';

// экран DiceScreen
import 'package:simple_dice_game/screens/dice_screen.dart';

// главный цикл в dart
void main() {
  // запуск приложения
  runApp(const MyApp());
}

// виджет без состояния
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // название приложения
      title: 'Dice App',
      // тема приложения
      theme: ThemeData(
        backgroundColor: Colors.black12,
        primarySwatch: Colors.purple,
      ),
      // домашний экран приложения
      home: const DiceScreen(),
    );
  }
}
