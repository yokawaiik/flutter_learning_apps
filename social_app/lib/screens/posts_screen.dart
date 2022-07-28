import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:social_app/bloc/auth_cubit.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/screens/chat_screen.dart';
import 'package:social_app/screens/create_post_screen.dart';
import 'package:social_app/screens/sign_in_screen.dart';

import 'package:social_app/constants/cloud_firestore.dart' as CfConstants;

class PostsScreen extends StatefulWidget {
  const PostsScreen({Key? key}) : super(key: key);

  static const String id = "Posts";

  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                final picker = ImagePicker();

                picker
                    .pickImage(source: ImageSource.gallery, imageQuality: 40)
                    .then((xFile) {
                  if (xFile != null) {
                    final File file = File(xFile.path);

                    Navigator.of(context).pushNamed(
                      CreatePostScreen.id,
                      arguments: file,
                    );
                  }
                });
              },
              icon: Icon(
                Icons.add,
              ),
            ),
            IconButton(
              onPressed: () {
                context.read<AuthCubit>().signOut();
              },
              icon: Icon(
                Icons.logout,
              ),
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(CfConstants.POSTS)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("Error"));
              }
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.none) {
                if (snapshot.hasError) {
                  return Container(child: Text("Loading"));
                }
              }

              return ListView.builder(
                  itemCount: snapshot.data?.docs.length ?? 0,
                  itemBuilder: (context, index) {
                    final QueryDocumentSnapshot doc =
                        snapshot.data!.docs[index];

                    final Post post = Post(
                      id: doc[CfConstants.P_POST_ID],
                      userID: doc[CfConstants.P_USER_ID],
                      userName: doc[CfConstants.P_USER_NAME],
                      timestamp: doc[CfConstants.P_TIMESTAMP],
                      imageURL: doc[CfConstants.P_IMAGE_URL],
                      description: doc[CfConstants.P_DESCRIPTION],
                    );

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(ChatScreen.id, arguments: post);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: NetworkImage(post.imageURL),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              post.userName,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              post.description,
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }),
      ),
    );
  }
}
