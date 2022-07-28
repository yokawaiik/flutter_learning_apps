import 'package:client/src/modules/home/state/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

import '../widgets/room_list_view.dart';

class HomeScreen extends GetView<HomeController> {
  static const String routeName = "/home";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await controller.exit();

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: controller.exit,
              icon: Icon(Icons.close),
            ),
          ],
        ),
        body: Obx(
          () => PageView.builder(
            physics: PageScrollPhysics(),
            itemCount: controller.pages.length,
            allowImplicitScrolling: true,
            controller: controller.pageViewController.value,
            onPageChanged: controller.onPageChanged,
            itemBuilder: (_, index) {
              print("PageView.builder index: ${index}");
              return controller.pages[controller.selectedIndex.value];
            },
          ),
        ),
        floatingActionButton: Obx(
          () => controller.selectedIndex == 0
              ? FloatingActionButton(
                  elevation: 0,
                  child: Icon(Icons.add),
                  onPressed: controller.addRoom,
                )
              : SizedBox.shrink(),
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: "Rooms",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_add),
                label: "People",
              ),
            ],
            onTap: controller.onPageChanged,
          ),
        ),
      ),
    );
  }
}
