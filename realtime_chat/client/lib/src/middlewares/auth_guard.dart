import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/lobby/screens/lobby_screen.dart';
import '../state/realtime_chat_controller.dart';

class AuthGuard extends GetMiddleware {
//   Get the auth service

//   The default is 0 but you can update it to any number. Please ensure you match the priority based
//   on the number of guards you have.
  @override
  int? get priority => 0;

  @override
  RouteSettings? redirect(String? route) {
    // print(realtimeChatController);
    final realtimeChatController = Get.find<RealtimeChatController>();

    // Navigate to login if client is not authenticated other wise continue

    // print(
    //     "AuthGuard, isUserAuthenticated = ${realtimeChatController.authService.isUserAuthenticated}");

    if (!realtimeChatController.authService.isUserAuthenticated) {
      return RouteSettings(name: LobbyScreen.routeName);
    }

    return super.redirect(route);
  }
}
