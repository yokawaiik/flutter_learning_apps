import 'package:client/src/modules/create_room/state/create_room_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateRoomScreen extends GetView<CreateRoomController> {
  static const String routeName = "/create-room";

  const CreateRoomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, actions: []),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Form(
            key: controller.form,
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                ListTile(
                  title: TextFormField(
                    decoration: InputDecoration(labelText: "Title room"),
                    initialValue: controller.title,
                    onChanged: (v) {
                      controller.title = v;
                    },
                    validator: (v) {
                      if (v == null || v.length < 5)
                        return "For this field must be filled with minimum 5 symbols.";
                      return null;
                    },
                  ),
                ),
                ListTile(
                  title: TextFormField(
                    decoration: InputDecoration(labelText: "Max participant"),
                    initialValue: (controller.maxParticipant ?? 0).toString(),
                    onChanged: (v) {
                      controller.maxParticipant = int.tryParse(v);
                    },
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null)
                        return "This field does not must be empty.";
                      if (int.tryParse(v)! <= 2 && int.tryParse(v)! <= 99) {
                        return "For this field needs to add number between 2 and 99.";
                      }
                      return null;
                    },
                  ),
                ),
                Obx(
                  () => SwitchListTile(
                    title: Text("Is room private?"),
                    onChanged: (v) => controller.isPrivateToggle(),
                    value: controller.isPrivate.value,
                  ),
                ),
              ],
            ),
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
                  onPressed: controller.createRoom,
                  child: Text("Create room"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
