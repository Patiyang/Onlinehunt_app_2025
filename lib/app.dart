import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:online_hunt_news/blocs/epaper_bloc.dart';
import 'package:online_hunt_news/blocs/live_news_bloc.dart';
import 'package:online_hunt_news/blocs/allUserArticlesBloc.dart';
import 'package:online_hunt_news/blocs/magazine_bloc.dart';
import 'package:online_hunt_news/blocs/periodicals_bloc.dart';
import 'package:online_hunt_news/helpers&Widgets/loading.dart';
import 'package:online_hunt_news/pages/article_details.dart';
import 'package:online_hunt_news/pages/splash.dart';
import 'package:online_hunt_news/utils/next_screen.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'blocs/ads_bloc.dart';
import 'blocs/article_notification_bloc.dart';
import 'blocs/bookmark_bloc.dart';
import 'blocs/bottomNavBar_bloc.dart';
import 'blocs/categories_bloc.dart';

import 'blocs/comments_bloc.dart';
import 'blocs/custom_notification_bloc.dart';
import 'blocs/featured_bloc.dart';
import 'blocs/notification_bloc.dart';
import 'blocs/popular_articles_bloc.dart';
import 'blocs/recent_articles_bloc.dart';
import 'blocs/search_bloc.dart';
import 'blocs/sign_in_bloc.dart';
import 'blocs/tab_index_bloc.dart';
import 'blocs/theme_bloc.dart';
import 'blocs/videos_bloc.dart';

import 'config/config.dart';
import 'models/theme_model.dart';

final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;
final FirebaseAnalyticsObserver firebaseObserver = FirebaseAnalyticsObserver(analytics: firebaseAnalytics);

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeBloc>(
      create: (_) => ThemeBloc(),
      child: Consumer<ThemeBloc>(
        builder: (_, mode, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<SignInBloc>(create: (context) => SignInBloc()),
              ChangeNotifierProvider<CommentsBloc>(create: (context) => CommentsBloc()),
              ChangeNotifierProvider<BookmarkBloc>(create: (context) => BookmarkBloc()),
              ChangeNotifierProvider<SearchBloc>(create: (context) => SearchBloc()),
              ChangeNotifierProvider<FeaturedBloc>(create: (context) => FeaturedBloc()),
              ChangeNotifierProvider<PopularBloc>(create: (context) => PopularBloc()),
              ChangeNotifierProvider<RecentBloc>(create: (context) => RecentBloc()),
              ChangeNotifierProvider<AllUserArticlesBloc>(create: (context) => AllUserArticlesBloc()),
              ChangeNotifierProvider<CategoriesBloc>(create: (context) => CategoriesBloc()),
              ChangeNotifierProvider<LiveNewsBloc>(create: (context) => LiveNewsBloc()),
              ChangeNotifierProvider<EpaperBloc>(create: (context) => EpaperBloc()),
              ChangeNotifierProvider<MagazineBloc>(create: (context) => MagazineBloc()),
              ChangeNotifierProvider<AdsBloc>(create: (context) => AdsBloc()),
              ChangeNotifierProvider<WeeklyPeriodicalBloc>(create: (context) => WeeklyPeriodicalBloc()),
              ChangeNotifierProvider<FortnightlyPeriodicalBloc>(create: (context) => FortnightlyPeriodicalBloc()),
              ChangeNotifierProvider<MonthlyPeriodicalBloc>(create: (context) => MonthlyPeriodicalBloc()),

              // ChangeNotifierProvider<RelatedBloc>(create: (context) => RelatedBloc()),
              ChangeNotifierProvider<TabIndexBloc>(create: (context) => TabIndexBloc()),
              ChangeNotifierProvider<VideoTabIndexBloc>(create: (context) => VideoTabIndexBloc()),
              ChangeNotifierProvider<BottomNavBloc>(create: (context) => BottomNavBloc()),
              ChangeNotifierProvider<NotificationBloc>(create: (context) => NotificationBloc()),
              ChangeNotifierProvider<CustomNotificationBloc>(create: (context) => CustomNotificationBloc()),
              ChangeNotifierProvider<ArticleNotificationBloc>(create: (context) => ArticleNotificationBloc()),
              ChangeNotifierProvider<VideosBloc>(create: (context) => VideosBloc()),
            ],
            child: MaterialApp(
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              locale: context.locale,
              navigatorObservers: [firebaseObserver],
              theme: ThemeModel().lightMode,
              darkTheme: ThemeModel().darkMode,
              themeMode: mode.darkTheme == true ? ThemeMode.dark : ThemeMode.light,
              debugShowCheckedModeBanner: false,
              home: MyHome(),
            ),
          );
        },
      ),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> with WidgetsBindingObserver {
  // final DynamicLinkService _dynamicLinkService = DynamicLinkService();

  Timer? _timerLink;
  bool checked = false;
  final key = GlobalKey<ScaffoldState>();
  late AppLinks _appLinks = AppLinks();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _timerLink = new Timer(const Duration(milliseconds: 1), () async {
        // if(checked==false){
        //   await _dynamicLinkService.retrieveDynamicLink(context).whenComplete(() {
        //   checked = true;
        // });
        // }
        await Future.delayed(Duration(seconds: 3)).whenComplete(() => checked = true);
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    // screenCheck();
    // checkLink();
    getLanguage();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timerLink != null) {
      _timerLink!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      body: Center(
        child: Loading(spinkit: SpinKitSpinningLines(color: Theme.of(context).primaryColor)),
      ),
    );
  }

  screenCheck() {
    Future.delayed(Duration(seconds: 1)).whenComplete(() => nextScreen(context, SplashPage()));
  }

  getLanguage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString('language') == null) {
      getLanguageBottomSheet();
    } else {
      screenCheck();
      // checkLink();
    }
  }

  getLanguageBottomSheet() {
    showModalBottomSheet(
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(9), topRight: Radius.circular(9)),
      ),
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 5),

                Text(
                  'select language cont'.tr(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).primaryColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                Divider(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(10),
                  itemCount: Config().languages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _itemList(Config().languages[index], index, context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _itemList(d, index, BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.language),
          title: Text(d.toString().toLowerCase().tr()),
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            if (d == 'English') {
              context.setLocale(Locale('en'));
              prefs.setString('language', 'English');
              prefs.setInt('lang_id', 1);
              ThemeModel().myValue = 'Manrope';
            } else if (d == 'Kannada') {
              context.setLocale(Locale('kn'));
              prefs.setString('language', 'Kannada');
              prefs.setInt('lang_id', 2);
              ThemeModel().myValue = 'NotoSerif';
            } else if (d == 'Hindi') {
              context.setLocale(Locale('hi'));
              prefs.setString('language', 'Hindi');
              prefs.setInt('lang_id', 3);
              ThemeModel().myValue = 'Karma';
            }
            var value = await refresh(context);
            if (value == true) {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MyHome()), (route) => true);
            }
            // await getCategories();
          },
        ),
        Divider(height: 3, color: Colors.grey[400]),
      ],
    );
  }

  Future refresh(BuildContext context) async {
    await context.read<FeaturedBloc>().onRefresh(mounted);
    await context.read<PopularBloc>().onRefresh(mounted, context: context);
    await context.read<RecentBloc>().onRefresh(mounted);
    await context.read<CategoriesBloc>().onRefresh(mounted);
    // await context.read<>
    return true;
  }

  Future getCategories() async {
    // context.read<CategoryTab1Bloc>().onRefresh(mounted, Config().initialCategories[0]);
    // context.read<CategoryTab2Bloc>().onRefresh(mounted, Config().initialCategories[1]);
    // context.read<CategoryTab3Bloc>().onRefresh(mounted, Config().initialCategories[2]);
    // context.read<CategoryTab4Bloc>().onRefresh(mounted, Config().initialCategories[3]);
    // context.read<CategoryTab5Bloc>().onRefresh(mounted, Config().initialCategories[4]);
    // context.read<CategoryTab6Bloc>().onRefresh(mounted, Config().initialCategories[5]);
    // context.read<CategoryTab7Bloc>().onRefresh(mounted, Config().initialCategories[6]);
    // context.read<CategoryTab8Bloc>().onRefresh(mounted, Config().initialCategories[7]);
    // context.read<CategoryTab9Bloc>().onRefresh(mounted, Config().initialCategories[8]);
    // context.read<CategoryTab10Bloc>().onRefresh(mounted, Config().initialCategories[9]);
    // context.read<CategoryTab11Bloc>().onRefresh(mounted, Config().initialCategories[10]);
    // context.read<CategoryTab12Bloc>().onRefresh(mounted, Config().initialCategories[11]);
  }
  checkLink() async {
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
    const allowedHosts = {'onlinehunt.in', 'www.onlinehunt.in'};

    if (!allowedHosts.contains(uri.host)) {
      debugPrint('Ignoring deep link from ${uri.host}');
      return;
    }
    if (uri.pathSegments.isEmpty) {
      debugPrint('No slug found in deep link');
      return;
    }
    final slug = uri.pathSegments.first;
    Navigator.push(context, MaterialPageRoute(builder: (_) => ArticleDetails(post_id: null, slug: slug)));
  }
}
