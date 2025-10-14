import 'dart:convert';

// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_hunt_news/blocs/ads_bloc.dart';
import 'package:online_hunt_news/blocs/bottomNavBar_bloc.dart';
import 'package:online_hunt_news/blocs/notification_bloc.dart';
import 'package:online_hunt_news/blocs/sign_in_bloc.dart';
import 'package:online_hunt_news/config/config.dart';
import 'package:online_hunt_news/pages/article_details.dart';
import 'package:online_hunt_news/pages/categories.dart';
import 'package:online_hunt_news/pages/explore.dart';
import 'package:online_hunt_news/pages/profile.dart';
import 'package:online_hunt_news/services/app_service.dart';
import 'package:online_hunt_news/utils/snacbar.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  PageController _pageController = PageController(keepPage: true);

  List<IconData> iconList = [
    Feather.home,
    FontAwesome.newspaper_o,
    Feather.tv,
    Feather.user,
    // Feather.plus_circle
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
  late AppLinks _appLinks = AppLinks();

  checkLink() async {
    // final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink(); //GETTING THE INITIAL LINK IF THE APP WAS CLOSED
    // final Uri? deepLink = data?.link;
    // // Fluttertoast.showToast(msg: data!.link.path);
    // if (deepLink != null && loaded == false) {
    //   try {
    //     print('try deeplink success');
    //     String? id = deepLink.queryParameters['id'];
    //     String? category = deepLink.queryParameters['categoryId'];
    //     String? type = deepLink.queryParameters['type'] ?? 'article';

    //     if (type == 'iptv') {
    //       Fluttertoast.showToast(msg: 'msg');
    //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => IptvVideo(id: id)));
    //     } else {
    //       if (deepLink.queryParameters.containsKey('id')) {
    //         Navigator.of(context).push(
    //           MaterialPageRoute(
    //             builder: (context) => ArticleDetails(articleId: id, data: null, tag: '', categoryId: category!),
    //           ),
    //         );
    //         loaded = true;
    //       }
    //     }
    //   } catch (e) {
    //     print('deep link has error ${e.toString()}');
    //   }
    // }
    _appLinks = AppLinks();
    _handleInitialUri();
    _appLinks.uriLinkStream.listen(
      (Uri? uri) {
        if (uri != null) {
          _onDeepLink(uri);
        }
      },
      onError: (err) {
        print('failed to get latest link: $err');
      },
    );
  }

  Future<void> _handleInitialUri() async {
    final uri = await _appLinks.getInitialLink();
    if (uri != null) {
      _onDeepLink(uri);
    }
  }

  void _onDeepLink(Uri uri) {
  // Example: onlinehuntnews://post/12345
  if (uri.scheme == 'onlinehunt' && uri.host == 'post' && uri.pathSegments.isNotEmpty) {
    final postId = uri.pathSegments[0];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ArticleDetails(post_id: int.parse(postId)),
      ),
    );
  }
}


  @override
  void initState() {
    super.initState();
    checkLink();
    Future.delayed(Duration(milliseconds: 0)).then((value) async {
      final adb = context.read<AdsBloc>();
      await context
          .read<NotificationBloc>()
          .initFirebasePushNotification(context)
          .then((value) => context.read<NotificationBloc>().handleNotificationlength())
          .then((value) => adb.checkAdsEnable())
          .then((value) async {
            if (adb.interstitialAdEnabled == true || adb.bannerAdEnabled == true) {
              adb.initiateAds();
            }
          });
    });
    getStates();
  }

  @override
  void dispose() {
    _pageController.dispose();
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
          children: <Widget>[
            Explore(),
            // VideoArticles(),
            Categories(),
            // IptvList(),
            ProfilePage(),
          ],
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
        // BottomNavigationBarItem(icon: Icon(iconList[2]), label: 'iptv'.tr()),
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
}
