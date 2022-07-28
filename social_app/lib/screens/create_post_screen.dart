import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:social_app/constants/cloud_firestore.dart' as Constants;

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  static const String id = "Create post";

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  String _description = "";

  late String imageUrl;

  void _submit({required File image}) async {
    FocusScope.of(context).unfocus();
    // 1. write image to storage
    if (_description.trim().isNotEmpty) {
      firebase_storage.FirebaseStorage storage =
          firebase_storage.FirebaseStorage.instance;

      await storage
          .ref("images/${UniqueKey().toString()}.png")
          .putFile(image)
          .then((taskSnapshot) async {
        imageUrl = await taskSnapshot.ref.getDownloadURL();
      });

      FirebaseFirestore.instance.collection(Constants.POSTS).add(
        {
          Constants.P_TIMESTAMP: Timestamp.now(),
          Constants.P_USER_ID: FirebaseAuth.instance.currentUser!.uid,
          Constants.P_DESCRIPTION: _description,
          Constants.P_USER_NAME: FirebaseAuth.instance.currentUser!.displayName,
          Constants.P_IMAGE_URL: imageUrl,
        },
      ).then((docRef) => docRef.update({
            Constants.P_POST_ID: docRef.id,
          }));

          Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final File imageFile = ModalRoute.of(context)!.settings.arguments as File;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Create post"),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: FileImage(imageFile),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: "Enter a description",
                    ),
                    textInputAction: TextInputAction.done,
                    // Limits number of symbols for post
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(150),
                    ],
                    onChanged: (value) {
                      _description = value;
                    },
                    onEditingComplete: () {
                      // todo: create _submit
                      _submit(image: imageFile);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
