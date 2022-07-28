import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:social_app/constants/cloud_firestore.dart' as CfConstants;
import 'package:social_app/models/chat_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/widgets/message_list_tile.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key}) : super(key: key);

  static const String id = "Chat";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final currentUserID = FirebaseAuth.instance.currentUser!.uid;

  String _message = "";

  @override
  Widget build(BuildContext context) {
    final Post post = ModalRoute.of(context)!.settings.arguments as Post;

    TextEditingController _textEditingController = TextEditingController();

    @override
    void dispose() {
      _textEditingController.dispose();
      super.dispose();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(CfConstants.POSTS)
                    .doc(post.id)
                    .collection(CfConstants.COMMENTS).orderBy(CfConstants.C_TIMESTAMP)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error"),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.connectionState == ConnectionState.none) {
                    return Center(
                      child: Text("Loading"),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length ?? 0,
                    itemBuilder: (context, index) {
                      final QueryDocumentSnapshot doc =
                          snapshot.data!.docs[index];

                      final ChatModel chatModel = ChatModel(
                        userName: doc[CfConstants.C_USER_NAME],
                        userID: doc[CfConstants.C_USER_ID],
                        message: doc[CfConstants.C_MESSAGE],
                        timestamp: doc[CfConstants.C_TIMESTAMP],
                      );


                      return Align(
                          alignment: chatModel.userID ==
                                  currentUserID
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: MessageListTile(chatModel));
                    },
                  );
                },
              ),
            ),
            Container(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: TextField(
                        controller: _textEditingController,
                        maxLines: 2,
                        decoration: InputDecoration(hintText: "Enter message"),
                        onChanged: (value) {
                          _message = value;
                        },
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection(CfConstants.POSTS)
                          .doc(post.id)
                          .collection(CfConstants.COMMENTS)
                          .add({
                            CfConstants.C_USER_ID:
                                FirebaseAuth.instance.currentUser!.uid,
                            CfConstants.C_USER_NAME:
                                FirebaseAuth.instance.currentUser!.displayName,
                            CfConstants.C_MESSAGE: _message,
                            CfConstants.C_TIMESTAMP: Timestamp.now(),
                          })
                          .then((value) => print("Chat doc added"))
                          .catchError((onError) => print("Error: $onError"));

                      // ceear field
                      _textEditingController.clear;

                      setState(() {
                        _message = "";
                      });
                    },
                    icon: Icon(Icons.arrow_forward_rounded),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
