import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:great_places_app/src/models/place_location_model.dart';
import 'package:great_places_app/src/providers/great_places_provider.dart';

import 'package:latlong2/latlong.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

import '../helpers/location_helper.dart' as LocationHelper;

class MapPlaceDetailScreen extends StatefulWidget {
  static const String routeName = "MapPlaceDetailScreen";
  const MapPlaceDetailScreen({Key? key}) : super(key: key);

  @override
  _MapPlaceDetailScreenState createState() => _MapPlaceDetailScreenState();
}

class _MapPlaceDetailScreenState extends State<MapPlaceDetailScreen> {
  bool _isLoaded = false;

  late final _mapController = MapController();

  final List<LatLng> _markers = [];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (!_isLoaded) {
      _showUserPosition();
    }
  }

  void _showUserPosition() async {
    String id = ModalRoute.of(context)!.settings.arguments as String;
    final placeLocation =
        await Provider.of<GreatPlacesProvider>(context, listen: false)
            .getPlaceLocation(id);

    final position = LatLng(placeLocation!.latitude!, placeLocation.longitude!);

    _mapController.move(position, 16);
    _markers.clear();

    _isLoaded = true;

    setState(() {
      _markers.add(position);
    });

  

  }

  @override
  Widget build(BuildContext context) {
    // if user go to this screen from place detail screen
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            key: ValueKey(MediaQuery.of(context).orientation),
            mapController: _mapController,
            options: MapOptions(
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
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ))
                        .toList(),
                ],
              ),
            ],
          ),
          if (!_isLoaded) Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
            ),
          )
        ],
      ),
    );
  }
}
