import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:great_places_app/src/models/add_place_model.dart';
import 'package:great_places_app/src/models/place_location_model.dart';
import 'package:great_places_app/src/models/place_model.dart';

import '../helpers/db_helper.dart' as DBHelper;
import '../constants/database.dart' as DBconstants;

class GreatPlacesProvider with ChangeNotifier {
  List<PlaceModel> _places = [];

  List<PlaceModel> get places => [..._places];

  void addPlace(AddPlaceModel addPlace) {
    final newPlace = PlaceModel(
      id: DateTime.now().toString(),
      title: addPlace.placeTitle!,
      location: addPlace.placeLocation,
      image: addPlace.pickedImage!,
    );

    _places.add(newPlace);
    notifyListeners();

    DBHelper.insert(DBconstants.userPlaces, {
      DBconstants.placesId: newPlace.id,
      DBconstants.placesTitle: newPlace.title,
      DBconstants.placesImage: newPlace.image.path,
      DBconstants.placesLatitude: newPlace.location!.latitude,
      DBconstants.placesLongitude: newPlace.location!.longitude,
      DBconstants.placesAdress: newPlace.location!.adress,
    });
  }

  Future<void> loadAndSetPlaces() async {
    final placesData = await DBHelper.select(DBconstants.userPlaces);

    _places = placesData.map((item) {
      return PlaceModel(
        id: item[DBconstants.placesId],
        title: item[DBconstants.placesTitle],
        image: File(item[DBconstants.placesImage]),
        location: PlaceLocationModel(
          latitude: item[DBconstants.placesLatitude],
          longitude: item[DBconstants.placesLongitude],
          adress: item[DBconstants.placesAdress],
        ),
      );
    }).toList();

    notifyListeners();
  }

  Future<PlaceModel?> findById(String id) async {
    try {
      final dbRecord =
          await DBHelper.selectPlaceById(DBconstants.userPlaces, id)
              as Map<String, dynamic>;

      return PlaceModel(
        id: dbRecord[DBconstants.placesId],
        title: dbRecord[DBconstants.placesTitle],
        image: File(dbRecord[DBconstants.placesImage]),
        location: PlaceLocationModel(
          latitude: dbRecord[DBconstants.placesLatitude],
          longitude: dbRecord[DBconstants.placesLongitude],
          adress: dbRecord[DBconstants.placesAdress],
        ),
      );
    } catch (e) {
      // print(e);
      return null;
    }
  }

  Future<PlaceLocationModel?> getPlaceLocation(String id) async {
    try {
      final record =
          await DBHelper.selectPlaceLocationById(DBconstants.userPlaces, id) as Map<String, dynamic>;

      // print(record);

      return PlaceLocationModel(
        latitude: record[DBconstants.placesLatitude],
        longitude: record[DBconstants.placesLongitude],
        adress: record[DBconstants.placesAdress],
      );
    } catch (e) {
      return null;
    }
  }
}
