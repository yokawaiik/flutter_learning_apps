import 'package:flutter/material.dart';
import 'package:messenger_app/src/modules/auth/provider/auth_provider.dart';
import 'package:messenger_app/src/modules/chat/screens/chat_screen.dart';
import 'package:messenger_app/src/modules/messenger/models/chat.dart';
import 'package:messenger_app/src/modules/messenger/models/chat_user.dart';
import 'package:messenger_app/src/modules/messenger/provider/messenger_provider.dart';
import 'package:messenger_app/src/modules/messenger/utils/search_users.dart';
import 'package:messenger_app/src/modules/messenger/widgets/chat_tile.dart';
import 'package:messenger_app/src/modules/profile/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class MessengerScreen extends StatefulWidget {
  static const String routeName = "MessengerScreen";

  const MessengerScreen({Key? key}) : super(key: key);

  @override
  State<MessengerScreen> createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {
  void _showSearch(
    BuildContext context,
  ) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text("Messages"),
        // centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchUsers());
            },
            icon: Icon(Icons.search),
          ),
          Spacer(),
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (String i) {
              switch (i) {
                case "0":
                  context.read<AuthProvider>().signOut();
                  break;
                case "1":
                  Navigator.of(context).pushNamed(ProfileScreen.routeName);
                  break;
              }
            },
            itemBuilder: (BuildContext ctx) => [
              const PopupMenuItem<String>(
                value: "0",
                child: Text('Sign Out'),
              ),
              const PopupMenuItem<String>(
                value: "1",
                child: Text('My Profile'),
              ),
            ],
          )
        ],
      ),
      body: StreamBuilder<List<Chat>?>(
        stream: Provider.of<MessengerProvider>(context).userChats,
        builder: (_ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

           if (snapshot.hasError) {
            return Center(
              child: Icon(
                Icons.error,
                size: 200,
                color: Theme.of(context).colorScheme.error,
              ),
            );
          }

          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(
              child: Icon(
                Icons.person_off,
                size: 200,
              ),
            );
          }
          final chats = snapshot.data;
          print(chats);

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            itemCount: chats!.length,
            itemBuilder: (_ctx, i) {
              final user = chats[i].users![0];

              return ChatTile(chatId: chats[i].id, user: user);
            },
          );
        },
      ),
    );
  }
}
