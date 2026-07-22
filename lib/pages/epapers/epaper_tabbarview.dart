import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:online_hunt_news/blocs/epaper_bloc.dart';
import 'package:online_hunt_news/pages/epapers/magazine_category_list.dart';
import 'package:online_hunt_news/pages/epapers/periodical_widgets/daily_epaper.dart';
import 'package:online_hunt_news/pages/epapers/for_you.dart';
import 'package:online_hunt_news/pages/epapers/magazines/magazines.dart';
import 'package:online_hunt_news/pages/epapers/periodicals.dart';
import 'package:provider/provider.dart';

class EpaperTabbarView extends StatefulWidget {
  const EpaperTabbarView({super.key});

  @override
  State<EpaperTabbarView> createState() => _EpaperTabbarViewState();
}

class _EpaperTabbarViewState extends State<EpaperTabbarView> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  TabController? _tabController;
  int selectedIndex = 0;
  List<Tab> tabsList = [/* Tab(text: "web_papers".tr()), */ Tab(text: "for_you".tr()), Tab(text: "enewspapers".tr()), Tab(text: "magazines".tr())];
  @override
  void initState() {
    _tabController = TabController(length: tabsList.length, vsync: this);
    _tabController!.addListener(() {
      print(tabsList[_tabController!.index].text!);
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: _tabController == null ? SizedBox.shrink() : Text(tabsList[_tabController!.index].text!),
        elevation: 0,
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.refresh, size: 22),
          //   onPressed: () async {
          //     final ep = context.read<EpaperBloc>();
          //     ep.onRefresh(mounted);
          //   },
          // ),
        ],
        bottom: TabBar(
          labelStyle: TextStyle(fontFamily: 'Manrope', fontSize: 15, fontWeight: FontWeight.w600),
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Color(0xff5f6368), //niceish grey
          isScrollable: false,
          onTap: (index) {
            //_tabController.animateTo(index);
          },
          indicator: MD2Indicator(
            //it begins here
            indicatorHeight: 2,
            indicatorColor: Theme.of(context).primaryColor,
            indicatorSize: MD2IndicatorSize.normal,
          ),

          tabs: tabsList,
        ),
      ),
      body: TabBarView(controller: _tabController, children: [ForYou(), Periodicals(), MagazineCategoryList()]),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
