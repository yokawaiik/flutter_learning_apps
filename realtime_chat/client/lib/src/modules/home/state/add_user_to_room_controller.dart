import 'package:client/src/modules/create_room/screens/create_room_screen.dart';
import 'package:client/src/modules/home/screens/add_user_to_room_screen.dart';
import 'package:client/src/modules/home/widgets/people_list_view.dart';
import 'package:client/src/modules/home/widgets/room_list_view.dart';
import 'package:client/src/modules/lobby/screens/lobby_screen.dart';
import 'package:client/src/services/auth_service.dart';
import 'package:client/src/state/realtime_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/room.dart';
import '../../../models/user.dart';

class AddUserToRoomController extends GetxController {
  final chatController = Get.find<RealtimeChatController>();

  var selectedRoomId = Rxn<String>();
  late User selectedUser;

  // here needs change on get request to server
  List<Room> get createdRooms {
    final createdRoomsId =
        chatController.authService.currentUser!.createdRoomsId;

    final listRooms = chatController.listRooms;

    List<Room> rooms = [];

    for (final roomId in createdRoomsId) {
      for (final room in listRooms) {
        if (room.id == roomId) rooms.add(room);
      }
    }

    return rooms;
  }

  @override
  void onInit() {
    super.onInit();

    final uid = Get.arguments as String;

    selectedUser =
        chatController.listUsers.firstWhere((item) => item.uid == uid);
  }

  void selectRoom(String? id) {
    selectedRoomId.value = id;
  }

  void addUserToRoom() {
    if (selectedRoomId.value == null) return;
    chatController.invite(selectedUser, selectedRoomId.value!, close);

  }

  void close() {
    Get.back();
  }


}
