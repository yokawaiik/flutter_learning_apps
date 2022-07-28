import 'package:flutter/material.dart';
import 'package:messenger_app/src/modules/auth/screens/auth_screen.dart';
import 'package:messenger_app/src/modules/chat/screens/chat_screen.dart';
import 'package:messenger_app/src/modules/messenger/screens/messenger_screen.dart';
import 'package:messenger_app/src/modules/profile/screens/profile_screen.dart';
import 'package:messenger_app/src/core/utils/splash_screen.dart';

class MessengerRouter {
  final Map<String, Widget Function(BuildContext)> routes = {
    SplashScreen.routeName: (_ctx) => SplashScreen(),
    AuthScreen.routeName: (_ctx) => AuthScreen(),
    MessengerScreen.routeName: (_ctx) => MessengerScreen(),
    ChatScreen.routeName: (_ctx) => ChatScreen(),
    ProfileScreen.routeName: (_ctx) => ProfileScreen(),

  };

  final String initialRoute = SplashScreen.routeName;

}

final router = MessengerRouter();
