import 'package:flutter/material.dart';
import 'package:messenger_app/src/modules/chat/models/message.dart';

class ChatMessage extends StatelessWidget {
  final Message message;

  const ChatMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Align(
        alignment:
            message.isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (message.isCurrentUser
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary)
                .withOpacity(0.5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(message.isCurrentUser ? 0.0 : 10),
              bottomLeft: Radius.circular(message.isCurrentUser ? 10 : 0.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: message.isCurrentUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: <Widget>[
              Text(message.text, style: Theme.of(context).textTheme.headline6,),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    message.date,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
