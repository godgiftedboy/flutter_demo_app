import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyAdPage extends StatefulWidget {
  const MyAdPage({super.key, required this.title});

  final String title;

  @override
  State<MyAdPage> createState() => _MyAdPageState();
}

class _MyAdPageState extends State<MyAdPage> {
  static const bannerAdUnitId = "ca-app-pub-3940256099942544/9214589741";
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
  List<BannerAd> bannerAds = [];

  @override
  void initState() {
    super.initState();
    // for (int i = 0; i < 3; i++) {
    //   // Adjust the number of ads as needed
    //   BannerAd bannerAd = BannerAd(
    //     adUnitId: bannerAdUnitId,
    //     size: AdSize.banner,
    //     request: const AdRequest(),
    //     listener: BannerAdListener(
    //       onAdLoaded: (Ad ad) => print('BannerAd $i loaded.'),
    //       onAdFailedToLoad: (Ad ad, LoadAdError error) {
    //         ad.dispose();
    //         print('BannerAd $i failed to load: $error');
    //       },
    //     ),
    //   );
    //   bannerAds.add(bannerAd);
    bannerAd.load();
  }

  @override
  void dispose() {
    // for (var bannerAd in bannerAds) {
    bannerAd.dispose();
    // }
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
            // ...bannerAds.map((e) {
            SizedBox(
              height: 50,
              child: AdWidget(ad: bannerAd),
            ),
            // }),
          ],
        ));
  }
}
