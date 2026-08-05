import 'package:flutter/material.dart';
// import 'package:flutter_icons/flutter_icons.dart';
import 'package:online_hunt_news/blocs/bookmark_bloc.dart';
import 'package:online_hunt_news/blocs/sign_in_bloc.dart';
import 'package:online_hunt_news/cards/card4.dart';
import 'package:online_hunt_news/models/bookmarkPostModel.dart';
import 'package:online_hunt_news/utils/empty.dart';
import 'package:online_hunt_news/utils/loading_cards.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final SignInBloc sb = context.watch<SignInBloc>();

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(title: Text('bookmarks').tr(), centerTitle: false),
        body: sb.guestUser
            ? EmptyPage(icon: Icons.person, message: 'sign in first'.tr(), message1: "sign in to save your favourite articles here".tr())
            : BookmarkedArticles(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class BookmarkedArticles extends StatefulWidget {
  const BookmarkedArticles({Key? key}) : super(key: key);

  @override
  _BookmarkedArticlesState createState() => _BookmarkedArticlesState();
}

class _BookmarkedArticlesState extends State<BookmarkedArticles> {
  @override
  void initState() {
    // initializeBookmarks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bb = context.watch<BookmarkBloc>();
    final ub = context.watch<SignInBloc>();

    return Container(
      child: FutureBuilder(
        future: bb.getFutureData(mounted, int.parse(ub.uid!)),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0)
              return EmptyPage(icon: Icons.bookmark, message: 'no articles found'.tr(), message1: 'save your favourite articles here'.tr());
            else {
              // print(snapshot.data.runtimeType);
              List<BookmarkPostModel> data = snapshot.data;
              return ListView.separated(
                padding: EdgeInsets.all(15),
                itemCount: snapshot.data.length,
                separatorBuilder: (context, index) => SizedBox(height: 15),
                itemBuilder: (BuildContext context, int index) {
                  // return SizedBox.shrink();
                  return Card4(apiArticle: data[index], heroTag: 'bookmarks$index');
                },
              );
            }
          }
          return ListView.separated(
            padding: EdgeInsets.all(15),
            itemCount: 8,
            separatorBuilder: (BuildContext context, int index) => SizedBox(height: 15),
            itemBuilder: (BuildContext context, int index) {
              return LoadingCard(height: 160);
            },
          );
        },
      ),
    );
  }

  void initializeBookmarks() {
    final ub = context.watch<SignInBloc>();

    context.read<BookmarkBloc>().getApiData(mounted, int.parse(ub.uid!));
  }
}
