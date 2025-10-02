import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:online_hunt_news/config/ad_config.dart';
import 'package:html/parser.dart' show parse;
import 'package:online_hunt_news/helpers&Widgets/loading.dart';
import 'package:online_hunt_news/models/mobile_ads_model.dart';
import 'package:online_hunt_news/models/theme_model.dart';
import 'package:online_hunt_news/services/ad_services.dart';
import '../services/app_service.dart';

class AdmobHelper {
  static String get bannerUnit => AdConfig().getAdmobBannerAdUnitId();
  static Completer<BannerAd> bannerCompleter = Completer<BannerAd>();

  static initialize() {
    // ignore: unnecessary_null_comparison
    if (MobileAds.instance == null) {
      MobileAds.instance.initialize();
    }
  }

  static BannerAd getBannerAd() {
    BannerAd bAd = new BannerAd(
      size: AdSize.fullBanner,
      adUnitId: bannerUnit,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
          bannerCompleter.complete(ad as BannerAd);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('$BannerAd failedToLoad: $error');
          bannerCompleter.completeError(error);
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
        onAdImpression: (Ad ad) => print('Ad impression.'),
      ),
      request: AdRequest(),
    );
    return bAd;
  }
}

class CustomMobileAd {
  static Widget getBannerAd(BuildContext context, MobileAdsaModel singleAd) {
    var document = parse(singleAd.adCode);
    String adLinkstr = singleAd.adCode!;
    String adLinkstart = "<a href=\"";
    String adLinkend = "\"";
    final adLinkstartIndex = adLinkstr.indexOf(adLinkstart);
    final adLinkendIndex = adLinkstr.indexOf(adLinkend, adLinkstartIndex + adLinkstart.length);
    String adLink = adLinkstr.substring(adLinkstartIndex + adLinkstart.length, adLinkendIndex);

    String adImagestr = singleAd.adCode!;
    String adImagestart = "src=\"";
    String adImageend = "\" alt=";
    final adImagestartIndex = adImagestr.indexOf(adImagestart);
    final adImageendIndex = adLinkstr.indexOf(adImageend, adImagestartIndex + adImagestart.length);
    String adImage = adLinkstr.substring(adImagestartIndex + adImagestart.length, adImageendIndex);

    Widget bAd = Wrap(
      children: [
        Container(
          height: 210,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            // image: DecorationImage(
            //   image: CachedNetworkImageProvider(adImage),
            //   fit: BoxFit.cover,
            // ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                Loading(size: 20),
                InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () => AppService().openLinkWithCustomTab(context, adLink),
                  child: Image.network(adImage, height: 210, width: MediaQuery.of(context).size.width, fit: BoxFit.cover),
                ),
                // CachedNetworkImage(
                //   imageUrl: adImage,
                //   // height: 150,
                //   // width: 50,
                //   height: 210,
                //   width: MediaQuery.of(context).size.width,
                //   fit: BoxFit.cover,
                //   placeholder: (_, url) => CustomPlaceHolder(size: 56),
                //   errorWidget: (context, url, error) => const Icon(Icons.error),
                // ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(.95),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.0),
                      child: Text(singleAd.adMessage!, style: TextStyle(fontSize: 13, fontFamily: ThemeModel().fontFamily)),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(.75),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'proceed'.tr(),
                            style: TextStyle(fontSize: 13, fontFamily: 'Manrope', fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await AdServices().updateViews('${(int.parse(singleAd.adViews!) + 1)}', singleAd.id!).then((value) {
                                Map mapres = jsonDecode(value.body);
                                if (mapres['status'] == true) {
                                  AppService().openLinkWithCustomTab(context, adLink);
                                } else {
                                  print(mapres);
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              decoration: BoxDecoration(color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                'visit'.tr(),
                                style: TextStyle(fontSize: 13, fontFamily: 'Manrope', fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
    return bAd;
  }
}
