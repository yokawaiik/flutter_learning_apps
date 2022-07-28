import 'package:flutter/material.dart';
import 'package:use_platform_specific_code/src/screens/main_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        MainPage.routeName: (ctx) => MainPage(),
      },
      initialRoute: MainPage.routeName,
    );
  }
}
