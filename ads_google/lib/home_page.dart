import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const String bannerAdUnitId = "ca-app-pub-3940256099942544/9214589741";
  BannerAd bannerAd = BannerAd(
    adUnitId: bannerAdUnitId,
    size: AdSize.banner,
    request: const AdRequest(),
    listener: BannerAdListener(
      onAdLoaded: (Ad ad) => print('BannerAd loaded.'),
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
        print('BannerAd failed to load: $error');
      },
    ),
  );

  @override
  void initState() {
    super.initState();
    bannerAd.load();
  }

  @override
  void dispose() {
    bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            Container(
              height: 50,
              child: AdWidget(ad: bannerAd),
            ),
            const Expanded(
              child: Center(
                child: Text('Your app content goes here.'),
              ),
            ),
          ],
        ));
  }
}
