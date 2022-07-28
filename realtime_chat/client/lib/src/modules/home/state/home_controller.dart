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

class HomeController extends GetxController {
  final chatController = Get.find<RealtimeChatController>();
  var selectedIndex = Rx<int>(0);
  List<Widget> pages = [
    RoomListView(),
    PeopleListView(),
  ];

  var pageViewController = PageController(initialPage: 0, keepPage: false).obs;

  var selectedRoomId = Rxn<String>();

  User? selectedUser;

  RxList<Room> get listRooms => chatController.listRooms;
  RxList<User> get listUsers => chatController.listUsers;

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
    loadListRooms();
    loadListUsers();

    super.onInit();
  }

  @override
  void onClose() {
    pageViewController.value.dispose();
    super.onClose();
  }

  Future<void> exit() async {
    await Get.dialog(
      AlertDialog(
        title: const Text("Warning"),
        content: const Text('Do you want exit chat?'),
        actions: [
          TextButton(
            child: const Text("No"),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: const Text("Yes"),
            onPressed: () async {
              chatController.exitChat();

              await Get.offNamed(LobbyScreen.routeName);
            },
          ),
        ],
      ),
    );
  }

  void addRoom() {
    Get.toNamed(CreateRoomScreen.routeName);
  }

  // id - its index
  void openRoom(Room room) {
    final uid = chatController.authService.currentUser!.uid;

    if ((room.createdByUser != uid) &&
        (room.isPrivate == true && !room.invitedUserIdList.contains(uid))) {
      Get.snackbar("Info", "You can't go to this room, because it's private.");
      return;
    }
    chatController.join(room.id);
  }

  void onPageChanged(int index) {
    if (index < pages.length && index != selectedIndex.value) {
      selectedIndex.value = index;

      pageViewController.value.jumpToPage(selectedIndex.value);
      pageViewController.refresh();
    }
  }

  Future<void> loadListRooms() async {
    chatController.loadListRooms();
  }

  Future<void> loadListUsers() async {
    chatController.loadListUsers();
  }

  void addUserToRoom(String uid) {
    if (chatController.authService.currentUser!.uid == uid) return;
    if (chatController.authService.currentUser!.createdRoomsId.isEmpty) return;

    Get.toNamed(AddUserToRoomScreen.routeName, arguments: uid);
  }

  void selectRoom(String? id) {
    selectedRoomId.value = id;
  }
}
