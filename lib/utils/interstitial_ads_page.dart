import 'package:flutter/material.dart';
import 'package:online_hunt_news/blocs/ads_bloc.dart';
import 'package:online_hunt_news/helpers&Widgets/loading.dart';
import 'package:provider/provider.dart';

class InterstitialAdsPage extends StatefulWidget {
  const InterstitialAdsPage({super.key});

  @override
  State<InterstitialAdsPage> createState() => _InterstitialAdsPageState();
}

class _InterstitialAdsPageState extends State<InterstitialAdsPage> {
  @override
  void initState() {
    super.initState();
    initializeAd();
  }

  @override
  Widget build(BuildContext context) {
    return Material(child: Container(child: Loading()));
  }

  void initializeAd() {
    final adb = context.read<AdsBloc>();
    // AdsBloc().showInterstitialAdAdmob(context: context);
    adb.showInterstitialAdAdmob(context: context);
  }
}
