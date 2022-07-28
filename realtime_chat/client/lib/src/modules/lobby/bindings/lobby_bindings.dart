import 'package:client/src/modules/lobby/state/lobby_controller.dart';
import 'package:client/src/state/realtime_chat_controller.dart';
import 'package:get/get.dart';

class LobbyBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LobbyController>(
      () => LobbyController(),
    );
  }
}
