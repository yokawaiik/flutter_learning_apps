import 'package:client/src/state/realtime_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/user.dart';
import '../../home/state/home_controller.dart';

class LobbyController extends GetxController {
  late final GlobalKey<FormState> form = GlobalKey<FormState>();

  String? connectionString = "localhost:5000/chat";
  User user = User();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    Get.delete<HomeController>();
    super.onReady();
  }

  void connect() {
    if (!form.currentState!.validate()) return;
    form.currentState!.save();

    print("connect");

    // todo
    final chatController = Get.find<RealtimeChatController>();

    chatController.setCurrentUser(user, connectionString!);
  }
}
