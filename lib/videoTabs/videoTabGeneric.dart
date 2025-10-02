import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:online_hunt_news/cards/card4.dart';
import 'package:online_hunt_news/cards/card5.dart';
import 'package:online_hunt_news/helpers&Widgets/loading.dart';
import 'package:online_hunt_news/models/admob_helper.dart';
import 'package:online_hunt_news/models/apiArticleModel.dart';
import 'package:online_hunt_news/models/article.dart';
import 'package:online_hunt_news/services/post_service.dart';
import 'package:online_hunt_news/utils/empty.dart';
import 'package:online_hunt_news/utils/loading_cards.dart';
import '../helpers&Widgets/key.dart';

class VideoTabGeneric extends StatefulWidget {
  final String category;
  final ScrollController? sc;
  final String? categoryId;
  final String orderBy;
  const VideoTabGeneric({Key? key, required this.category, required this.orderBy, this.sc, this.categoryId}) : super(key: key);

  @override
  _VideoTabGenericState createState() => _VideoTabGenericState();
}

class _VideoTabGenericState extends State<VideoTabGeneric> {
  String _orderBy = 'timestamp';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _snap = [];
  List<Article> _data = [];
  bool? _hasData;
  QuerySnapshot? rawData;
  DocumentSnapshot? _lastVisible;
  bool _isLoading = true;
  PostServices postServices = PostServices();
  List<ApiArticle> _articlesData = [];
  late List adsList;
  @override
  void initState() {
    // getData(mounted, widget.orderBy, widget.category);
    getApiData(mounted, widget.categoryId!);
    // this.widget.sc!.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    if (this.widget.sc!.offset >= this.widget.sc!.position.maxScrollExtent && !this.widget.sc!.position.outOfRange) {
      print("reached the bottom -t1");
      // _isLoading = true;
      // getData(
      //   mounted,
      //   widget.orderBy,
      //   widget.category,
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final vb = context.watch<VideosBloc>();
    return _isLoading == true
        ? Loading(text: 'please wait'.tr())
        : RefreshIndicator(
            onRefresh: () async {
              // onRefresh(mounted, _orderBy, widget.category);
              getApiData(mounted, widget.categoryId!);
            },
            child: _hasData == false || _articlesData.isEmpty
                ? ListView(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.35),
                      EmptyPage(icon: Feather.clipboard, message: 'no articles found'.tr(), message1: ''),
                    ],
                  )
                : ListView.separated(
                    padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                    // controller: controller,
                    physics: AlwaysScrollableScrollPhysics(),
                    // itemCount: _articlesData.length != 0 ? _articlesData.length + 1 : 5,
                    itemCount: adsList.length,
                    separatorBuilder: (BuildContext context, int index) => SizedBox(height: 15),
                    itemBuilder: (_, int index) {
                      if (adsList[index] is ApiArticle) {
                        if (index < _articlesData.length) {
                          // return SizedBox.shrink();
                          if (index.isOdd)
                            return Card4(apiArticle: _articlesData[index], heroTag: 'video$index', categoryName: widget.category);
                          else
                            return Card5(apiArticle: adsList[index], heroTag: 'video$index', categoryName: widget.category);
                        }
                        return Opacity(
                          opacity: _isLoading ? 1.0 : 0.0,
                          child: _lastVisible == null
                              ? LoadingCard(height: 250)
                              : Center(child: SizedBox(width: 32.0, height: 32.0, child: new CupertinoActivityIndicator())),
                        );
                      } else {
                        final Container adContent = Container(
                          width: AdmobHelper.getBannerAd().size.width.toDouble(),
                          height: AdmobHelper.getBannerAd().size.height.toDouble(),
                          child: AdWidget(ad: adsList[index] as BannerAd, key: UniqueKey()),
                        );
                        return adContent;
                      }
                    },
                  ),
          );
  }

  Future<Null> getData(mounted, String orderBy, String category) async {
    setState(() {
      _isLoading = true;
    });
    _hasData = true;
    QuerySnapshot rawData;

    if (_lastVisible == null)
      rawData = await firestore.collection('contents').where('content type', isEqualTo: 'video').orderBy(orderBy, descending: true).limit(6).get();
    else
      rawData = await firestore
          .collection('contents')
          .where('content type', isEqualTo: 'video')
          .orderBy(orderBy, descending: true)
          .startAfter([_lastVisible![orderBy]])
          .limit(6)
          .get();

    if (rawData.docs.length > 0) {
      _lastVisible = rawData.docs[rawData.docs.length - 1];
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _snap.addAll(rawData.docs);
        _data = _snap.map((e) => Article.fromFirestore(e)).where((element) {
          if (element.category == category) {
            return true;
          } else {
            return false;
          }
        }).toList();
      }
    } else {
      if (_lastVisible == null) {
        setState(() {
          _isLoading = false;
        });
        _hasData = false;
        print('no items');
      } else {
        setState(() {
          _isLoading = false;
        });
        _hasData = true;
        print('no more items');
      }
    }

    return null;
  }

  onRefresh(mounted, orderBy, category) {
    _isLoading = true;
    _snap.clear();
    _data.clear();
    _lastVisible = null;
    getData(mounted, orderBy, category);
  }

  getApiData(mounted, String categoryId) async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    List response = [];
    List<ApiArticle> articles = [];
    _articlesData = [];
    int languageID = await returnCategoryId();
    if (mounted) {
      try {
        await postServices
            .getAllPosts('posts')
            .then((value) {
              response = jsonDecode(utf8.decode(value.bodyBytes));
            })
            .whenComplete(() {
              for (int i = 0; i < response.length; i++) {
                articles.add(ApiArticle.fromJson(response[i]));
              }
            });
        articles.forEach((element) {
          if (element.langId == languageID && element.categoryId == categoryId && element.videoUrl!.isNotEmpty) {
            _articlesData.add(element);
          }
        });
        _articlesData.removeWhere((element) => element.visibility == '0' ? true : false);

        adsList = List.from(_articlesData);

        for (
          int i = 1;
          i <=
              (_articlesData.length > 20
                  ? getAriclesLength()
                  : _articlesData.length > 10
                  ? 1
                  : 0);
          i++
        ) {
          var min = 1;
          var random = Random();
          var randomPositions = min + random.nextInt(_articlesData.length);
          adsList.insert(randomPositions, AdmobHelper.getBannerAd()..load());
        }
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        print('${_articlesData.length} BACKED VIDEO ARTICLES LENGTH');
        // print('${await returnCategoryId()} BACKEND LANGUAGE ID');
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        print('THIS ERROR HAS BEEN ENCOUNTERED ${e.toString()}');
      }
    }
  }

  getAriclesLength() {
    if (_articlesData.length > 20 && _articlesData.length < 75) {
      return 4;
    } else if (_articlesData.length > 75 && _articlesData.length < 100) {
      return 6;
    } else if (_articlesData.length > 100) {
      return 8;
    }
  }
}
