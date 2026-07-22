import 'dart:async';
import 'dart:convert';

// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_hunt_news/blocs/ads_bloc.dart';
import 'package:online_hunt_news/blocs/bottomNavBar_bloc.dart';
import 'package:online_hunt_news/blocs/notification_bloc.dart';
import 'package:online_hunt_news/blocs/sign_in_bloc.dart';
import 'package:online_hunt_news/config/config.dart';
import 'package:online_hunt_news/pages/article_details.dart';
import 'package:online_hunt_news/pages/categories.dart';
import 'package:online_hunt_news/pages/epapers/periodical_widgets/daily_epaper.dart';
import 'package:online_hunt_news/pages/epapers/epaper_tabbarview.dart';
import 'package:online_hunt_news/pages/explore.dart';
import 'package:online_hunt_news/pages/iptv/videos_explore.dart';
import 'package:online_hunt_news/pages/profile.dart';
import 'package:online_hunt_news/services/app_service.dart';
import 'package:online_hunt_news/services/dynamic_link_services.dart';
import 'package:online_hunt_news/utils/snacbar.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class HomePage extends StatefulWidget {
  final Uri? initialDeepLink;
  HomePage({Key? key, this.initialDeepLink}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  PageController _pageController = PageController(keepPage: true);
  List<IconData> iconList = [
    Icons.home,
    Icons.category,
    Icons.tv,
    Icons.person,
    Icons.newspaper,
    // Icons.plus_circle
  ];
  List<String> states = [];
  List districts = [];
  List<String> selectedDistricts = [];
  String selectedState = '';
  String selectedDistrict = '';
  bool manualLocation = true;
  bool loading = false;
  bool loaded = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription<Uri>? _linkSubscription;
  // checkLink() async {
  //   _appLinks = AppLinks();
  //   _handleInitialUri();
  //   _linkSubscription = _appLinks.uriLinkStream.listen(
  //     (Uri? uri) {
  //       if (uri != null) {
  //         if (_lastHandledUri == uri) return;
  //         _onDeepLink(uri);
  //       }
  //     },
  //     onError: (err) {
  //       print('failed to get latest link: $err');
  //     },
  //   );
  // }

  // Future<void> _handleInitialUri() async {
  //   final uri = await _appLinks.getInitialLink();
  //   if (uri != null) {
  //     _onDeepLink(uri);
  //   }
  // }

  // void _onDeepLink(Uri uri) {
  //   const allowedHosts = {'onlinehunt.in', 'www.onlinehunt.in'};

  //   if (!allowedHosts.contains(uri.host)) {
  //     debugPrint('Ignoring deep link from ${uri.host}');
  //     return;
  //   }
  //   if (uri.pathSegments.isEmpty) {
  //     debugPrint('No slug found in deep link');
  //     return;
  //   }

  //   _lastHandledUri = uri;
  //   final slug = uri.pathSegments.first;
  //   Navigator.push(context, MaterialPageRoute(builder: (_) => ArticleDetails(post_id: null, slug: slug)));
  //   // _appLinks.uriLinkStream.first.ignore();
  // }

  bool _openingArticle = false;

  @override
  void initState() {
    super.initState();
    initializeNotification();
    checkDeepLink();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future _onWillPop() async {
    if (_currentIndex != 0) {
      setState(() => _currentIndex = 0);
      _pageController.animateToPage(0, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    } else {
      await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    print('the sign in block state is ${sb.state}');

    return WillPopScope(
      onWillPop: () async => await _onWillPop(),
      child: Scaffold(
        bottomNavigationBar: ChangeNotifierProvider(create: (context) => BottomNavBloc(), child: _bottomNavigationBar()),
        body: PageView(
          controller: _pageController,
          allowImplicitScrolling: false,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[Explore(), Categories(), EpaperTabbarView(), VideoExplore(), ProfilePage()],
        ),
        floatingActionButton: sb.uid != null && sb.guestUser == false
            ? SizedBox.shrink() /* Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade300,
                  gradient: LinearGradient(colors: [Config().appColor, Colors.grey.shade600], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                ),
                child: IconButton(onPressed: () => nextScreen(context, AddArticle()), icon: Icon(Icons.edit), color: Colors.white),
              ) */
            : SizedBox.shrink(),
      ),
    );
  }

  BottomNavigationBar _bottomNavigationBar() {
    print(context.locale.toString());

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (index) => onTabTapped(index),
      currentIndex: context.read<BottomNavBloc>().currentIndex,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      iconSize: 25,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(iconList[0]), label: 'home'.tr()),
        BottomNavigationBarItem(icon: Icon(iconList[1], size: 25), label: 'categories'.tr()),
        BottomNavigationBarItem(icon: Icon(iconList[4], size: 25), label: 'epaper'.tr()),
        BottomNavigationBarItem(icon: Icon(iconList[2]), label: 'iptv'.tr()),
        BottomNavigationBarItem(icon: Icon(iconList[3]), label: 'profile'.tr()),
      ],
    );
  }

  void onTabTapped(int index) {
    setState(() {
      context.read<BottomNavBloc>().currentIndex = index;
    });
    if (_pageController.hasClients) {
      // if(index==1){
      //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomePage()));
      // }
      _pageController.animateToPage(index, curve: Curves.easeIn, duration: Duration(milliseconds: 250));
      // _pageController.jumpToPage(index);
    }
  }

  getStates() async {
    String data = await DefaultAssetBundle.of(context).loadString(Config.citiesAndDistricts);
    final jsonResult = jsonDecode(data);
    for (int i = 0; i < jsonResult['states'].length; i++) {
      states.add(jsonResult['states'][i]['state']);
    }
    print(states);
    setState(() {});
  }

  getDistricts() async {
    districts = [];
    String data = await DefaultAssetBundle.of(context).loadString(Config.citiesAndDistricts);
    final jsonResult = jsonDecode(data);
    setState(() {
      districts = jsonResult['states'][states.indexOf(selectedState)]['districts'];
    });
    print(districts);
  }

  updateLocationData() async {
    final sb = context.read<SignInBloc>();
    await AppService().checkInternet().then((hasInternet) async {
      if (hasInternet == false) {
        openSnacbar(scaffoldKey, 'no internet'.tr());
      } else {
        await sb.updateUserLocationData(selectedState, selectedDistricts).then((value) {
          // openSnacbar(scaffoldKey, 'updated successfully'.tr());
          Fluttertoast.showToast(msg: 'updated successfully');
          setState(() => loading = false);
        });
      }
    });
  }

  void initializeNotification() {
    Future.delayed(Duration(milliseconds: 0)).then((value) async {
      final adb = context.read<AdsBloc>();
      await context
          .read<NotificationBloc>()
          .initFirebasePushNotification(context)
          .then((value) => context.read<NotificationBloc>().handleNotificationlength())
          .then((value) => adb.checkAdsEnable())
          .then((value) async {
            if (adb.interstitialAdEnabled == true || adb.bannerAdEnabled == true) {
              adb.initiateAds().whenComplete(() {
                adb.loadAds(width: MediaQuery.of(context).size.width);
                // adb.showInterstitialAdAdmob();
              });
            }
          });
    });
  }

  void checkDeepLink() {
    // checkLink();
    // _linkSubscription = DynamicLinkService.instance!.subscription;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uri = widget.initialDeepLink;

      if (uri != null) {
        _handleDeepLink(uri);
        DynamicLinkService.instance.clearPendingUri();
      }
    });

    _linkSubscription ??= DynamicLinkService.instance.linkStream.listen(_handleDeepLink);
  }

  Future<void> _handleDeepLink(Uri uri) async {
    debugPrint("HANDLE LINK: $uri");
    if (_openingArticle) return;

    // if (uri.host != 'onlinehunt.in' && uri.host != 'www.onlinehunt.in') {
    //   return;
    // }

    // if (uri.pathSegments.length != 1) return;
    const allowedHosts = {'onlinehunt.in', 'www.onlinehunt.in'};

    if (!allowedHosts.contains(uri.host)) {
      return;
    }

    if (uri.pathSegments.isEmpty) {
      return;
    }
    _openingArticle = true;
    String slug = uri.pathSegments.first;
    if (uri.pathSegments.length >= 2 && RegExp(r'^[a-z]{2}$').hasMatch(uri.pathSegments.first)) {
      slug = uri.pathSegments[1];
    } else {
      slug = uri.pathSegments.first;
    }
    print('SLUG is $slug');
    await Navigator.push(context, MaterialPageRoute(builder: (_) => ArticleDetails(post_id: null, slug: slug)));

    _openingArticle = false;
  }
}
