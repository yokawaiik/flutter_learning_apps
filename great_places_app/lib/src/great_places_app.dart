import 'package:flutter/material.dart';
import 'package:great_places_app/src/providers/great_places_provider.dart';
import 'package:great_places_app/src/screens/add_place_screen.dart';
import 'package:great_places_app/src/screens/map_place_detail_screen.dart';
import 'package:great_places_app/src/screens/map_screen.dart';
import 'package:great_places_app/src/screens/place_detail_screen.dart';
import 'package:great_places_app/src/screens/places_list_screen.dart';
import 'package:provider/provider.dart';

class GreatPlacesApp extends StatelessWidget {
  const GreatPlacesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<GreatPlacesProvider>(
              create: (ctx) => GreatPlacesProvider()),
        ],
        builder: (context, child) {
          return MaterialApp(
            // theme: ThemeData(primarySwatch: Colors.grey),
            theme: ThemeData(
              primarySwatch: Colors.grey,
              colorScheme: const ColorScheme(
                primary: Color(0xff999999),
                primaryVariant: Color(0xff4d4d4d),
                secondary: Colors.teal,
                secondaryVariant: Color(0xff4d4d4d),
                surface: Color(0xffffffff),
                background: Color(0xffcccccc),
                error: Color(0xffd32f2f),
                onPrimary: Color(0xffffffff),
                onSecondary: Color(0xffffffff),
                onSurface: Color(0xff000000),
                onBackground: Color(0xffffffff),
                onError: Color(0xffffffff),
                brightness: Brightness.light,
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.teal,
              ),
            ),
            home: PlacesListScreen(),
            routes: {
              PlacesListScreen.routeName: (_ctx) => PlacesListScreen(),
              PlaceDetailScreen.routeName: (_ctx) => PlaceDetailScreen(),
              AddPlaceScreen.routeName: (_ctx) => AddPlaceScreen(),
              MapScreen.routeName: (_ctx) => MapScreen(),
              MapPlaceDetailScreen.routeName: (_ctx) => MapPlaceDetailScreen(),
            },
          );
        });
  }
}
