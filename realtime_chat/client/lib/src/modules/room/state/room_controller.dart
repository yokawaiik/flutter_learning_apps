import 'package:client/src/modules/room/screens/participants_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/message.dart';
import '../../../models/room.dart';
import '../../../models/user.dart';
import '../../../state/realtime_chat_controller.dart';

class RoomController extends GetxController {
  // RxnString? messageContent;
  String? messageContent;

  final chatController = Get.find<RealtimeChatController>();

  var messageInputController = TextEditingController();

  RxList<Message> get currentRoomMessages => chatController.currentRoomMessages;

  Rxn<Room> get room => chatController.currentRoom;

  @override
  void onInit() {
    super.onInit();
    print(Get.arguments as String);
  }

  void sendMessage() {
    if (messageContent == null || messageContent!.isEmpty) return;

    chatController.post(
        Message(
          dateTime: DateTime.now(),
          uid: chatController.authService.currentUser!.uid!,
          content: messageContent!,
          isCurrentUser: true,
        ),
        clearMessageInput);
  }

  // it'll be call if status of response is positive as callback
  void clearMessageInput() {
    messageContent = null;
    messageInputController.clear();
    update();
  }

  void leaveRoom() {
    chatController.leave();
  }

  void showParticipants() {
    Get.toNamed(ParticipantsScreen.routeName);
  }

  void actionWithUser(User user) {
    if (chatController.authService.currentUser!.uid !=
        room.value!.createdByUser) return;
    if (chatController.authService.currentUser!.uid == user.uid) return;

    // todo:
    Get.dialog(AlertDialog(
      title: Text('User settings'),
      content: const Text('Kick user from chat.'),
      actions: [
        TextButton(
          child: Text('No'),
          onPressed: () {
            Get.back();
          },
        ),
        TextButton(
          child: Text('Yes'),
          onPressed: () {
            chatController.kick(user);
            Get.back();
          },
        ),
      ],
    ));
  }
}
