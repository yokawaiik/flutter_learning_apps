import 'package:client/src/models/room.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

import '../state/add_user_to_room_controller.dart';

class AddUserToRoomScreen extends GetView<AddUserToRoomController> {
  static const String routeName = "/home/add-user-to-room";

  const AddUserToRoomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              ListTile(
                
                title: TextFormField(
                  enabled: false,
                  decoration: InputDecoration(labelText: controller.selectedUser.userName),
               
                ),
              ),


              Obx(
                () => ListTile(
                  title: DropdownButton(
                    hint: Text("Select room"),
                    value: controller.selectedRoomId.value,
                    items: controller.createdRooms.map((Room room) {
                      return DropdownMenuItem<String>(
                        value: room.id,
                        child: Text(room.title),
                      );
                    }).toList(),
                    onChanged: (String? id) => controller.selectRoom(id),
                  ),
                ),
              ),


            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: controller.close,
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: controller.addUserToRoom,
                  child: Text("Add"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
