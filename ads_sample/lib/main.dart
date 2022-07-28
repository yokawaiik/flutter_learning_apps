import 'package:ads_sample/screens/one_screen.dart';
import 'package:ads_sample/screens/two_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OneScreen(),
      routes: {
        OneScreen.id: (context) => OneScreen(),
        TwoScreen.id: (context) => TwoScreen(),
      },
    );
  }
}
