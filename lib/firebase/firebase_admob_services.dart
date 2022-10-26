import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class FirebaseAdmobServices {
  static String getAppId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6648505883255942~8801352238';
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String getBannerAdUnitId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6648505883255942/7927270177';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: getBannerAdUnitId(),
      size: AdSize.banner,
      listener: const BannerAdListener(),
      request: const AdRequest(),
    );
  }
}
