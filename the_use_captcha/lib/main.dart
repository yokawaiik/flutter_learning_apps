import 'package:flutter/material.dart';
import 'package:the_use_captcha/pages/main_page.dart';
import 'package:the_use_captcha/pages/pass_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The use captcha',
      theme: ThemeData(
        colorSchemeSeed: Colors.purple,
      ),
      routes: {
        MainPage.routeName: (_) => const MainPage(),
        PassPage.routeName: (_) => const PassPage(),
      },
      initialRoute: MainPage.routeName,
    );
  }
}
