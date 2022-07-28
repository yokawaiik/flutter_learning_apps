import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/models/chat_model.dart';

class MessageListTile extends StatelessWidget {
  final currentUserID = FirebaseAuth.instance.currentUser!.uid;

  final ChatModel chatModel;

  MessageListTile(this.chatModel);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: chatModel.userID == currentUserID
                ? Radius.circular(15)
                : Radius.zero,
            bottomRight: chatModel.userID == currentUserID
                ? Radius.zero
                : Radius.circular(15),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: chatModel.userID == currentUserID
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            mainAxisAlignment: chatModel.userID == currentUserID
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Text('By ${chatModel.userName}',
                  style: TextStyle(color: Colors.black)),
              SizedBox(
                height: 4,
              ),
              Text(chatModel.message)
            ],
          ),
        ),
      ),
    );
  }
}
