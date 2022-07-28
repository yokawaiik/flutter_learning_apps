import 'package:flutter/material.dart';

import '../../../models/message.dart';

const double _kBubbleMetaFontSize = 10;

class MessageBuble extends StatelessWidget {
  final Message message;

  const MessageBuble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Align(
        alignment: message.isCurrentUser
            ? Alignment.centerRight 
            : Alignment.centerLeft,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      message.content,
                      // style: TextStyle(

                      //     ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      message.date,
                      style: TextStyle(
                        fontSize: _kBubbleMetaFontSize,
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
