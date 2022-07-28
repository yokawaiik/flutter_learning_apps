import 'dart:io';

import 'package:great_places_app/src/models/place_location_model.dart';

class AddPlaceModel {
  File? pickedImage;
  String? placeTitle;

  PlaceLocationModel? placeLocation;


  AddPlaceModel({
    this.pickedImage,
    this.placeTitle,
    this.placeLocation,
  });
}
