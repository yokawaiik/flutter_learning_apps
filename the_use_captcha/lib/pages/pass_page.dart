import 'package:flutter/material.dart';

class PassPage extends StatelessWidget {
  static const routeName = '/pass';
  const PassPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'You succeded in passing the captcha.',
              style: TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
