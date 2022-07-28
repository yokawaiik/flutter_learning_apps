import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  late final String uid;
  late final String email;
  late final String login;
  late final String fullName;
  String? imageProfileUrl;
  late final bool isCurentUser;

  UserProfile({
    required this.uid,
    required this.email,
    required this.login,
    required this.fullName,
    required this.imageProfileUrl,
  });

  UserProfile.fromDoc({
    required DocumentSnapshot<Map<String, dynamic>> doc,
    required String currentUserId,
  }) {
    uid = doc.id;
    isCurentUser = uid == currentUserId ? true : false;

    email = doc.data()!["email"];
    login = doc.data()!["login"];
    fullName = doc.data()!["fullName"];
    imageProfileUrl = doc.data()?["imageProfileUrl"];
  }
}
