import 'package:client/src/models/message.dart';
import 'package:client/src/modules/room/state/room_controller.dart';
import 'package:client/src/modules/room/widgets/message_buble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/message_input.dart';

class RoomScreen extends GetView<RoomController> {
  static const String routeName = "/room";

  const RoomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.leaveRoom();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: [
            // IconButton(
            //   onPressed: controller.showParticipants,
            //   icon: Icon(Icons.list),
            // )
            PopupMenuButton(
              icon: Icon(Icons.list),
              onSelected: (v) {
                switch (v) {
                  case 0:
                    controller.showParticipants();
                }
              },
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: Text("Participants"),
                    value: 0,
                    // onTap: () => controller.showParticipants(),
                  )
                ];
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Flexible(
              child: Obx(
                () => ListView.separated(
                  padding: EdgeInsets.all(10),
                  reverse: true, //To keep the latest messages at the bottom

                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(
                    height: 2.5,
                  ),
                  itemCount: controller.currentRoomMessages.length,
                  itemBuilder: (_, index) {
                    final message = controller.currentRoomMessages[index];

                    return MessageBuble(
 
                      message: message,
                    );
                  },
                ),
              ),
            ),
            MessageInput(),
          ],
        ),
      ),
    );
  }
}
