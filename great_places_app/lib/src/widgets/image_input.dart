import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;


  const ImageInput({required this.onSelectImage});

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  Color get _colorIsLoadedFile {
    if (_storedImage != null) {
      return Theme.of(context).colorScheme.primary;
    } else {
      return Theme.of(context).colorScheme.secondary;
    }
  }

  Future<void> _takePicture() async {
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (imageFile == null) return;

    setState(() {
      _storedImage = File(imageFile.path);
    });

    final appDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);

    final savedImage =
        await File(imageFile.path)
        .copy('${appDir.path}/${fileName}');

    // print(savedImage);
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    final Size device = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: _takePicture,
      child: Container(
        // width: 100,
        height: device.height / 3,

        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: _colorIsLoadedFile,
          ),
        ),
        alignment: Alignment.center,
        child: _storedImage != null
            ? Image.file(
                _storedImage!,
                fit: BoxFit.cover,
                width: double.infinity,
              )
            : Text(
                "Take picture",
                style: TextStyle(
                    color: _colorIsLoadedFile,
                    fontSize: Theme.of(context).textTheme.headline6!.fontSize),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
