import 'package:flutter/material.dart';
import 'package:great_places_app/src/models/place_model.dart';
import 'package:great_places_app/src/providers/great_places_provider.dart';
import 'package:great_places_app/src/screens/map_place_detail_screen.dart';
import 'package:great_places_app/src/screens/map_screen.dart';
import 'package:provider/provider.dart';

class PlaceDetailScreen extends StatelessWidget {
  static const String routeName = 'PlaceDetailScreen';

  const PlaceDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;

    String id = ModalRoute.of(context)!.settings.arguments.toString();

    final appBar = AppBar(
      title: const Text("Place Detail"),
    );

    return Scaffold(
      appBar: appBar,
      body: FutureBuilder<PlaceModel?>(
        future: Provider.of<GreatPlacesProvider>(context, listen: false)
            .findById(id),
        builder: (_ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
            );
          }

          if (!snapshot.hasData || snapshot.error == true) {
            return Center(
              child: Text("Ops... Error!"),
            );
          }

          return LayoutBuilder(builder: (_ctx, constraints) {
            return Column(
              children: [
                SizedBox(
                  height: constraints.maxHeight / 2,
                  child: Stack(
                    children: [
                      Image.file(
                        snapshot.data!.image,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 10),
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.7),
                          child: Text(
                            snapshot.data!.title,
                            style: TextStyle(
                              letterSpacing: 1,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .fontSize,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(snapshot.data!.location!.adress!)
              ],
            );
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(MapPlaceDetailScreen.routeName, arguments: id);
        },
        child: const Icon(Icons.map),
      ),
    );
  }
}
