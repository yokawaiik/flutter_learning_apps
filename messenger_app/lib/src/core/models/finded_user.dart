import 'package:cloud_firestore/cloud_firestore.dart';

class FindedUser {
  late String uid;
  late String email;
  late String fullName;
  late String login;
  late String? imageProfileUrl;

  FindedUser({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.login,
  });

  FindedUser.fromDoc({required String id, required Map<String?, dynamic> doc}) {
    uid = id;
    email = doc["email"];
    fullName = doc["fullName"];
    login = doc["login"];
    imageProfileUrl = doc["imageProfileUrl"];
  }
}
