import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  String? uid;
  String? email;
  String? userName;

  AuthUser({
    required this.uid,
    required this.email,
    required this.userName,
  });

  AuthUser.fromFirebaseUser({User? user}) {
    uid = user!.uid;
    email = user.email;
    userName = user.displayName;
  }
}