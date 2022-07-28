

import 'package:messenger_app/src/modules/messenger/models/chat_user.dart';

class Chat {
  late final String id;
  late final List<ChatUser>? users;
  // List<ChatUser>? users;

  Chat({
    required this.id,
    required this.users,
  });

  Chat.fromJson({
    required String docId,
    required data,
    required String currentUserUid,
  }) {
    // print(data);
    id = docId;
    final handledUserData = (data["userData"] as List<dynamic>)
        .map((user) {
          return ChatUser(
            uid: user["uid"],
            fullName: user["fullName"],
          );
        })
        .where((user) => user.uid != currentUserUid)
        .toList();

    users = handledUserData;
  }
}
