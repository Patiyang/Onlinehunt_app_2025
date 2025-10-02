import 'dart:io';

class AdConfig {


  
  //-- Admob Ads --
// ca-app-pub-2756561602157194~4092585845
  static const String admobAppIdAndroid = 'ca-app-pub-3940256099942544~3347511713';
  static const String admobAppIdiOS = 'ca-app-pub-3940256099942544~1458002511';

// ca-app-pub-2756561602157194/2501669553
  static const String admobInterstitialAdUnitIdAndroid = 'ca-app-pub-3940256099942544/1033173712';
  static const String admobInterstitialAdUnitIdiOS = 'ca-app-pub-3940256099942544/4411468910';
// ca-app-pub-2756561602157194/6395832471
// ca-app-pub-3940256099942544/6300978111 initial
  static const String admobBannerAdUnitIdAndroid = 'ca-app-pub-2756561602157194/6395832471';
  static const String admobBannerAdUnitIdiOS = 'ca-app-pub-3940256099942544/2934735716';

  //-- Fb Ads --
  static const String fbInterstitialAdUnitIdAndroid = '544514846502****************';
  static const String fbInterstitialAdUnitIdiOS = '544514846502023_702****************';

  static const String fbBannerAdUnitIdAndroid = '544514846502023_70****************';
  static const String fbBannerAdUnitIdiOS = '544514846502023_7****************';








  // -- Don't edit these --
  
  String getAdmobAppId () {
    if(Platform.isAndroid){
      return admobAppIdAndroid;
    } 
    else{
      return admobAppIdiOS;
    }
  }

  String getAdmobBannerAdUnitId (){
    if(Platform.isAndroid){
      return admobBannerAdUnitIdAndroid;
    }
    else{
      return admobBannerAdUnitIdiOS;
    }
  }

  String getAdmobInterstitialAdUnitId (){
    if(Platform.isAndroid){
      return admobInterstitialAdUnitIdAndroid;
    }
    else{
      return admobInterstitialAdUnitIdiOS;
    }
  }


  String getFbBannerAdUnitId (){
    if(Platform.isAndroid){
      return fbBannerAdUnitIdAndroid;
    }
    else{
      return fbBannerAdUnitIdiOS;
    }
  }

  String getFbInterstitialAdUnitId (){
    if(Platform.isAndroid){
      return fbInterstitialAdUnitIdAndroid;
    }
    else{
      return fbInterstitialAdUnitIdiOS;
    }
  }

  
}