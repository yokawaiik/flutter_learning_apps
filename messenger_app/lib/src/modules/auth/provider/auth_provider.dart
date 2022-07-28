import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger_app/src/core/models/api_exception.dart';
import 'package:messenger_app/src/modules/auth/models/auth_form.dart';
import 'package:messenger_app/src/modules/auth/models/auth_user.dart';

// class AuthProvider with ChangeNotifier {
class AuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late AuthUser? _authUser;


  Stream<AuthUser?>? get currentUser {
    return _auth.authStateChanges().map((User? firebaseUser) {
      if (firebaseUser == null) {
        return null;
      } else {
        _authUser = AuthUser.fromFirebaseUser(user: firebaseUser);
        return _authUser;
      }
    });
  }

  Future<void> signUp(AuthForm authForm) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: authForm.email!,
        password: authForm.password!,
      );

      final db = FirebaseFirestore.instance;

      // await db.collection('users').add({
      //   "fullName": authForm.fullName,
      //   "email": authForm.email,
      //   "login": authForm.login,
      // });
      await db.collection('users').doc(userCredential.user!.uid).set({
        "fullName": authForm.fullName,
        "email": authForm.email,
        "login": authForm.login,
        "imageProfileUrl": null,
      });

      await userCredential.user!.updateDisplayName(authForm.login!);
    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = "The account already exists for that email.";
      }

      throw ApiException(message);
    } catch (e) {
      print(e);

      rethrow;
    }
  }

  Future<void> signIn(AuthForm authForm) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: authForm.email!,
        password: authForm.password!,
      );
    } on FirebaseAuthException catch (e) {
      String message = "Sign in error";
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
      throw ApiException(message);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e);
      throw ApiException(e.toString());
    }
  }
}
