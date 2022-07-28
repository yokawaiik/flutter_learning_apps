import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:spot_the_bird/bloc/bird_post_cubit.dart';
import 'package:spot_the_bird/bloc/location_cubit.dart';
import 'package:spot_the_bird/models/bird_post_model.dart';
import 'package:spot_the_bird/screens/add_bird_screen.dart';

import 'package:image_picker/image_picker.dart';
import 'package:spot_the_bird/screens/bird_info_screen.dart';

class MapScreen extends StatelessWidget {
  MapScreen({Key? key}) : super(key: key);

  final MapController _mapController = MapController();

  // pick image after lon tap on map
  Future<void> _pickImageAndCreatePost({
    required BuildContext context,
    required LatLng latLng,
  }) async {
    File? image;

    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 40);

    if (pickedFile != null) {
      image = File(pickedFile.path);

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddBirdScreen(latLng: latLng, image: image!)));
    } else {
      print("user didn't pick image");
    }
  }

  List<Marker> _buildMarkers(BuildContext context, List<BirdModel> birdPosts) {
    List<Marker> markers = [];

    birdPosts.forEach((post) {
      markers.add(Marker(
        width: 44,
        height: 55,
        point: LatLng(post.latitude, post.longitude),
        builder: (ctx) => GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BirdInfoScreen(birdModel: post)));
          },
          child: Image.asset('assets/bird_icon.png'),
        ),
      ));
    });

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocListener<LocationCubit, LocationState>(
          listener: (previousState, currentState) {
            if (currentState is LocationLoaded) {
              _mapController.onReady.then((value) => _mapController.move(
                  LatLng(currentState.latitude, currentState.longitude), 14));
            }

            if (currentState is LocationError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: Duration(seconds: 2),
                backgroundColor: Colors.red.withOpacity(0.5),
                content: Text('Error, unable to fetch location'),
              ));
            }
          },
          child: BlocBuilder<BirdPostCubit, BirdPostState>(
            buildWhen: (prevState, currentState) =>
                (prevState.status != currentState.status),
            builder: (context, birdPosState) {
              return FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: LatLng(0, 0),
                  zoom: 15.3,
                  maxZoom: 17,
                  minZoom: 3.5,
                  onLongPress: (tapPosition, latLng) {
                    _pickImageAndCreatePost(context: context, latLng: latLng);
                  },
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                    retinaMode: true,
                  ),
                  MarkerLayerOptions(
                    markers: _buildMarkers(context, birdPosState.birdPosts),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
