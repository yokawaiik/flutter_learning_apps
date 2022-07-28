import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveButton extends StatelessWidget {
  final String text;
  final Function? handlerWithoutArguments;
  final Function? handlerFunction;

  const AdaptiveButton({
    required this.text,
    this.handlerWithoutArguments,
    this.handlerFunction,
  });

  void _functionSelection(BuildContext? context) {
    if (handlerWithoutArguments != null) {
      handlerWithoutArguments!();
    } else {
      handlerFunction!(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(
              text,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600),
            ),
            // onPressed: () => handler(context),
            onPressed: () => _functionSelection(context),
          )
        : TextButton(
            child: Text(
              text,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600),
            ),
            // onPressed: () => handler(context),
            onPressed: () => _functionSelection(context),
          );
  }
}
