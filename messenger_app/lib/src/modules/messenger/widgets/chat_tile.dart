import 'package:flutter/material.dart';
import 'package:messenger_app/src/modules/chat/screens/chat_screen.dart';
import 'package:messenger_app/src/modules/messenger/models/chat_user.dart';
import 'package:messenger_app/src/modules/messenger/provider/messenger_provider.dart';
import 'package:provider/provider.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    Key? key,
    required this.chatId,
    required this.user,
  }) : super(key: key);

  final String chatId;
  final ChatUser user;

  void _removeChat(BuildContext context) async {
         await Provider.of<MessengerProvider>(context, listen: false)
            .removeChat(chatId);
  }


  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ObjectKey(chatId),
      direction: DismissDirection.endToStart,
      resizeDuration: Duration(milliseconds: 200),
      onDismissed: (direction) {
        
        _removeChat(context);
  
      },
      background: Container(
        padding: EdgeInsets.only(right: 28.0),
        alignment: AlignmentDirectional.centerEnd,
        color: Colors.red,
        child: Icon(
          Icons.delete_forever,
          color: Colors.white,
        ),
      ),
      child: ListTile(
        onTap: () {
          Navigator.of(context).pushNamed(
            ChatScreen.routeName,
            arguments: chatId,
          );
        },
        leading: CircleAvatar(
          child: Icon(Icons.person),
        ),
        title: Text(
          user.fullName,
        ),
      ),
    );
  }

  
}
