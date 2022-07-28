import 'dart:math';

import 'package:flutter/material.dart';
import 'package:messenger_app/src/modules/auth/models/auth_form.dart';
import 'package:messenger_app/src/modules/auth/provider/auth_provider.dart';
import 'package:messenger_app/src/modules/messenger/screens/messenger_screen.dart';
import 'package:messenger_app/src/modules/auth/widgets/password_form_field.dart';
import 'package:messenger_app/src/modules/auth/widgets/password_form_field.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = "AuthScreen";

  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late AuthForm _authForm;

  late bool _isSignUp;
  late bool _userIsAgree;

  late bool _isFormSend;

  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _isSignUp = false;

    _userIsAgree = false;
    _isFormSend = false;

    _formKey = GlobalKey<FormState>();
    _authForm = AuthForm();

    super.initState();
  }

  void _toggleAuthMode() {
    setState(() {
      _isSignUp = !_isSignUp;
    });
  }

  Future<void> _sendForm() async {
    try {
      if (!_isFormValid()) return;
      _isFormSend = true;
      _formKey.currentState!.save();
      if (_isSignUp) {
        await Provider.of<AuthProvider>(context, listen: false)
            .signUp(_authForm);
      } else {
        await Provider.of<AuthProvider>(context, listen: false)
            .signIn(_authForm);
      }

      _isFormSend = false;
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      _isFormSend = false;
    }
  }

  bool _isFormValid() {
    final isFormValid = _formKey.currentState!.validate();

    if (_isSignUp) {
      if (isFormValid && _authForm.agree == true) return true;
    } else {
      if (isFormValid) return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                  right: 20,
                  left: 20,
                  bottom: 30,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _isSignUp ? "Sign Up" : "Sign In",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      if (_isSignUp)
                        ...[
                          TextFormField(
                            initialValue: _authForm.fullName,
                            onChanged: (v) {
                              _authForm.fullName = v;
                            },
                            validator: (v) {
                              if (v == null || v.isEmpty)
                                return "This field must to does not empty";

                              if (v.length > 20 || v.length < 2)
                                return "This field can't be more 40 symbols and less 8";

                              return null;
                            },
                            decoration: InputDecoration(
                              label: Text("Full name"),
                              hintText: "Enter your full name",
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            initialValue: _authForm.login,
                            onChanged: (v) {
                              _authForm.login = v.replaceAll(' ', '');
                            },
                            validator: (v) {
                              if (v == null || v.isEmpty)
                                return "This field must to does not empty";

                              final trimmedValue = v.replaceAll(' ', '');
                              if (trimmedValue.length > 20 ||
                                  trimmedValue.length < 2)
                                return "This field can't be more 40 symbols and less 8";

                              return null;
                            },
                            decoration: InputDecoration(
                              label: Text("Login"),
                              hintText: "Enter your Login",
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ].toList(),
                      TextFormField(
                        initialValue: _authForm.email,
                        onChanged: (v) {
                          _authForm.email = v;
                        },
                        validator: (v) {
                          bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(v ?? "");

                          if (v!.length > 100 || v.length < 8)
                            return "Email does not should be more 100 symbols and less 8";

                          if (emailValid == true) {
                            return null;
                          } else {
                            return "Email id should be valid";
                          }
                        },
                        decoration: InputDecoration(
                          label: Text("Email"),
                          hintText: "user@gmail.com",
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      PasswordFormField(
                        label: "Password",
                        value: _authForm.password,
                        onChanged: (v) {
                          _authForm.password = v;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (_isSignUp)
                        ...[
                          PasswordFormField(
                            label: "Repeat password",
                            value: _authForm.repeatPassword,
                            onChanged: (v) {
                              _authForm.repeatPassword = v;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CheckboxListTile(
                            title: Text("Agree wih terms"),
                            contentPadding: EdgeInsets.all(0),
                            controlAffinity: ListTileControlAffinity.leading,
                            value: _authForm.agree,
                            onChanged: (v) {
                              setState(() {
                                _authForm.agree = v!;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ].toList(),
                      Builder(builder: (context) {
                        return SizedBox(
                          height: 59,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isFormSend
                                ? null
                                : () {
                                    _sendForm();
                                  },
                            child: _isFormSend
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Text(
                                    _isSignUp ? "Sign Up" : "Sign In",
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                    ),
                                  ),
                          ),
                        );
                      }),
                      SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        onPressed: () {
                          _toggleAuthMode();
                        },
                        child: Text(!_isSignUp ? "Sign Up" : "Sign In"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
