import 'package:client/src/modules/room/state/room_controller.dart';
import 'package:client/src/state/realtime_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class ParticipantsListView extends GetView<RoomController> {
  const ParticipantsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return GetBuilder<RealtimeChatController>(
    //   builder: (chatController) {
    //     return ListView.builder(
    //       itemCount: controller.room!.userList.length,
    //       itemBuilder: (_, i) {
    //         final user = controller.room!.userList[i];

    //         return ListTile(
    //           leading: CircleAvatar(
    //             child: Icon(Icons.person),
    //           ),
    //           title: Text(user.userName!),
    //           onTap: () => controller.actionWithUser(user),
    //         );
    //       },
    //     );
    //   }
    // );
    return Obx(
      () => ListView.builder(
        itemCount: controller.room.value!.userList.length,
        itemBuilder: (_, i) {
          final user = controller.room.value!.userList[i];

          return ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text(user.userName!),
            onTap: () => controller.actionWithUser(user),
          );
        },
      ),
    );
  }
}
