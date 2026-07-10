import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:online_hunt_news/blocs/ads_bloc.dart';
import 'package:online_hunt_news/blocs/featured_bloc.dart';
import 'package:online_hunt_news/blocs/popular_articles_bloc.dart';
import 'package:online_hunt_news/blocs/recent_articles_bloc.dart';
import 'package:online_hunt_news/utils/loading_cards.dart';
import 'package:online_hunt_news/widgets/slider.dart';
import 'package:online_hunt_news/widgets/popular_articles.dart';
import 'package:online_hunt_news/widgets/recent_articles.dart';
import 'package:online_hunt_news/widgets/search_bar.dart' as sbwidget;
import 'package:provider/provider.dart';

class Tab0 extends StatefulWidget {
  Tab0({Key? key}) : super(key: key);

  @override
  _Tab0State createState() => _Tab0State();
}

class _Tab0State extends State<Tab0> with AutomaticKeepAliveClientMixin, ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    // refresh();
    loadAdTimer();
    super.initState();
  }

  _scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent && !scrollController.position.outOfRange) {
      print('reached bottom');
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adb = context.watch<AdsBloc>();

    super.build(context);
    return RefreshIndicator(
      onRefresh: () => refresh(context),
      child: SingleChildScrollView(
        controller: scrollController,
        key: PageStorageKey('key0'),
        padding: EdgeInsets.all(0),
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // sbwidget.SearchBar(),
            SliderWidget(),
            Visibility(visible: adb.isBannerAdReady == true,
              child: Container(
                width: adb.bannerAd != null ? adb.bannerAd!.size.width.toDouble() : MediaQuery.of(context).size.width,
                height: adb.bannerAd != null ? adb.bannerAd!.size.height.toDouble() : (kBottomNavigationBarHeight + 5.0),
                margin: EdgeInsets.only(top: 5),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: adb.isBannerAdReady == true
                    ? Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: <BoxShadow>[BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 10, offset: Offset(0, 3))],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: AdWidget(ad: adb.bannerAd!),
                        ),
                      )
                    : LoadingCard(height: (kBottomNavigationBarHeight + 5.0)),
              ),
            ),

            PopularWidget(),
            RecentArticles(),
          ],
        ),
      ),
    );
  }

  refresh(BuildContext context) async {
    final adb = context.read<AdsBloc>();

    context.read<FeaturedBloc>().onRefresh(mounted);
    context.read<PopularBloc>().onRefresh(mounted, context: context);
    context.read<RecentBloc>().onRefresh(mounted);
    if (adb.isBannerAdReady == false) {
      adb.loadBannerAd(width: MediaQuery.of(context).size.width);
    }
  }

  initializeAds(BuildContext context) async {
    final adb = context.read<AdsBloc>();
    await adb.checkAdsEnable().then((value) async {
      if (adb.isBannerAdReady == false) {
        adb.loadBannerAd(width: MediaQuery.of(context).size.width);
      }
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  void loadAdTimer() {}
}
