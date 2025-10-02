import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_hunt_news/helpers&Widgets/key.dart';
import 'package:online_hunt_news/models/apiArticleModel.dart';
import 'package:online_hunt_news/models/article.dart';
import 'package:online_hunt_news/models/postModel.dart';
import 'package:online_hunt_news/services/post_service.dart';

class PopularBloc extends ChangeNotifier {
  List<Article> _data = [];
  List<Article> get data => _data;
  List<ApiArticle> _apiArticle = [];
    List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;

  List<ApiArticle> get apiArticle => _apiArticle;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  PostServices _postServices = PostServices();
  List _adsList = [];
  List get adsList => _adsList;
  bool _loading = true;
  bool get loading => _loading;

  Future getApiData(mounted, BuildContext context) async {
    Map<String, dynamic> response = {};
    List<ApiArticle> articles = [];
    // _apiArticle = [];
    int languageID = await returnCategoryId();
    if (mounted) {
      _loading = true;

      print('GETTING Featured');
      await _postServices
          .getPostsSelection('featured')
          .then((value) {
            response = jsonDecode(value.body);
            // print(response);
          })
          .whenComplete(() {
            for (int i = 0; i < response['data'].length; i++) {
              posts.add(PostModel.fromJson(response['data'][i]));
            }
            Comparator<ApiArticle> sortById = (a, b) => a.pageViews!.compareTo(b.pageViews!);
            articles.sort(sortById);
            print('length of api articles is ${articles.length}');
          });
      // articles.sort((a, b) => int.parse(a.pageViews!).compareTo(int.parse(b.pageViews!)));

      // articles.forEach((element) {
      //   if (element.langId == languageID) {
      //     _apiArticle.add(element);
      //   }
      // });
      // _apiArticle = _apiArticle.reversed.toList();
      // _apiArticle = _apiArticle.isEmpty
      //     ? []
      //     : _apiArticle.length < 10
      //     ? _apiArticle
      //     : _apiArticle.sublist(0, 10);
      // _apiArticle.removeWhere((element) => element.visibility == '0' ? true : false);

      // _adsList = List.from(_apiArticle);

      // var min = 1;
      // var random = Random();
      // var randomPositions = min + random.nextInt(_apiArticle.length);
      // await AdServices().getMobileAds('1', adspace: 'main_screen_ad').then((value) {
      //   print(value);
      //   if (value.isNotEmpty) {
      //     adsList.insert(randomPositions, value[0]);
      //   }
      // });
      _loading = false;
    }
    try {
      // if (mounted) {
      //   _loading = true;

      //   print('GETTING POPULAR');
      //   await _postServices.getPosts('popular_posts').then((value) {
      //     response = jsonDecode(utf8.decode(value.bodyBytes));
      //   }).whenComplete(() {
      //     for (int i = 0; i < response.length; i++) {
      //       articles.add(ApiArticle.fromJson(response[i]));
      //     }
      //     Comparator<ApiArticle> sortById = (a, b) => a.pageViews!.compareTo(b.pageViews!);
      //     articles.sort(sortById);
      //   });
      //   // articles.sort((a, b) => int.parse(a.pageViews!).compareTo(int.parse(b.pageViews!)));

      //   articles.forEach((element) {
      //     if (element.langId == languageID) {
      //       _apiArticle.add(element);
      //     }
      //   });
      //   _apiArticle = _apiArticle.reversed.toList();
      //   _apiArticle = _apiArticle.isEmpty
      //       ? []
      //       : _apiArticle.length < 10
      //           ? _apiArticle
      //           : _apiArticle.sublist(0, 10);
      //   _apiArticle.removeWhere((element) => element.visibility == '0' ? true : false);

      //   _adsList = List.from(_apiArticle);

      //   var min = 1;
      //   var random = Random();
      //   var randomPositions = min + random.nextInt(_apiArticle.length);
      //   await AdServices().getMobileAds('1', adspace: 'main_screen_ad').then((value) {
      //     if (value.isNotEmpty) {
      //       adsList.insert(randomPositions, CustomMobileAd.getBannerAd(context, value[0]));
      //     }
      //   });
      //   _loading = false;
      // }
    } catch (e) {
      throw Exception('popular error is $e');
    }

    notifyListeners();
  }

  getAriclesLength() {
    if (_apiArticle.length > 20 && _apiArticle.length < 75) {
      return 4;
    } else if (_apiArticle.length > 75 && _apiArticle.length < 100) {
      return 6;
    } else if (_apiArticle.length > 100) {
      return 8;
    }
  }

  onRefresh(mounted, {BuildContext? context}) {
    _data.clear();
    _apiArticle.clear();
    _posts.clear();
    getApiData(mounted, context!);
    notifyListeners();
  }
}
