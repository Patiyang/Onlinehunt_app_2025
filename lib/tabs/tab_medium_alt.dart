import 'package:flutter/material.dart';

import 'package:online_hunt_news/models/categoryModel.dart';
import 'package:online_hunt_news/tabs/categoryTabGeneric.dart';
import 'package:online_hunt_news/tabs/tab0.dart';

class TabMediumAlt extends StatefulWidget {
  final List? controllers;
  final ScrollController? sc;
  final TabController? tc;
  final int? selectedIndex;
  final List<Category>? presentCategories;
  TabMediumAlt({Key? key, this.sc, this.tc, this.selectedIndex, this.presentCategories, this.controllers}) : super(key: key);

  @override
  _TabMediumAltState createState() => _TabMediumAltState();
}

class _TabMediumAltState extends State<TabMediumAlt> {
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
    List<Widget> tabBarViewItems = [Tab0()];

    for (int i = 0; i < widget.presentCategories!.length; i++) {
      tabBarViewItems.add(CategoryTabGeneric(sc: widget.controllers![i], apiCategory: widget.presentCategories![i]));
    }
    return TabBarView(children: tabBarViewItems, controller: widget.tc);
  }
}
