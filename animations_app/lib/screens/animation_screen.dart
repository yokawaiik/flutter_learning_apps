import 'dart:html';

import 'package:flutter/material.dart';

class AnimationScreen extends StatefulWidget {
  const AnimationScreen({Key? key}) : super(key: key);

  @override
  State<AnimationScreen> createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;
  final Tween<double> opacityTween = Tween<double>(begin: 0.0, end: 1.0);

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    )..addListener(() {
        // rebuild widget
        setState(() {});
      });

    animation = opacityTween.animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              color: Colors.yellow.withOpacity(animation.value),
            ),
            SizedBox(
              height: 10,
            ),
            TextButton(onPressed: () {
              if (_controller.isCompleted) {
                _controller.reverse();
              } else {
                // go animation
                _controller.forward();
              }
            }, child: Text("animate")),
          ],
        ),
      ),
    );
  }
}
