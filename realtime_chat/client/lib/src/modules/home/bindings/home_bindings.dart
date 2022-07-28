import 'package:client/src/modules/home/state/home_controller.dart';

import 'package:get/get.dart';

class HomeBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );

    
  }
}
