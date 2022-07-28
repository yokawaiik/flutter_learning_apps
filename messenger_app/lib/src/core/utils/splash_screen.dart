
import 'package:flutter/material.dart';
import 'package:messenger_app/src/modules/auth/models/auth_user.dart';
import 'package:messenger_app/src/modules/auth/provider/auth_provider.dart';

import 'package:messenger_app/src/modules/auth/screens/auth_screen.dart';
import 'package:messenger_app/src/modules/messenger/screens/messenger_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = "SplashScreen";

  const SplashScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthUser?>(
        stream: Provider.of<AuthProvider>(context).currentUser,
        builder: (ctx, snapshot) {
          print(snapshot.data);
          if (snapshot.connectionState == ConnectionState.active) {
            
            final user = snapshot.data;
            if (user == null) {
              return AuthScreen();
            } else {
              return MessengerScreen();
            }
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
