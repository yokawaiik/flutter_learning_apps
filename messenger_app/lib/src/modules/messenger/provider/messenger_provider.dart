import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger_app/src/core/models/api_exception.dart';
import 'package:messenger_app/src/core/models/finded_user.dart';
import 'package:messenger_app/src/modules/messenger/models/chat.dart';
import 'package:messenger_app/src/modules/messenger/models/chat_user.dart';

class MessengerProvider {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future<List<FindedUser>?> usersSearch(String query) async {
    try {
      final snapshot = await _db
          .collection("users")
          // .where('login', isNotEqualTo: _auth.currentUser!.uid)
          // .where('login', isGreaterThan: _auth.currentUser!.uid)
          // .where('login', isNotEqualTo: query)
          // .where('login', isGreaterThan: query)
          .where('login', isGreaterThanOrEqualTo: query)
          .get();

      if (snapshot.docs.isEmpty) return null;

      final List<FindedUser>? findedUsers = snapshot.docs
          .where((doc) => doc.id != _auth.currentUser!.uid)
          .map((doc) {
        return FindedUser.fromDoc(id: doc.id, doc: doc.data());
      }).toList();

      return findedUsers;
    } on FirebaseException catch (e) {
      print(e);
      throw ApiException(e.toString());
    } catch (e) {
      print(e);
      throw ApiException("unknown error.");
    }
  }

  Stream<List<Chat>> get userChats {
    return _db
        .collection("chats")
        
        .where(
          "users",
          arrayContains: _auth.currentUser!.uid,
        )
        .orderBy("date")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Chat.fromJson(
                  docId: doc.id,
                  data: doc.data(),
                  currentUserUid: _auth.currentUser!.uid,
                ))
            .toList());
  }

  Future<void> removeChat(String chatId) async {
    try {
      final chat = await _db
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .get();

      for (var doc in chat.docs) {
        await _db
            .collection("chats")
            .doc(chatId)
            .collection("messages")
            .doc(doc.id)
            .delete();
      }

      await _db.collection("chats").doc(chatId).delete();
    } on FirebaseException catch (e) {
      print(e);
      rethrow;
    } catch (e) {
      print(e);
      throw ApiException("Unknown error.");
    }
  }
}
