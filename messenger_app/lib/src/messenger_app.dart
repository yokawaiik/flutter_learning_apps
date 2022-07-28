
import 'package:flutter/material.dart';
import 'package:messenger_app/src/core/router/router.dart';
import 'package:messenger_app/src/core/theme/theme.dart';
import 'package:messenger_app/src/modules/auth/provider/auth_provider.dart';
import 'package:messenger_app/src/modules/chat/provider/chat_provider.dart';
import 'package:messenger_app/src/modules/messenger/provider/messenger_provider.dart';
import 'package:messenger_app/src/modules/profile/provider/profile_provider.dart';
import 'package:messenger_app/src/modules/profile/provider/settings_provider.dart';


import 'package:provider/provider.dart';


class MessengerApp extends StatelessWidget {
  const MessengerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        Provider<SettingsProvider>(
          create: (_) => SettingsProvider(),
        ),
        Provider<ProfileProvider>(
          create: (_) => ProfileProvider(),
        ),
        Provider<MessengerProvider>(
          create: (_) => MessengerProvider(),
        ),
        Provider<ChatProvider>(
          create: (_) => ChatProvider(),
        ),
      ],
      child: MaterialApp(
        theme: messengerTheme.themeLight,
        routes: router.routes,
        initialRoute: router.initialRoute,
      ),
    );
  }
}
