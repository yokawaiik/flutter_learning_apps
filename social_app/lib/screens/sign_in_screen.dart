import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:social_app/bloc/auth_cubit.dart';
import 'package:social_app/screens/posts_screen.dart';

import 'package:social_app/screens/sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  static const String id = "Sign in";

  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  String _email = "";
  String _password = "";

  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();

    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _passwordFocusNode.dispose();
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      //  invalid
      return;
    }

    _formKey.currentState!.save();

    context.read<AuthCubit>().signIn(email: _email, password: _password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (prevState, currentState) {
          // if (currentState is AuthSignedIn) {
          //   Navigator.of(context).pushReplacementNamed(PostsScreen.id);
          
          // }
          if (currentState is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(currentState.message),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return Form(
            key: _formKey,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Text(
                          'Social Media App',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      // email
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        focusNode: _passwordFocusNode,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          labelText: "Enter your email",
                        ),
                        // go focus to TextFormField down
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_passwordFocusNode);
                        },
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          _email = value!.trim();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your email";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      // password
                      TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          labelText: "Enter your password",
                        ),
                        // symbol for password
                        obscureText: true,
                        onFieldSubmitted: (_) {
                          _submit(context);
                        },
                        textInputAction: TextInputAction.done,
                        onSaved: (value) {
                          _password = value!.trim();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your password";
                          }
                          if (value.length < 5) {
                            return "Password too short";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextButton(
                        onPressed: () {
                          _submit(context);
                        },
                        child: Text('Sign in'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(SignUpScreen.id);
                        },
                        child: Text('Sign up instead'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
