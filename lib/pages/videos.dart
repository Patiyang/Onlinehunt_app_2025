import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:online_hunt_news/blocs/videoCategoryBlocs/videos_bloc.dart';

import 'package:online_hunt_news/helpers&Widgets/loading.dart';
import 'package:online_hunt_news/models/apiCategoriesModel.dart';
import 'package:online_hunt_news/models/categoriesModel.dart';
import 'package:online_hunt_news/models/theme_model.dart';
import 'package:online_hunt_news/services/category_services.dart';
import 'package:online_hunt_news/services/post_service.dart';
import 'package:online_hunt_news/widgets/video_tab_medium.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../helpers&Widgets/key.dart';

class VideoArticles extends StatefulWidget {
  VideoArticles({Key? key}) : super(key: key);

  @override
  _VideoArticlesState createState() => _VideoArticlesState();
}

class _VideoArticlesState extends State<VideoArticles> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  ScrollController? controller;
  TabController? _tabController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _orderBy = 'timestamp';
  List<Widget> tabBarViewItems = [];
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  PostServices postServices = PostServices();
  CategoryServices categoryServices = CategoryServices();
  bool loading = false;

  List<Tab> tabsList = [
    // Tab(text: "explore".tr()),
  ];
  List<ApiCategories>? incomingList = [];
  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    getData().whenComplete(() {
      _tabController = TabController(length: tabsList.length, vsync: this);
      _tabController!.addListener(() {
        print('tab ctrl ${_tabController!.index}');
        // context.read<TabIndexBloc>().setTabIndex(_tabController!.index);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    controller!.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    final db = context.read<VideosBloc>();

    if (!db.isLoading) {
      if (controller!.position.pixels == controller!.position.maxScrollExtent) {
        context.read<VideosBloc>().setLoading(true);
        // context.read<VideosBloc>().getData(mounted, _orderBy);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final innerScrollController = PrimaryScrollController.of(context);

    // getTabBarWidgets(vb);
    return loading
        ? Center(
            child: Loading(spinkit: SpinKitSpinningLines(color: Theme.of(context).primaryColor)),
          )
        : Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    centerTitle: false,
                    titleSpacing: 20,
                    title: Text('video articles').tr(),
                    pinned: true,
                    floating: true,
                    forceElevated: innerBoxIsScrolled,
                    bottom: TabBar(
                      labelStyle: TextStyle(fontFamily: ThemeModel().fontFamily, fontSize: 15, fontWeight: FontWeight.w600),
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Color(0xff5f6368), //niceish grey
                      isScrollable: true,
                      onTap: (int val) {
                        print(val);
                      },
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
              body: VideoTabMedium(
                presentCategories: incomingList!,
                sc: innerScrollController,
                tc: _tabController,
                orderBy: _orderBy,
              ),
            ),

            // StreamBuilder(
            //   stream: categoriesStream(),
            //   builder: (BuildContext context, AsyncSnapshot snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return Center(
            //           child: Loading(
            //         spinkit: SpinKitSpinningLines(color: Theme.of(context).primaryColor),
            //       ));
            //     }
            //     if (snapshot.connectionState == ConnectionState.none) {
            //       return Center(
            //           child: Column(
            //         children: [
            //           Icon(Icons.wifi, size: 25),
            //           SizedBox(height: 10),
            //           Text('No internet connection'),
            //         ],
            //       ));
            //     }
            //     if (snapshot.hasData) {
            //       List<Tab> tabsList = [
            //         // Tab(text: "explore".tr()),
            //       ];
            //       List<ApiCategories>? incomingList = snapshot.data;

            //       incomingList?.forEach((element) {
            //         tabsList.add(Tab(
            //           text: element.categoryName,
            //         ));
            //       });
            //       _tabController = TabController(length: tabsList.length, vsync: this);
            //       _tabController!.addListener(() {
            //         context.read<TabIndexBloc>().setTabIndex(_tabController!.index);
            //       });

            //     }
            //     return Container(
            //         // child: child,
            //         );
            //   },
            // ),
          );
  }

  @override
  bool get wantKeepAlive => true;
  categoriesStream() async {
    List response = [];
    List<ApiCategories> dummyList = [];
    int language = await returnCategoryId();
    List<ApiCategories> apiCategories = [];
    try {
      await categoryServices
          .getCategories()
          .then((value) {
            response = jsonDecode(utf8.decode(value.bodyBytes));
          })
          .whenComplete(() {
            response.forEach((element) {
              dummyList.add(ApiCategories.fromJson(element));
            });
          });
      dummyList.forEach((element) {
        if (element.languageId == language) {
          apiCategories.add(element);
        }
      });
    } catch (e) {
      print(e.toString());
    }

    return apiCategories;
  }

  Future getData() async {
    incomingList!.clear();
    // tabsList = tabsList.sublist(0, 1);
    setState(() {
      loading = true;
    });
    incomingList = await categoriesStream();

    incomingList?.forEach((element) {
      tabsList.add(Tab(text: element.categoryName));
    });
    setState(() {
      loading = false;
    });
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
}
