import 'package:client/src/modules/room/state/room_controller.dart';
import 'package:client/src/modules/room/widgets/partcipants_list_view.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ParticipantsScreen extends GetView<RoomController> {
  static const String routeName = "/participants";

  const ParticipantsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: ParticipantsListView(),
    );
  }
}
