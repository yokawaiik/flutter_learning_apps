import 'package:flutter/material.dart';

class StyleButton extends StatelessWidget {

  final Function() onPressed;
  final String label;

  StyleButton({Key? key, required this.label, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text(label),
      color: Colors.purple[100],
      onPressed: onPressed,
      );
  }
}
