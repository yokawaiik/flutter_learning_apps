import 'dart:io';

import 'package:flutter/material.dart';
import 'package:great_places_app/src/models/add_place_model.dart';
import 'package:great_places_app/src/models/place_location_model.dart';
import 'package:great_places_app/src/providers/great_places_provider.dart';
import 'package:great_places_app/src/screens/map_screen.dart';
import 'package:great_places_app/src/widgets/image_input.dart';
import 'package:latlong2/latlong.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class AddPlaceScreen extends StatefulWidget {
  static const String routeName = 'AddPlaceScreen';

  const AddPlaceScreen({Key? key}) : super(key: key);

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final GlobalKey<FormState> _form = GlobalKey();
  bool _isValid = false;

  AddPlaceModel _addPlace = AddPlaceModel();

  void _selectImage(File pickedImage) {
    _addPlace.pickedImage = pickedImage;
    setState(() {
      _isFormValid();
    });
  }

  void _isFormValid([BuildContext? context]) {
    if (!_form.currentState!.validate() ||
        _addPlace.pickedImage == null ||
        _addPlace.placeLocation == null) {
      _isValid = false;
    } else {
      _isValid = true;
      return;
    }

    if (context == null) return;

    if (_addPlace.placeLocation == null) {
      _selectLocation(context);
    }
  }

  void _selectLocation(BuildContext context) async {
    final placeLocation = await Navigator.of(context)
        .pushNamed(MapScreen.routeName) as PlaceLocationModel;

    _addPlace.placeLocation = placeLocation;

    print(placeLocation.toString());

    setState(() {
      _isFormValid();
    });
  }

  void _savePlace(BuildContext context) {
    _isFormValid(context);

    if (!_isValid) return;

    _form.currentState!.save();

    Provider.of<GreatPlacesProvider>(context, listen: false)
        .addPlace(_addPlace);

    Navigator.of(context).pop();
  }

  void _addPosition(PlaceLocationModel selectedPosition) {
    _addPlace.placeLocation = selectedPosition;
  }

  @override
  Widget build(BuildContext context) {
    int _currentBottomNavigator = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add a new place"),
      ),
      body: Form(
        onChanged: () {
          setState(() {
            _isFormValid();
          });
        },
        key: _form,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    ImageInput(
                      onSelectImage: _selectImage,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Title'),
                      onChanged: (v) {
                        _addPlace.placeTitle = v;
                      },
                      validator: (v) {
                        if (v == null || v.length == 0)
                          return "Please fill this field.";
                        if (v.length < 5 || v.length > 200)
                          return "the field should not contain more than 200 symbols and less than 5 characters";
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        _selectLocation(context);
                      },
                      icon: Icon(Icons.location_on),
                      label: Text("Select my location"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _isValid
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: Icon(Icons.add),
              onPressed: () {
                _savePlace(context);
              },
            )
          : FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(Icons.location_on),
              onPressed: () {
                _selectLocation(context);
              },
            ),
    );
  }
}
