import 'package:client/src/modules/home/screens/home_screen.dart';
import 'package:client/src/modules/lobby/screens/lobby_screen.dart';
import 'package:client/src/modules/room/screens/room_screen.dart';
import 'package:client/src/services/auth_service.dart';
import 'package:flutter/foundation.dart';

import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../models/message.dart';
import '../models/room.dart';
import '../models/user.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../constants/api_constants.dart' show Statuses, Emits, Handlers;

class RealtimeChatController extends GetxController {
  final authService = Get.find<AuthService>();

  IO.Socket? socket;

  var currentRoom = Rxn<Room>();
  var currentRoomMessages = <Message>[].obs;

  var listRooms = <Room>[].obs;
  var listUsers = <User>[].obs;

  bool currentRoomEnabled = false;

  void initializeSocket() {
    try {
      String? url;
      if (kDebugMode) {
        if (GetPlatform.isWeb) {
          url = "http://127.0.0.1:3000";
        } else {
          url = "http://10.0.2.2:3000";
        }
      } else {
        url = "http://127.0.0.1:3000";
      }

      socket = IO.io(url, {
        "transports": ["websocket"],
        "autoConnect": false,
      });

      socket!.onConnect((_) {
        // print('connect');
      });

      socket!.onDisconnect(
        (_) {
          // print('disconnect');
          exitChat();

          Get.offNamed(LobbyScreen.routeName);
        },
      );

      socket!.on(Handlers.givedListUsers, (data) {
        // print(Handlers.givedListUsers);

        if (data["status"] == Statuses.ok) {
          //     // var rooms = <Room>[].obs;
          listUsers.clear();
          for (var item in data["listUsers"]) {
            listUsers.insert(0, User.fromMap(item));
          }

          listUsers.refresh();
        } else {
          Get.snackbar(
            "Error loading",
            "You can't to load rooms...",
          );
        }
      });

      socket!.on(Handlers.posted, (data) {
        // print(Handlers.posted);

        final message =
            Message.fromMap(data["message"], authService.currentUser!.uid!);

        if (currentRoomMessages.length > 99) {
          currentRoomMessages.removeLast();
        }

        currentRoomMessages.insert(0, message);
        currentRoomMessages.refresh();
      });

      socket!.on(Handlers.joined, (data) {
        // print(data["room"]);
        final user = User.fromMap(data["user"]);

        currentRoom.value?.userList.insert(0, user);

        currentRoom.refresh();

        Get.snackbar(
            "Notification", "${user.userName} connected to this room.");
      });

      socket!.on(Handlers.userJoined, (data) {
        final room =
            listRooms.firstWhere((item) => item.id == data["room"]["id"]);
        final joinedUser = User.fromMap(data["user"]);

        room.userList.add(joinedUser);

        listRooms.refresh();
      });

      socket!.on(Handlers.newInvitedUser, (data) {
        // print(Handlers.newInvitedUser);

        final room =
            listRooms.firstWhere((item) => item.id == data["room"]["id"]);
        final invitedUser = User.fromMap(data["user"]);

        room.invitedUserIdList.add(invitedUser.uid!);

        listRooms.refresh();
      });

      socket!.on(Handlers.invited, (data) {
        // print(Handlers.invited);

        final room =
            listRooms.firstWhere((item) => item.id == data["room"]["id"]);
        Get.snackbar("New invite", "You send invite to room ${room.title}");
      });

      socket!.on(Handlers.userLeft, (data) {
        final room =
            listRooms.firstWhere((item) => item.id == data["room"]["id"]);
        final leftUser = User.fromMap(data["user"]);
        room.userList.removeWhere((item) => item.uid == leftUser.uid);
        listRooms.refresh();
      });

      socket!.on(Handlers.left, (data) {
        final user = User.fromMap(data["user"]);
        currentRoom.value!.userList.removeWhere((item) => item.uid == user.uid);
        currentRoom.refresh();
        Get.snackbar("Notification", "${user.userName} left this room.");
      });

      socket!.on(Handlers.kicked, (data) {
        final kickedUser = User.fromMap(data["user"]);

        if (kickedUser.uid == authService.currentUser!.uid) {
          leave();
        }
      });

      socket!.on(Handlers.newUser, (data) {
        final user = User.fromMap(data);

        listUsers.insert(0, user);
        listUsers.refresh();
      });

      socket!.on(Handlers.created, (data) {
        final room = Room.fromMap(data);

        listRooms.insert(0, room);
        listRooms.refresh();
      });

      socket!.onerror((err) {
        // print("Error in the socket: $err");
      });

      // print(socket!.flags.entries);
    } catch (e) {
      print("Error socket: $e");
    }
  }

  @override
  void onInit() {
    initializeSocket();
    super.onInit();
  }

  void setCurrentUser(User user, String urlSocket) {
    socket!.connect();
    socket!.emitWithAck(Emits.validate, user.toMap(), ack: (data) {
      // print(data);
      if (data["status"] == Statuses.ok || data["status"] == Statuses.created) {
        user.setSettings(data["user"]);
        authService.currentUser = user;

        Get.offAndToNamed(HomeScreen.routeName);
      } else {
        Get.snackbar(
          "Error connection",
          "You can't to connect to server...",
        );
      }
    });
  }

  void loadListRooms() {
    socket!.emitWithAck(Emits.listRooms, null, ack: (data) {
      if (data["status"] == Statuses.ok) {
        listRooms.clear();
        for (var item in data["listRooms"]) {
          listRooms.insert(0, Room.fromMap(item));
        }
        listRooms.refresh();
      } else {
        Get.snackbar(
          "Error loading",
          "You can't to load rooms...",
        );
      }
    });
  }

  void loadListUsers() {
    socket!.emit(Emits.listUsers);
  }

  void join(String id) {
    final room = listRooms.firstWhere((item) => item.id == id);
    currentRoom.value = room;
    socket!.emitWithAck(Emits.join, {
      "id": room.id,
      "user": authService.currentUser!.toMap(),
    }, ack: (data) {
      if (data["status"] == Statuses.ok) {
        currentRoom.value!.update(data["room"]);

        // print("void join - currentRoom.value?.id - ${currentRoom.value?.id}");

        Get.toNamed(
          RoomScreen.routeName,
          arguments: id,
        );
      } else if (data["status"] == Statuses.full) {
        Get.snackbar(
          "Info",
          "Room is full now.",
        );
      } else if (data["status"] == Statuses.deleted) {
        Get.snackbar(
          "Error",
          "Room already been deleted.",
        );
      } else {
        Get.snackbar(
          "Error",
          "Unknown error.",
        );
      }
    });
  }

  void leave() {
    Get.back();
    socket!.emitWithAck(Emits.leave, {
      "user": authService.currentUser!.toMap(),
      "room": {
        "id": currentRoom.value!.id,
      },
    }, ack: (data) {
      currentRoom.value = null;
      currentRoomMessages.clear();
      currentRoom.refresh();
    });
  }

  void exitChat() {
    socket!.disconnect();
    currentRoomEnabled = false;
    currentRoomMessages.clear();
    listRooms.clear();
    listUsers.clear();
    authService.currentUser = null;
//
  }

  void setCreatorFunctionsEnabled() {
    // todo
  }

  void create(Room room) {
    socket!.emitWithAck(Emits.create, room.toMap(), ack: (data) {
      if (data["status"] == Statuses.created) {
        authService.currentUser!.createdRoomsId.add(room.id);

        Get.back();
      } else if (data["status"] == Statuses.exist) {
        Get.snackbar(
          "Create error",
          "Room with the same title already exist.",
        );
      } else {
        Get.snackbar(
          "Create error",
          "Unknown error.",
        );
      }
    });
  }

  void post(Message message, Callback callback) {
    socket!.emitWithAck(Emits.post, {
      "room": {"id": currentRoom.value!.id},
      "message": message.toMap(),
    }, ack: (data) {
      print(data);
      if (data["status"] == Statuses.ok) {
        callback();
      } else if (data["status"] == Statuses.fail) {
        Get.snackbar(
          "Posting error",
          "Message doesn't send.",
        );
      } else {
        Get.snackbar(
          "Posting error",
          "Unknown error.",
        );
      }
    });
  }

  void kick(User user) {
    socket!.emit(Emits.kick, {
      "user": user.toMap(),
      "room": {
        "id": currentRoom.value!.id,
      },
    });
  }

  void invite(User selectedUser, String value, Function close) {
    socket!.emitWithAck(
      Emits.invite,
      {
        "user": selectedUser.toMap(),
        "roomId": value,
      },
      ack: (data) {
        if (data["status"] == Statuses.ok) {
          close();
        } else {
          Get.snackbar(
            "Error",
            "Unknown error.",
          );
        }
      },
    );
  }
}
