import 'package:flutter/material.dart';
import 'package:online_hunt_news/blocs/featured_epapers.dart';
import 'package:online_hunt_news/pages/epapers/magazines/magazines.dart';
import 'package:provider/provider.dart';

class MagazineCategoryList extends StatefulWidget {
  const MagazineCategoryList({super.key});

  @override
  State<MagazineCategoryList> createState() => _MagazineCategoryListState();
}

class _MagazineCategoryListState extends State<MagazineCategoryList> with AutomaticKeepAliveClientMixin {
  int _refreshToken = 0;
  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    final mb = context.watch<MagazineCategoriesBloc>();
    return RefreshIndicator(
      onRefresh: () async {
        mb.onRefresh(mounted);
        _refreshToken++;
        setState(() {});
      },
      child: ListView.builder(
        itemCount: mb.data.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return Magazines(magazineCategory: mb.data[index], refreshToken: _refreshToken);
        },
      ),
    );
  }

  getCategories() async {}
  @override
  bool get wantKeepAlive => true;
}
