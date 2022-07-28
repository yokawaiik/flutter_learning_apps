import 'package:client/src/state/realtime_chat_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../models/room.dart';

class CreateRoomController extends GetxController {
  final GlobalKey<FormState> form = GlobalKey<FormState>();

  RxBool isPrivate = false.obs;
  String? title;
  int? maxParticipant;

  void close() {
    Get.back();
  }

  void createRoom() {
    // print('$isPrivate $title $maxParticipant');

    if (!form.currentState!.validate()) {
      return;
    }
    
    form.currentState!.save();

    final chatController = Get.find<RealtimeChatController>();

    final user = chatController.authService.currentUser;

    final room = Room(
      id: Uuid().v4(),
      title: title!,
      createdByUser: user!.uid!,
      maxParticipant: maxParticipant!,
      isPrivate: isPrivate.value,
    );

    chatController.create(room);
  }

  void isPrivateToggle() {
    isPrivate.value = !isPrivate.value;
  }
}
