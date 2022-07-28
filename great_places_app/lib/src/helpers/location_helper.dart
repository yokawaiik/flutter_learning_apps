import 'package:great_places_app/src/models/place_location_model.dart';
import 'package:great_places_app/src/utils/check_internet.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as Location;
import 'package:geocoding/geocoding.dart' as Geocoding;

Future<LatLng?> getCurrentUserPosition() async {
  try {
    final isHasInternet = await check();
    // print(isHasInternet);
    if (!isHasInternet) throw Error();

    final location = Location.Location();

    bool _serviceEnabled;
    Location.PermissionStatus _permissionGranted;
    Location.LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        throw Error();
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == Location.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != Location.PermissionStatus.granted) {
        throw Error();
      }
    }

    final locationData = await location.getLocation();

    return LatLng(locationData.latitude!, locationData.longitude!);
  } catch (e) {
    return null;
  }
}

Future<PlaceLocationModel?> getAdressWithLatLng(LatLng position) async {
  try {
    final isHasInternet = await check();
    // print(isHasInternet);
    if (!isHasInternet) throw Error();

    List<Geocoding.Placemark> placemarks =
        await Geocoding.placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    final outputAdress = PlaceLocationModel(
      latitude: position.latitude,
      longitude: position.longitude,
      adress:
          "${placemarks[0].country}, ${placemarks[0].administrativeArea}, ${placemarks[0].street}",
    );

    return outputAdress;
  } catch (e) {
    return null;
  }
}

Future<PlaceLocationModel?> getAdressWithWrite(String inputAdress) async {
  try {
    final isHasInternet = await check();
    // print(isHasInternet);
    if (!isHasInternet) throw Error();

    final place = await Geocoding.locationFromAddress(inputAdress);

    final outputAdress = PlaceLocationModel(
      latitude: place[0].latitude,
      longitude: place[0].longitude,
      adress: inputAdress,
    );

    return outputAdress;
  } catch (e) {
    return null;
  }
}
