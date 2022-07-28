import 'package:client/src/modules/home/state/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PeopleListView extends GetView<HomeController> {
  const PeopleListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.loadListUsers,
      child: Obx(
        () => ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: controller.listUsers.length,
          itemBuilder: (_, i) {
            final user = controller.listUsers[i];
            
            return ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(user.userName!),
              onTap: () => controller.addUserToRoom(user.uid!),
            );
          },
        ),
      ),
    );
  }
}
