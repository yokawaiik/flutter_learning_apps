import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../state/room_controller.dart';

class MessageInput extends GetView<RoomController> {
  const MessageInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.all(5),
      height: 60,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                // color: Color.fromARGB(255, 209, 209, 209),
                border: Border.all(color: colorScheme.primary),
                borderRadius: BorderRadius.circular(35.0),
                // boxShadow: [
                //   BoxShadow(
                //     offset: Offset(0, 3),
                //     blurRadius: 5,
                //     color: Colors.grey,
                //   )
                // ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.messageInputController,
                      onChanged: (value) {
                        controller.messageContent = value;
                      },
                      
                      minLines: 1,
                      maxLines: 4,
                      decoration: InputDecoration(
                          hintText: "Type Something...",
                          hintStyle: TextStyle(
                            color: colorScheme.primary,
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10),
          Ink(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ), // LinearGradientBoxDecoration
            child: InkWell(
              onTap: controller.sendMessage,
              customBorder: CircleBorder(),
              child: Center(
                child: Icon(
                  Icons.send,
                  color: colorScheme.primary,
                ),
              ),
              splashColor: Theme.of(context).colorScheme.shadow,
            ), // Red will correctly spread over gradient
          ),
        ],
      ),
    );
  }
}
