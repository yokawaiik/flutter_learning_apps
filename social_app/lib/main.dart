import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/bloc/auth_cubit.dart';
import 'package:social_app/screens/chat_screen.dart';

import 'package:social_app/screens/create_post_screen.dart';
import 'package:social_app/screens/posts_screen.dart';
import 'package:social_app/screens/sign_in_screen.dart';
import 'package:social_app/screens/sign_up_screen.dart';

import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  
  await dotenv.load(fileName: ".env");

  // add crashlytics
  await SentryFlutter.init((options) {
    options.dsn =
        dotenv.env["SENTRY_API_KEY"];
  }, appRunner: () async {
    
    // Add Firebase in app
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // return SignIn if doesnt have auth
  Widget _buildHomeScreen() {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> snapshot) {

          if (snapshot.connectionState == ConnectionState.none) {
            // splash
            return Scaffold(
              body: Center(
                child: Text("No connection"),
              ),
            );
          }

          if (snapshot.hasData) {
            return PostsScreen();
          } else {
            return SignInScreen();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: _buildHomeScreen(),
        routes: {
          SignUpScreen.id: (context) => SignUpScreen(),
          SignInScreen.id: (context) => SignInScreen(),
          PostsScreen.id: (context) => PostsScreen(),
          CreatePostScreen.id: (context) => CreatePostScreen(),
          ChatScreen.id: (context) => ChatScreen(),
        },
      ),
    );
  }
}
