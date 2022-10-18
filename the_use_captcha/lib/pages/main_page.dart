import 'dart:math';
import 'package:flutter/material.dart';
import 'package:slider_captcha/slider_capchar.dart';
import 'package:the_use_captcha/pages/pass_page.dart';

class MainPage extends StatefulWidget {
  static const String routeName = "/";

  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final SliderController controller = SliderController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: const [
                Text(
                  "This app is demonstrating CAPTCHA.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Try it and we check if you aren't robot.",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                // Call captcha dialog
                onPressed: () => _showCaptcha(context),
                child: const Text(
                  'Pass the captcha',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _showCaptcha(BuildContext context) async {
    var attempts = 3;
    bool captchaResult = false;
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (
        BuildContext buildContext,
        Animation animation,
        Animation secondaryAnimation,
      ) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SliderCaptcha(
                controller: controller,
                image: Image.asset(
                  'assets/image-${generateNumber(0, 1)}.jpg',
                  fit: BoxFit.fitWidth,
                ),
                title: 'Slide to pass',
                titleStyle: Theme.of(context).textTheme.bodyMedium,
                colorBar: Theme.of(context).colorScheme.onSecondary,
                colorCaptChar: Theme.of(context).colorScheme.primary,
                onConfirm: (onConfirm) async {
                  return Future.delayed(const Duration(seconds: 1)).then(
                    (_) {
                      controller.create();

                      if (onConfirm == false) {
                        attempts -= 1;
                        if (attempts == 0) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Text(
                            "You've already tried 3 times. Have a rest.'",
                          )));
                        }
                      } else {
                        Navigator.of(context).pop();
                      }
                      captchaResult = onConfirm;
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
    if (captchaResult) {
      Navigator.of(context).pushNamed(PassPage.routeName);
    }
  }

  // Generate number for assets
  int generateNumber(min, max) {
    final random = Random();
    final number = min + random.nextInt((max + 1) - min);
    return number;
  }
}
