import 'package:client/src/state/realtime_chat_controller.dart';
import 'package:get/get.dart';

import '../services/auth_service.dart';

class MainBindings implements Bindings {
  @override
  void dependencies() {

    // does'nt delelete from memory
    Get.put(AuthService());

    // does'nt delelete from memory controller, because its used in all the screens
    Get.put(RealtimeChatController(), permanent: true);
  }
}
