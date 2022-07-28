import 'dart:io';

import 'package:costs_manager/pages/my_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  // ? NOTE set dense mode for orientaion app
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget _buildCupertinoApp() {
    return const CupertinoApp(
      title: 'Costs Manager',
      theme: CupertinoThemeData(),
      home: MyHomePage(),
    );
  }

  Widget _buildMaterialApp() {
    return MaterialApp(
      title: 'Costs Manager',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: "OpenSans",
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        textTheme: const TextTheme(
          headline6: TextStyle(
            fontFamily: "Quicksand",
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final bool isIos = Platform.isIOS;
    // final bool isIos  = Platform.isAndroid;

    return isIos ? _buildCupertinoApp() : _buildMaterialApp();
  }
}
