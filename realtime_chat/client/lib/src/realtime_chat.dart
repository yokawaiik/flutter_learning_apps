import 'package:client/src/modules/home/bindings/add_user_to_room_bindings.dart';
import 'package:client/src/modules/home/screens/add_user_to_room_screen.dart';
import 'package:client/src/modules/room/screens/participants_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'modules/home/bindings/home_bindings.dart';
import 'modules/lobby/screens/lobby_screen.dart';
import 'modules/create_room/screens/create_room_screen.dart';
import 'modules/home/screens/home_screen.dart';

import 'middlewares/auth_guard.dart';
import 'modules/room/bindings/room_bindings.dart';
import 'modules/room/screens/room_screen.dart';

import 'modules/create_room/bindings/create_room_bindings.dart';
import 'modules/lobby/bindings/lobby_bindings.dart';
import 'bindings/main_bindings.dart';

class RealtimeChat extends StatelessWidget {
  const RealtimeChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: MainBindings(),
      initialRoute: HomeScreen.routeName,
      getPages: [
        GetPage(
          name: LobbyScreen.routeName,
          page: () => LobbyScreen(),
          binding: LobbyBindings(),
        ),
        GetPage(
          name: HomeScreen.routeName,
          page: () => HomeScreen(),
          binding: HomeBindings(),
          middlewares: [
            AuthGuard(),
          ],
        ),
        GetPage(
          name: AddUserToRoomScreen.routeName,
          page: () => AddUserToRoomScreen(),
          binding: AddUserToRoomBindings(),
        ),
        GetPage(
          name: CreateRoomScreen.routeName,
          page: () => CreateRoomScreen(),
          binding: CreateRoomBindings(),
        ),
        GetPage(
          name: RoomScreen.routeName,
          page: () => RoomScreen(),
          binding: RoomBindings(),
        ),
        GetPage(
          name: ParticipantsScreen.routeName,
          page: () => ParticipantsScreen(),
        ),
      ],
    );
  }
}
