import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_app/src/modules/auth/provider/auth_provider.dart';
import 'package:messenger_app/src/modules/chat/screens/chat_screen.dart';
import 'package:messenger_app/src/modules/profile/models/user_profile.dart';
import 'package:messenger_app/src/modules/profile/provider/profile_provider.dart';
import 'package:messenger_app/src/modules/profile/provider/settings_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = "ProfileScreen";

  ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  _deleteAccount() {
    // TODO : delete current user account
    // Navigator.pop(context);

    print("_deleteAccount");
  }

  Future<void> _changePicture() async {
    try {
      print("_changePicture");
      // TODO :
      final picker = ImagePicker();

      final image =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

      if (image == null) return;
      final imageFile = File(image.path);

      await Provider.of<SettingsProvider>(context, listen: false)
          .setProfileImage(imageFile);

      // ? INFO update FutureBuilder for update image
      setState(() {});
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  _changeFullName() {
    // TODO :

    print("_changeFullName");
  }

  Future<void> _writeToUser(UserProfile userProfile) async {
    try {
      final String chatId =
          await Provider.of<ProfileProvider>(context, listen: false)
              .createChat(userProfile);

      Navigator.of(context).pop();

      Navigator.of(context).pushNamed(ChatScreen.routeName, arguments: chatId);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final userId = ModalRoute.of(context)!.settings.arguments as String?;
 

    return FutureBuilder<UserProfile>(
        future: Provider.of<ProfileProvider>(context, listen: false)
            .loadUserProfile(userId),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text("Not found user"),
            );
          }

          final user = snapshot.data;

          final appBar = AppBar(
            title: Text(user!.isCurentUser
                ? "Profile options"
                : "Profile ${user.login}"),
            actions: [
              IconButton(
                onPressed: () {
                  user.isCurentUser ? _changePicture() : _writeToUser(user);
                },
                icon: Icon(user.isCurentUser ? Icons.edit : Icons.messenger),
              ),
            ],
          );

          return Scaffold(
            appBar: appBar,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: (mediaQuery.size.height -
                            mediaQuery.padding.top -
                            appBar.preferredSize.height) *
                        (4 / 7),
                    width: double.infinity,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.3),
                    child: Stack(
                      children: [
                        user.imageProfileUrl != null
                            ? Image.network(
                                user.imageProfileUrl!,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Center(
                                child: Icon(
                                  Icons.person,
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                  size: 250,
                                ),
                              ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: _changeFullName,
                                child: Text(
                                  user.fullName,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .headline4!
                                        .fontSize,
                                  ),
                                ),
                              ),
                              Text(
                                user.email,
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .fontSize,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  if (user.isCurentUser) ...[
                    SizedBox(
                      height: 10,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 160,
                        minHeight: 0,
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          ListTile(
                            leading: Icon(Icons.logout),
                            title: Text("Logout"),
                            subtitle: Text("Exit from mesenger"),
                            onTap: () async {
                              Navigator.pop(context);
                              await Provider.of<AuthProvider>(context,
                                      listen: false)
                                  .signOut();
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.delete_forever),
                            title: Text("Delete account"),
                            subtitle: Text("Delete current user acccount"),
                            onTap: _deleteAccount,
                          ),
                        ],
                      ),
                    )
                  ],
                ],
              ),
            ),
          );
        });
  }
}
