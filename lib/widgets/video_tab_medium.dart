import 'package:flutter/material.dart';
// import 'package:online_hunt_news/blocs/category_tab13_bloc%20.dart';
import 'package:online_hunt_news/config/config.dart';
import 'package:online_hunt_news/models/apiCategoriesModel.dart';
// import 'package:online_hunt_news/tabs/category_tab13.dart';

import 'package:online_hunt_news/videoTabs/videoTabGeneric.dart';

class VideoTabMedium extends StatefulWidget {
  final ScrollController? sc;
  final TabController? tc;
  final String? orderBy;
  final List<ApiCategories>? presentCategories;

  VideoTabMedium({Key? key, this.sc, this.tc, this.orderBy, this.presentCategories}) : super(key: key);

  @override
  _VideoTabMediumState createState() => _VideoTabMediumState();
}

class _VideoTabMediumState extends State<VideoTabMedium> {
  @override
  void initState() {
    super.initState();
    // this.widget.sc!.addListener(_scrollListener);
    print(Config().initialCategories[0]);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabBarViewItems = [];

    for (int i = 0; i < widget.presentCategories!.length; i++) {
      // print(widget.presentCategories!.length);
      tabBarViewItems.add(
        VideoTabGeneric(
          category: widget.presentCategories![i].categoryName!,
          sc: widget.sc,
          orderBy: widget.orderBy!,
          categoryId: widget.presentCategories![i].categoyId,
        ),
      );
    }

    return TabBarView(children: tabBarViewItems, controller: widget.tc);
  }
}
