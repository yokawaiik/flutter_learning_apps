import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger_app/src/core/models/api_exception.dart';
import 'package:messenger_app/src/modules/profile/models/user_profile.dart';

class ProfileProvider {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future<UserProfile> loadUserProfile([String? uid]) async {
    try {
      late final String userUid;
      // ? current user
      if (uid == null) {
        userUid = _auth.currentUser!.uid;
      }
      // ? another user
      else {
        userUid = uid;
      }

      final doc = await _db.collection("users").doc(userUid).get();

      return UserProfile.fromDoc(
          doc: doc, currentUserId: _auth.currentUser!.uid);
    } on FirebaseException catch (e) {
      print(e);
      throw ApiException(e.toString());
    } catch (e) {
      print(e);
      throw ApiException("Unknown error");
    }
  }

  Future<String> createChat(UserProfile userProfile) async {
    try {
      // if user have  chat
      final checkChats = await _db
          .collection("chats")
          .where(
        "users",
        whereIn: [
          [_auth.currentUser!.uid, userProfile.uid],
          [userProfile.uid, _auth.currentUser!.uid],
        ],
      ).get();


  
      
      if (checkChats.size != 0) {
        return checkChats.docs.first.id;
      }
      // user new chat
      else {
        final newChat = await _db.collection("chats").add({
          "date": Timestamp.now(),
          "users": [userProfile.uid, _auth.currentUser!.uid],
          "userData": [
            {
              "fullName": userProfile.login,
              "uid":  userProfile.login,
            },
            {
              "fullName": _auth.currentUser!.displayName,
              "uid":  _auth.currentUser!.uid,
            },
          ]
        });

        return newChat.id;
      }
    } on FirebaseException catch (e) {
      print(e);
      throw ApiException(e.toString());
    } catch (e) {
      print(e);
      throw ApiException("Unknown error");
    }
  }
}
