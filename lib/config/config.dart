import 'package:flutter/material.dart';

class Config {
  final String appName = 'OnlineHunt - Tech Defined Online Media';
  final String splashIcon = 'assets/images/splash.png';
  final String supportEmail = 'connect@onlinehunt.net';
  final String privacyPolicyUrl = 'https://thetechdefined.com/onlinehunt';
  final String ourWebsiteUrl = 'https://thetechdefined.com/onlinehunt';
  final String iOSAppId = '000000';

  //social links
  static const String facebookPageUrl = 'https://www.facebook.com/theonlinehunt';
  static const String youtubeChannelUrl = 'https://www.youtube.com/channel/UCnNr2eppWVVo-NpRIy1ra7A';
  static const String twitterUrl = 'https://twitter.com/FlutterDev';

  //app theme color
  final Color appColor = Colors.blue;

  //Intro images
  final String introImage1 = 'assets/images/news1.png';
  final String introImage2 = 'assets/images/news6.png';
  final String introImage3 = 'assets/images/news7.png';
  final String noImage = 'assets/images/noImage.png';
  //animation files
  final String doneAsset = 'assets/animation_files/done.';

  //Language Setup
  final List<String> languages = [
    'English',
    // 'Spanish',
    // 'Arabic',
    'Kannada',
    'Hindi',
  ];

  //initial categories - 4 only (Hard Coded : which are added already on your admin panel)
  final List initialCategories = [
    'Local',
    'Politics',
    'Sports',
    'National',
    'Entertainment',
    'Astrology',
    'Health',
    'Economic',
    'Job',
    'Technology',
    'World',
    'Fitness',
  ];

//get the list of cities and districts
  static const String citiesAndDistricts = 'assets/cities/cityList2.json';
}
