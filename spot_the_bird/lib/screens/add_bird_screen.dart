import 'dart:io';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:spot_the_bird/bloc/bird_post_cubit.dart';
import 'package:spot_the_bird/models/bird_post_model.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class AddBirdScreen extends StatefulWidget {
  final LatLng latLng;
  final File image;

  AddBirdScreen({required this.latLng, required this.image});

  @override
  _AddBirdScreenState createState() => _AddBirdScreenState();
}

class _AddBirdScreenState extends State<AddBirdScreen> {
  String? name;
  String? description;

  final _formKey = GlobalKey<FormState>();
  late final FocusNode _descriptionFocusNode;

  @override
  void initState() {
    _descriptionFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _submit() {
    // SAve to Cubit
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    final BirdModel birdModel = BirdModel(
      birdName: name,
      birdDescription: description,
      latitude: widget.latLng.latitude,
      longitude: widget.latLng.longitude,
      image: widget.image,
    );

    // save to cubit
    context.read<BirdPostCubit>().addBirdPost(birdModel);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading:
        title: Text("App Bird"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          // scroll widget
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width / 1.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: FileImage(widget.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  TextFormField(
                    focusNode: _descriptionFocusNode,
                    onSaved: (value) => name = value!.trim(),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      // Move focus
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a name...";
                      }
                      if (value.length < 2) {
                        return "Please enter a longer name...";
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter a Bird name",
                    ),
                  ),
                  TextFormField(
                    focusNode: _descriptionFocusNode,
                    onSaved: (value) => description = value!,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a description...";
                      }
                      if (value.length < 2) {
                        return "Please enter a longer description...";
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter a description",
                    ),
                    onFieldSubmitted: (_) {
                      _submit();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Save Bird Post
          _submit();
        },
        child: Icon(Icons.check, size: 30),
      ),
    );
  }
}
