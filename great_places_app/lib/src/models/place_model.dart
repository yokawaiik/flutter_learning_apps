import 'dart:io';

import 'package:great_places_app/src/models/place_location_model.dart';

class PlaceModel {
  final String id;
  final String title;
  final PlaceLocationModel? location;
  final File image;

  PlaceModel({
    required this.id,
    required this.title,
     this.location,
    required this.image,
  });
}
