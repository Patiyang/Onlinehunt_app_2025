import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';

import 'package:flutter/material.dart';
import 'package:online_hunt_news/blocs/recent_articles_bloc.dart';
import 'package:online_hunt_news/cards/card2.dart';
import 'package:online_hunt_news/models/apiCategoriesModel.dart';
import 'package:online_hunt_news/services/category_services.dart';
import 'package:online_hunt_news/utils/loading_cards.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
// import 'package:webfeed/domain/rss_feed.dart';
// import 'package:webfeed/webfeed.dart';
import '../helpers&Widgets/key.dart';

class RecentArticles extends StatefulWidget {
  RecentArticles({Key? key}) : super(key: key);

  @override
  _RecentArticlesState createState() => _RecentArticlesState();
}

class _RecentArticlesState extends State<RecentArticles> {
  CategoryServices categoryServices = CategoryServices();

  @override
  Widget build(BuildContext context) {
    final rb = context.watch<RecentBloc>();

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 15, bottom: 10, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 22,
                width: 4,
                decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(10)),
              ),
              SizedBox(width: 6),
              GestureDetector(
                onTap: () => rb.getApiData(mounted),
                child: Text(
                  'recent news',
                  style: TextStyle(fontSize: 18, letterSpacing: -0.6, wordSpacing: 1, fontWeight: FontWeight.bold),
                ).tr(),
              ),
            ],
          ),
        ),
        ListView.separated(
          padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
          physics: NeverScrollableScrollPhysics(),
          itemCount: rb.isLoading
              ? 2
              : rb.posts.length != 0
              ? rb.posts.length + 1
              : 1,
          separatorBuilder: (BuildContext context, int index) => SizedBox(height: 15),
          shrinkWrap: true,
          itemBuilder: (_, int index) {
            if (rb.isLoading) {
              return LoadingCard(height: 200);
            }
            if (index < rb.posts.length) {
              // if (index % 3 == 0 && index != 0) return Card5(apiArticle: rb.apiArticle[index], heroTag: 'recent$index');
              // if (index % 5 == 0 && index != 0)
              //   return Card4(apiArticle: rb.apiArticle[index], heroTag: 'recent$index');
              // else
              // return FutureBuilder(
              //   future: categoriesStream(rb.apiArticle[index].categoryId),
              //   builder: (BuildContext context, AsyncSnapshot snapshot) {
              //     return snapshot.hasData
              //         ? Card2(postModel: rb.posts[index], heroTag: 'recent$index', categoryName: snapshot.data)
              //         : LoadingCard(height: 200);
              //   },
              // );
              // return Text(rb.posts[index].author!.username);
              return Card2(postModel: rb.posts[index], heroTag: 'recent$index', categoryName: rb.posts[index].category!.name);
            }
            return SizedBox.shrink();
          },
        ),
      ],
    );
  }

  handleRssData() async {
    final client = IOClient(HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true));
    var response = await client.get(Uri.parse('https://www.astrology.com/us/offsite/rss/daily-extended.aspx'));
    // var channel = RssFeed.parse(response.body);
    // print(channel.image!.url);
    // for (int i = 0; i < channel.items!.length; i++) {
    //   print('Article number ${i + 1}: ${channel.items![i].media!.contents}');
    // }
  }

  categorriesStream(String? categoryId) async {
    List response = [];
    List<ApiCategories> dummyList = [];
    int language = await returnCategoryId();
    List<ApiCategories> apiCategories = [];
    String categoryName = '';
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
    for (int i = 0; i < apiCategories.length; i++) {
      if (apiCategories[i].categoyId == categoryId) {
        // setState(() {
        categoryName = apiCategories[i].categoyId!;
        // });
      }
    }
    return categoryName;
  }
}
