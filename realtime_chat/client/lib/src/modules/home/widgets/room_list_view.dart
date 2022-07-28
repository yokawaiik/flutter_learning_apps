import 'package:client/src/modules/home/state/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoomListView extends GetView<HomeController> {
  const RoomListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.loadListRooms,
      child: Obx(
        () => ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: controller.listRooms.length,
          itemBuilder: (_, i) {
            final room = controller.listRooms[i];

            return ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.chat),
              ),
              title: Text(room.title),
              subtitle: Text(' ${room.usersCount}'),
              onTap: () => controller.openRoom(room),
            );
          },
        ),
      ),
    );
  }
}
