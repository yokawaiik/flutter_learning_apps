import 'package:ads_sample/screens/two_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'dart:io' show Platform;

class TwoScreen extends StatefulWidget {
  const TwoScreen({Key? key}) : super(key: key);

  static const String id = "Two";

  @override
  _TwoScreenState createState() => _TwoScreenState();
}

class _TwoScreenState extends State<TwoScreen> {
  late InterstitialAd _interstitialAd;

  @override
  void initState() {
    late String platformAds;

    if (Platform.isAndroid) {
      platformAds = "ca-app-pub-3940256099942544/1033173712";
    } 

    InterstitialAd.load(
      adUnitId: platformAds,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;

          _interstitialAd.show();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        }
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _interstitialAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
