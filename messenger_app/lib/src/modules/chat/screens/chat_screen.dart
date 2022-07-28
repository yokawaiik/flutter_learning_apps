import 'package:flutter/material.dart';
import 'package:messenger_app/src/modules/chat/models/message.dart';
import 'package:messenger_app/src/modules/chat/provider/chat_provider.dart';
import 'package:messenger_app/src/modules/chat/widgets/chat_message.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = "ChatScreen";

  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _controller = ScrollController();

  late final TextEditingController _inputTextController;

  @override
  void initState() {
    _inputTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _inputTextController.dispose();

    super.dispose();
  }


    void _sendMessage(String chatId) async {
      try {
        final textMessage = _inputTextController.text;

        if (textMessage.isEmpty) return;

        await Provider.of<ChatProvider>(context,listen: false)
        .sendMessage(textMessage, chatId);

        _inputTextController.text = "";
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()))
        );
      }
    }

  @override
  Widget build(BuildContext context) {
    // get id chat
    final chatId = ModalRoute.of(context)!.settings.arguments as String?;
    // Todo: add variant, when user find another user and write its
    print(chatId);
    // if (chatId == null) {

    // }

    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          buildMessageList(context, chatId!),
          buildInputArea(context, chatId),
        ],
      ),
    );
  }

  Widget buildInputArea(BuildContext context, chatId) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: _inputTextController,
            minLines: 1,
            maxLines: 12,
            decoration: InputDecoration(
              hintText: 'Type a message',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        IconButton(
          onPressed: () => _sendMessage(chatId),
          icon: Icon(Icons.send),
        ),
      ],
    );
  }

  Widget buildMessageList(BuildContext context, String chatId) {
    return StreamBuilder<List<Message>>(
      stream: Provider.of<ChatProvider>(context).chat(chatId),
      builder: (_ctx, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        print(snapshot.data);
        if (snapshot.hasData) {
          return Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(5),
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              controller: _controller,
              itemBuilder: (_ctx, i) {
                // TODO wrap in another widget
                return ChatMessage(message: snapshot.data![i]);
              },
            ),
          );
        } else {
          return Center(
            child: Text("No messages..."),
          );
        }
      },
    );
  }


}


