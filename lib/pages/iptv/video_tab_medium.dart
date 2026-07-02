import 'package:flutter/material.dart';

import 'package:online_hunt_news/models/categoryModel.dart';
import 'package:online_hunt_news/pages/iptv/iptv_list.dart';
import 'package:online_hunt_news/pages/iptv/video_category_tab_generic.dart';
import 'package:online_hunt_news/tabs/categoryTabGeneric.dart';
import 'package:online_hunt_news/tabs/tab0.dart';

class VideoTabMediumAlt extends StatefulWidget {
  final List? controllers;
  final ScrollController? sc;
  final TabController? tc;
  final int? selectedIndex;
  final List<Category>? presentCategories;
  VideoTabMediumAlt({Key? key, this.sc, this.tc, this.selectedIndex, this.presentCategories, this.controllers}) : super(key: key);

  @override
  _VideoTabMediumAltState createState() => _VideoTabMediumAltState();
}

class _VideoTabMediumAltState extends State<VideoTabMediumAlt> {
  @override
  void initState() {
    // Fluttertoast.showToast(msg: widget.controllers!.toString());
    super.initState();
    // this.widget.sc!.addListener(_scrollListener);
  }

  // _scrollListener() {
  //   if (this.widget.sc!.offset >= this.widget.sc!.position.maxScrollExtent && !this.widget.sc!.position.outOfRange) {
  //     print("reached the bottom");
  //   }
  // }

  // @override
  // void dispose() {
  //   this.widget.sc!.removeListener(_scrollListener);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabBarViewItems = [IptvList()];

    for (int i = 0; i < widget.presentCategories!.length; i++) {
      tabBarViewItems.add(VideoCategoryTabGeneric(sc: widget.controllers![i], apiCategory: widget.presentCategories![i]));
    }
    return TabBarView(children: tabBarViewItems, controller: widget.tc);
  }
}
