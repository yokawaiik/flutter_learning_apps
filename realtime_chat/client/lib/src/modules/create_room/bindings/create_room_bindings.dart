import 'package:client/src/modules/create_room/state/create_room_controller.dart';
import 'package:get/get.dart';

class CreateRoomBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateRoomController());
  }
}