import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger_app/src/core/models/api_exception.dart';
import 'package:messenger_app/src/modules/chat/models/message.dart';

class ChatProvider {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Stream<List<Message>> chat(String chatId) {
    return _db
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy('date')
        .snapshots()
        .map((snapShot) => snapShot.docs
            .map(
              (doc) => Message.fromDoc(doc, _auth.currentUser!.uid),
            )
            .toList());
  }

  Future<void> sendMessage(String textMessage, String chatId) async {
    try {
      await _db.collection("chats").doc(chatId).collection("messages").add({
        "date": Timestamp.now(),
        "uid": _auth.currentUser!.uid,
        "text": textMessage,
      });
    } on FirebaseException catch (e) {
      print(e);
      throw ApiException("Error send message.");
    } catch (e) {
      print(e);
      throw ApiException("Unknown error.");
    }
  }
}
