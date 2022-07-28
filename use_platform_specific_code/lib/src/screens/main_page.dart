import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainPage extends StatefulWidget {
  static const String routeName = "MainPage";

  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int? _batteryLevel;


  @override
  void initState() {
    super.initState();
    _getBatteryLevel();
  }


  Future<void> _getBatteryLevel() async {
    try {
      const platform = MethodChannel("specific.dev/battery");

      final batteryLevel = await platform.invokeMethod('getBatteryLevel');

      setState(() {
        _batteryLevel = batteryLevel;
      });
    } on PlatformException catch (e) {
      print(e);

      setState(() {
        _batteryLevel = null;
      });
    } catch (e) {
      print(e);
      setState(() {
        _batteryLevel = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Platform custom code here"),
      ),
      body: Center(
        child: Text("Battery ${_batteryLevel == null ? "ops" : _batteryLevel}"
        , textAlign: TextAlign.center),
      ),
    );
  }
}
