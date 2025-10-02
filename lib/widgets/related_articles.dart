import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:online_hunt_news/cards/card3.dart';
import 'package:online_hunt_news/helpers&Widgets/loading.dart';
import 'package:online_hunt_news/models/apiArticleModel.dart';
import 'package:online_hunt_news/models/categoryModel.dart';
import 'package:online_hunt_news/models/postModel.dart';
import 'package:easy_localization/easy_localization.dart';
import '../helpers&Widgets/key.dart';

import '../services/post_service.dart';

class RelatedArticles extends StatefulWidget {
  final Category? category;
  final PostModel? post;
  final String? timestamp;
  final bool? replace;
  final String categoryId;
  final ScrollController? sc;
  RelatedArticles({Key? key, required this.category, required this.timestamp, this.replace, required this.categoryId, this.sc, this.post}) : super(key: key);

  @override
  _RelatedArticlesState createState() => _RelatedArticlesState();
}

class _RelatedArticlesState extends State<RelatedArticles> {
  int _lastIndex = 0;
  int currentPage = 1;
  late List<Object> adsList;
  PostServices postServices = PostServices();
  bool _isLoading = true;
  bool _isLoadingMore = false;
  List<PostModel> _posts = [];

  @override
  void initState() {
    super.initState();
    // this.widget.sc!.animateTo(
    //       0.0,
    //       curve: Curves.easeOut,
    //       duration: const Duration(milliseconds: 300),
    //     );
    getApiData(mounted, widget.category!, false);
    // context.read<RelatedBloc>().getApiCategories(widget.categoryId, mounted);
    this.widget.sc!.addListener(_scrollListener);
  }

  _scrollListener() {
    if (this.widget.sc!.offset >= this.widget.sc!.position.maxScrollExtent && !this.widget.sc!.position.outOfRange) {
      getApiData(mounted, widget.category!, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final rb = context.watch<RelatedBloc>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 0, top: 10),
          child: GestureDetector(
            onTap: () {
              getApiData(mounted, widget.post!.category!, false);
            },
            child: Text('you might also like', style: TextStyle(letterSpacing: -0.6, wordSpacing: 1, fontSize: 18, fontWeight: FontWeight.bold)).tr(),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 8, bottom: 8),
          height: 3,
          width: 100,
          decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(40)),
        ),
        _isLoading == true
            ? Loading()
            : Container(
                width: MediaQuery.of(context).size.width,
                child: ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  shrinkWrap: true,
                  itemCount: _posts.length,
                  separatorBuilder: (context, index) => SizedBox(height: 15),
                  itemBuilder: (BuildContext context, int index) {
                    if (_posts.isEmpty) return Container();
                    return Card3(postModel: _posts[index], heroTag: null, replace: true, categoryName: widget.category!.name,author:  _posts[index].author,);
                    // if (index == adsList.length) {
                    //   return _buildProgressIndicator();
                    // }
                    // if (adsList[index] is ApiArticle) {
                    //   if (adsList.isEmpty) return Container();
                    //   return Card3(postModel: adsList[index] , heroTag: null, replace: true, categoryName: widget.category!.categoryName);
                    // } else {
                    //   final Container adContent = Container(
                    //     width: AdmobHelper.getBannerAd().size.width.toDouble(),
                    //     height: AdmobHelper.getBannerAd().size.height.toDouble(),
                    //     child: AdWidget(ad: adsList[index] as BannerAd, key: UniqueKey()),
                    //   );
                    //   return adContent;
                    // }
                  },
                ),
              ),
      ],
    );
  }

  getApiData(bool mounted, Category category, bool updateList) async {
    if (mounted && updateList == false) {
      setState(() {
        _isLoading = true;
        currentPage = 1;
        _posts = [];
      });
    }
    if (mounted && !_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });
    }
    Map<String, dynamic> response = {};
    List<ApiArticle> articles = [];
    int languageID = await returnCategoryId();
    try {
      await postServices
          .getRelatedPosts(widget.post!.id)
          .then((value) {
            response = jsonDecode(value.body);
          })
          .whenComplete(() {
            for (int i = 0; i < response['data'].length; i++) {
              _posts.add(PostModel.fromJson(response['data'][i]));
            }
          });
      // articles.forEach((element) {
      //   if (element.langId == languageID && element.categoryId == category.id) {
      //     if (_articlesData.isNotEmpty) {
      //       _articlesData.any((data) {
      //         if (data.id == element.id) {
      //           print('true');
      //           return false;
      //         } else {
      //           _articlesData.add(element);
      //           print('false');
      //           return true;
      //         }
      //       });
      //     } else {
      //       _articlesData.add(element);
      //     }

      //     // stringList.add(element.id!);
      //   }
      // });
      // _articlesData.removeWhere((element) => element.visibility == '0' ? true : false);

      // adsList = List.from(_articlesData);

      // for (int i = 1; i <= _articlesData.length; i++) {
      //   var min = 1;
      //   var random = Random();
      //   var randomPositions = min + random.nextInt(_articlesData.length);
      //   if ((i + 1) % 5 == 0) {
      //     adsList.insert(i, AdmobHelper.getBannerAd()..load());
      //   }
      // }
      if (mounted && updateList == false) {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
      } else if (mounted && updateList == true) {
        setState(() {
          currentPage++;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
      print('THIS ERROR HAS BEEN ENCOUNTERED ${e.toString()}');
    }
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(opacity: _isLoadingMore ? 1.0 : 00, child: new Loading()),
      ),
    );
  }
}
