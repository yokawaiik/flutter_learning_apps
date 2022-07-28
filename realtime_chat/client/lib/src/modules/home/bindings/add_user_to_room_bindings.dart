import 'package:client/src/modules/home/state/add_user_to_room_controller.dart';
import 'package:client/src/modules/home/state/home_controller.dart';

import 'package:get/get.dart';

class AddUserToRoomBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddUserToRoomController>(
      () => AddUserToRoomController(),
    );

    
  }
}
