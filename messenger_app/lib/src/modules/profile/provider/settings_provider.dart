import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:messenger_app/src/core/models/api_exception.dart';
import 'package:messenger_app/src/modules/profile/models/user_profile.dart';


class SettingsProvider {
  final _auth = FirebaseAuth.instance;
  final _firebaseStorage = FirebaseStorage.instance;
  final _db = FirebaseFirestore.instance;

  // final _user = 'users/';

  Future<void> setProfileImage(File image) async {
    try {
      final snapshot = await _firebaseStorage
          .ref()
          .child("users")
          .child('/${_auth.currentUser!.uid}')
          .child("profile")
          .child("imageProfileUrl.jpg")
          .putFile(image);

      final filePath = await _firebaseStorage.ref(snapshot.ref.fullPath).getDownloadURL();

      await _db.collection("users").doc(_auth.currentUser!.uid).update(
        {"imageProfileUrl": filePath},
      );
    } on FirebaseException catch (e) {
      print(e);
      throw ApiException("Error uploading image.");
    } catch (e) {
      print(e);
      throw ApiException("Unknown error.");
    }
  }

  Future<String?> loadProfileImage() async {
    try {
      final ref = await _firebaseStorage
          .ref()
          .child("users")
          .child('/${_auth.currentUser!.uid}')
          .child("profile")
          .child("imageProfileUrl.jpg")
          .getDownloadURL();

      return ref;
    } on FirebaseException catch (e) {
      print(e);

      return null;
    } catch (e) {
      print(e);
      throw ApiException("Unknown error.");
    }
  }

}
