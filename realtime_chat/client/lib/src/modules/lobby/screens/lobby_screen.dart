import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../state/lobby_controller.dart';

class LobbyScreen extends GetView<LobbyController> {
  static const String routeName = "/lobby";

  const LobbyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.background,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Form(
                key: controller.form,
                child: Column(
                  children: [
                    Text(
                      "Websocket chat",
                      style: TextStyle(
                        color: colorScheme.onBackground,
                        fontSize: textTheme.headline6!.fontSize,
                      ),
                    ),
                    SizedBox(height: 20),
                    // TextFormField(
                    //   onChanged: (v) {
                    //     controller.connectionString = v;
                    //   },
                    //   validator: (v) {
                    //     if (v == null || v.isEmpty)
                    //       return "Please fill this field";
                    //     return null;
                    //   },
                    //   decoration: InputDecoration(
                    //     labelText: "Connection adress",
                    //   ),
                    // ),
                    SizedBox(height: 20),
                    TextFormField(
                      onChanged: (v) {
                        controller.user.userName = v;
                      },
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return "Please fill this field";
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "User name",
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      onChanged: (v) {
                        controller.user.userName = v;
                      },
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return "Please fill this field";
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Password",
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: controller.connect,
                      child: Text("Connect"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
