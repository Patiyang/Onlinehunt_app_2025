import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_user_agent/flutter_user_agent.dart';
import 'package:line_icons/line_icons.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:online_hunt_news/blocs/categoryBlocs/categories_bloc.dart';
import 'package:online_hunt_news/blocs/featured_bloc.dart';
import 'package:online_hunt_news/blocs/notification_bloc.dart';
import 'package:online_hunt_news/blocs/popular_articles_bloc.dart';
import 'package:online_hunt_news/blocs/recent_articles_bloc.dart';
import 'package:online_hunt_news/blocs/tab_index_bloc.dart';
import 'package:online_hunt_news/config/config.dart';
import 'package:online_hunt_news/helpers&Widgets/loading.dart';
import 'package:online_hunt_news/models/categoriesModel.dart';
import 'package:online_hunt_news/models/categoryModel.dart';
import 'package:online_hunt_news/models/theme_model.dart';
import 'package:online_hunt_news/pages/home.dart';
import 'package:online_hunt_news/pages/intro.dart';
import 'package:online_hunt_news/pages/notifications.dart';
import 'package:online_hunt_news/pages/search.dart';
import 'package:online_hunt_news/services/category_services.dart';
import 'package:online_hunt_news/services/post_service.dart';
import 'package:online_hunt_news/utils/app_name.dart';
import 'package:online_hunt_news/utils/next_screen.dart';
import 'package:online_hunt_news/widgets/drawer.dart';
import 'package:online_hunt_news/tabs/tab_medium_alt.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Explore extends StatefulWidget {
  Explore({Key? key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  TabController? _tabController;
  List<String> states = [];
  List<dynamic> districts = [];
  String selectedState = '';
  List<String> selectedDistricts = [];
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  String appLanguage = '';
  PostServices postServices = PostServices();
  CategoryServices categoryServices = CategoryServices();
  bool loading = false;

  List<Tab> tabsList = [Tab(text: "explore".tr())];
  List<Category>? incomingList = [];
  List controllers = [];

  @override
  void initState() {
    // Fluttertoast.showToast(msg: 'msg');
    super.initState();
    getData().whenComplete(() {
      _tabController = TabController(length: tabsList.length, vsync: this);
      _tabController!.addListener(() {
        // print('tab ctrl ${_tabController!.index}');
        context.read<TabIndexBloc>().setTabIndex(_tabController!.index);
      });
    });

    Future.delayed(Duration(milliseconds: 0)).then((value) {
      context.read<FeaturedBloc>().getApiData(mounted);
      context.read<PopularBloc>().getApiData(mounted, context);
      context.read<RecentBloc>().getApiData(mounted);
    });
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final innerScrollController = ScrollController();
    controllers.add(innerScrollController);
    for (int i = 0; i <= tabsList.length; i++) {
      controllers.add(innerScrollController);
    }
    return loading
        ? Center(
            child: Loading(spinkit: SpinKitSpinningLines(color: Theme.of(context).primaryColor)),
          )
        : SafeArea(bottom: false,
          child: Scaffold(
              drawer: DrawerMenu(),
              key: scaffoldKey,
              body: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    new SliverAppBar(
                      automaticallyImplyLeading: false,
                      centerTitle: false,
                      titleSpacing: 5,
                      title: AppName(fontSize: 19.0),
                      leading: IconButton(
                        icon: Icon(Feather.menu, size: 25),
                        onPressed: () {
                          scaffoldKey.currentState!.openDrawer();
                        },
                      ),
                      elevation: 1,
                      actions: <Widget>[
                        incomingList!.isEmpty
                            ? IconButton(onPressed: () => nextScreenReplace(context, HomePage()), icon: Icon(Icons.refresh))
                            : SizedBox.shrink(),
                        IconButton(
                          icon: Icon(Icons.translate, size: 22),
                          onPressed: () async {
                            nextScreen(context, IntroPage());
                            // await AdServices().getMobileAds('1', adspace: 'main_screen_ad');
                            // var value = await getLanguageBottomSheet() ?? false;
                            // if (value == true) {
                            //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
                            // }
                          },
                        ),
                        IconButton(
                          icon: Icon(AntDesign.search1, size: 22),
                          onPressed: () {
                            nextScreen(context, SearchPage());
                          },
                        ),
                        badges.Badge(
                          position: badges.BadgePosition.topEnd(top: 14, end: 15),
                          badgeStyle: badges.BadgeStyle(badgeColor: Colors.redAccent, elevation: 0, padding: EdgeInsets.all(5)),
                          badgeAnimation: badges.BadgeAnimation.fade(
                            animationDuration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            loopAnimation: false,
                          ),
                          showBadge: context.watch<NotificationBloc>().savedNlength < context.watch<NotificationBloc>().notificationLength ? true : false,
                          badgeContent: Container(),
                          child: IconButton(
                            icon: Icon(LineIcons.bell, size: 25),
                            onPressed: () {
                              context.read<NotificationBloc>().saveNlengthToSP();
                              nextScreen(context, NotificationsPage());
                            },
                          ),
                        ),
          
                        SizedBox(width: 5),
                      ],
                      pinned: true,
                      floating: false,
                      forceElevated: innerBoxIsScrolled,
                      bottom: TabBar(
                        labelStyle: TextStyle(fontFamily: ThemeModel().fontFamily, fontSize: 15, fontWeight: FontWeight.w600),
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelColor: Theme.of(context).primaryColor,
                        unselectedLabelColor: Color(0xff5f6368), //niceish grey
                        isScrollable: true,
                        indicator: MD2Indicator(
                          //it begins here
                          indicatorHeight: 3,
                          indicatorColor: Theme.of(context).primaryColor,
                          indicatorSize: MD2IndicatorSize.normal,
                        ),
                        tabs: tabsList,
                      ),
                    ),
                  ];
                },
                body: Builder(
                  builder: (cpntext) {
                    return TabMediumAlt(
                      controllers: controllers,
                      sc: innerScrollController,
                      tc: _tabController,
                      presentCategories: incomingList,
                      selectedIndex: _tabController!.index,
                    );
                  },
                ),
              ),
            ),
        );
  }

  @override
  bool get wantKeepAlive => true;

  getLanguageBottomSheet() {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(9), topRight: Radius.circular(9)),
      ),
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 10, bottom: 30, left: 10, right: 10),
              itemCount: Config().languages.length,
              itemBuilder: (BuildContext context, int index) {
                return _itemList(Config().languages[index], index, context);
              },
            );
          },
        );
      },
    );
  }

  Widget _itemList(d, inddex, BuildContext context) {
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
              prefs.setInt('lang_id', 2);
              ThemeModel().myValue = 'Manrope';
              await refresh(context).whenComplete(() {
                Navigator.pop(context, true);
              });
            }
            if (d == 'Kannada') {
              context.setLocale(Locale('kn'));
              prefs.setString('language', 'Kannada');
              prefs.setInt('lang_id', 1);
              ThemeModel().myValue = 'NotoSerif';
              await refresh(context).whenComplete(() {
                // getData();
                Navigator.pop(context, true);
              });
            }
            if (d == 'Hindi') {
              context.setLocale(Locale('hi'));
              prefs.setString('language', 'Hindi');
              prefs.setInt('lang_id', 3);
              ThemeModel().myValue = 'Karma';
              await refresh(context).whenComplete(() {
                Navigator.pop(context, true);
              });
            }
          },
        ),
        Divider(height: 3, color: Colors.grey[400]),
      ],
    );
  }

  getLanguage(CategoriesModel categoriesModel) {
    if (context.locale == Locale('en')) {
      return categoriesModel.categoyName;
    } else if (context.locale == Locale('kn')) {
      return categoriesModel.karnatakaCategoryName;
    } else if (context.locale == Locale('hi')) {
      return categoriesModel.hindiCategoryName;
    }
  }

  Future refresh(BuildContext context) async {
    context.read<FeaturedBloc>().onRefresh(mounted);
    context.read<PopularBloc>().onRefresh(mounted, context: context);
    context.read<RecentBloc>().onRefresh(mounted);
    context.read<CategoriesBloc>().onRefresh(mounted);
  }

  Future getData() async {
    incomingList!.clear();
    tabsList = tabsList.sublist(0, 1);
    setState(() {
      loading = true;
    });
    incomingList = await categoriesStream();

    incomingList?.forEach((element) {
      // if(element.parentId=='0'){

      // }
      tabsList.add(Tab(text: element.name));
    });
    setState(() {
      loading = false;
    });
  }

  categoriesStream() async {
    Map<String, dynamic> response = {};
    List<Category> apiCategories = [];
    try {
      await categoryServices
          .getCategories()
          .then((value) {
            response = jsonDecode(utf8.decode(value.bodyBytes));
          })
          .whenComplete(() {
            for (int i = 0; i < response['data'].length; i++) {
              apiCategories.add(Category.fromJson(response['data'][i]));
            }
          });
      // dummyList.forEach((element) {
      //   if (element.languageId == language ) {
      //     apiCategories.add(element);
      //   }
      // });
    } catch (e) {
      print(e.toString());
    }

    return apiCategories;
  }
}
