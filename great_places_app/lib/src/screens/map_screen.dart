import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:great_places_app/src/models/place_location_model.dart';
import 'package:great_places_app/src/providers/great_places_provider.dart';
import 'package:great_places_app/src/utils/check_internet.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

import '../helpers/location_helper.dart' as LocationHelper;

class MapScreen extends StatefulWidget {
  static const String routeName = "MapScreen";
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _currentPosition;
  String? _adress;

  late final _mapController = MapController();

  final List<LatLng> _markers = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getCurrentUserLocation();
  }

  Future<void> _backScreenWithData(BuildContext context) async {
    final placeLocationModel = PlaceLocationModel(
      latitude: _currentPosition?.latitude ?? 0,
      longitude: _currentPosition?.longitude ?? 0,
      adress: _adress ?? "No data",
    );

    Navigator.of(context).pop(placeLocationModel);
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final position = await LocationHelper.getCurrentUserPosition();
      _currentPosition = position;
      _getAdress();

      setState(() {
        _markerAdd(_currentPosition!);
        _mapController.move(_currentPosition!, 16);
      });
    } catch (e) {
      // print('_getCurrentUserLocation: $e');
    }
  }

  Future<void> _getAdress() async {
    try {
      final placeLocation =
          await LocationHelper.getAdressWithLatLng(_currentPosition!)
              as PlaceLocationModel;
      _adress = placeLocation.adress;
    } catch (e) {
      // print("_getAdress: $e");
    }
  }

  Future<void> _getWritedAdress(BuildContext context, String adress) async {
    try {
      final placeLocation = await LocationHelper.getAdressWithWrite(adress);

      _currentPosition!.latitude = placeLocation!.latitude!;
      _currentPosition!.longitude = placeLocation.longitude!;
      _adress = adress;

      setState(() {
        _markerAdd(_currentPosition!);
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Incorrect adress.")));
    }
  }

  void _markerAdd(LatLng position) {
    _markers.clear();
    _markers.add(position);
  }

  void _onLongMapPress(LatLng latLng) async {
    await _getAdress();
    setState(() {
      _markerAdd(latLng);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _backScreenWithData(context);

        return false;
      },
      child: Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              FlutterMap(
                key: ValueKey(MediaQuery.of(context).orientation),
                // key: const ValueKey("Map"),
                mapController: _mapController,
                options: MapOptions(
                  onLongPress: (_position, latLng) {
                    _onLongMapPress(latLng);
                  },
                  zoom: 17,
                  maxZoom: 20,
                  minZoom: 15,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayerOptions(
                    markers: [
                      if (_markers.isNotEmpty)
                        ..._markers
                            .map((markerPosition) => Marker(
                                  point: markerPosition,
                                  builder: (ctx) => Icon(
                                    Icons.location_on,
                                    size: 50,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ))
                            .toList(),
                    ],
                  ),
                ],
              ),
              FloatingSearchBar(
                automaticallyImplyBackButton: false,
                onSubmitted: (v) {
                  if (v.isEmpty) return;
                  _getWritedAdress(context, v);
                },
                builder: (_ctx, transition) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                  );
                },
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _getCurrentUserLocation();
            },
            child: Icon(Icons.my_location),
          )),
    );
  }
}
