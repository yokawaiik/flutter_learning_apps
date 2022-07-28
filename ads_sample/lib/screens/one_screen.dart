import 'package:ads_sample/screens/two_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'dart:io' show Platform;

class OneScreen extends StatefulWidget {
  const OneScreen({Key? key}) : super(key: key);

  static const String id = "One";

  @override
  _OneScreenState createState() => _OneScreenState();
}

class _OneScreenState extends State<OneScreen> {
  late BannerAd _bannerAd;

  @override
  void initState() {
    late String platformAds;

    if (Platform.isAndroid) {
      platformAds = "ca-app-pub-3940256099942544/6300978111";
    } else if (Platform.isIOS) {
      platformAds = "ca-app-pub-2679738770396218/6034730273";
    }

    _bannerAd = BannerAd(
      adUnitId: platformAds,
      size: AdSize.mediumRectangle,
      request: AdRequest(),
      listener: BannerAdListener(),
    )..load();

    super.initState();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: AdWidget(
                ad: _bannerAd,
              ),
              width: _bannerAd.size.width.toDouble(),
              height: _bannerAd.size.height.toDouble(),
            ),
            SizedBox(
              height: 5,
            ),
            TextButton(
                onPressed: () {
                  // Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (context) => TwoScreen()));
                  Navigator.of(context).pushNamed(TwoScreen.id);
                },
                child: Text("Go to screen 2")),
          ],
        ),
      ),
    );
  }
}
