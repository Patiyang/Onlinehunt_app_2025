import 'package:flutter/material.dart';
import 'package:online_hunt_news/blocs/featured_bloc.dart';
import 'package:online_hunt_news/blocs/popular_articles_bloc.dart';
import 'package:online_hunt_news/blocs/recent_articles_bloc.dart';
import 'package:online_hunt_news/widgets/featured.dart';
import 'package:online_hunt_news/widgets/popular_articles.dart';
import 'package:online_hunt_news/widgets/recent_articles.dart';
import 'package:online_hunt_news/widgets/search_bar.dart' as sbwidget;
import 'package:provider/provider.dart';

class Tab0 extends StatefulWidget {
  Tab0({Key? key}) : super(key: key);

  @override
  _Tab0State createState() => _Tab0State();
}

class _Tab0State extends State<Tab0> with AutomaticKeepAliveClientMixin {
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    // refresh();
    super.initState();
  }

  _scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent && !scrollController.position.outOfRange) {
      print('reached bottom');
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () => refresh(context),
      child: SingleChildScrollView(
        controller: scrollController,
        key: PageStorageKey('key0'),
        padding: EdgeInsets.all(0),
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(children: [sbwidget.SearchBar(), SliderWidget(), PopularWidget(), RecentArticles()]),
      ),
    );
  }

  refresh(BuildContext context) async {
    context.read<FeaturedBloc>().onRefresh(mounted);
    context.read<PopularBloc>().onRefresh(mounted, context: context);
    context.read<RecentBloc>().onRefresh(mounted);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
