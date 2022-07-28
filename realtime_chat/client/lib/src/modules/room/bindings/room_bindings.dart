import 'package:client/src/modules/home/state/home_controller.dart';

import 'package:get/get.dart';

import '../state/room_controller.dart';

class RoomBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoomController>(
      () => RoomController(),
    );
  }
}
