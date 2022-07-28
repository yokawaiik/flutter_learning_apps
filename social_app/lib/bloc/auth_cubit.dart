import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:social_app/constants/cloud_firestore.dart' as Constants;

// include parts
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);

      emit(AuthSignedIn());
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      } else {
        print(e);
        message = 'Undefined error';
      }
      emit(AuthFailure(message: message));
    } catch (e) {
      emit(AuthFailure(message: "An error has occured"));
    }
  }

  Future<void> signUp({
    required String email,
    required String userName,
    required String password,
  }) async {
    emit(AuthLoading());
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      final UserCredential userCredential = await auth
          .createUserWithEmailAndPassword(email: email, password: password);
      // create document with id by user
      await FirebaseFirestore.instance
          .collection(Constants.USERS)
          .doc(userCredential.user!.uid)
          .set({
        Constants.U_USER_ID: userCredential.user!.uid,
        Constants.U_USER_NAME: userName,
        Constants.U_EMAIL: email,
      });

      userCredential.user!.updateDisplayName(userName);
      
      // FirebaseAuth.instance.currentUser!.reload();

      emit(AuthSignedUp());
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else {
        message = "Undefined error: $e";
      }
      print(e);
      emit(AuthFailure(message: message));
    } catch (e) {
      print(e);
      emit(AuthFailure(message: "An error has occured"));
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      emit(AuthFailure(message: "An error has occured"));
    }
  }
}
