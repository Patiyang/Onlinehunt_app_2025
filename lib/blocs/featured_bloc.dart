import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:online_hunt_news/models/apiArticleModel.dart';
import 'package:online_hunt_news/models/article.dart';
import 'package:online_hunt_news/models/postModel.dart';
import 'package:online_hunt_news/services/post_service.dart';

import '../helpers&Widgets/key.dart';

class FeaturedBloc with ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Article> _data = [];
  List<Article> get data => _data;
  // List<ApiArticle> _apiArticle = [];
  // List<ApiArticle> get apiArticle => _apiArticle;
  List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;
  List featuredList = [];
  PostServices _postServices = PostServices();

  // Future<List> _getFeaturedList() async {
  //   final DocumentReference ref = firestore.collection('featured').doc('featured_list');
  //   DocumentSnapshot snap = await ref.get();
  //   featuredList = snap['contents'] ?? [];
  //   if (featuredList.isNotEmpty) {
  //     List<int> a = featuredList.map((e) => int.parse(e)).toList()..sort();
  //     List<String> b = a.take(10).toList().map((e) => e.toString()).toList();
  //     return b;
  //   } else {
  //     return featuredList;
  //   }
  // }

  // Future getData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   _getFeaturedList().whenComplete(() async {
  //     QuerySnapshot rawData;
  //     rawData = await firestore.collection('contents').where('timestamp', whereIn: featuredList).limit(10).get();

  //     List<DocumentSnapshot> _snap = [];
  //     _snap.addAll(rawData.docs);
  //     _data = _snap.map((e) => Article.fromFirestore(e)).where((element) {
  //       if ((prefs.getString('language') == null || prefs.getStringList('district') == null) && element.verified == true) {
  //         return true;
  //       } else if (element.articleType == 'rss' &&
  //           element.verified == true &&
  //           element.state == '' &&
  //           element.district == '' &&
  //           element.selectedLanguage == prefs.getString('language')) {
  //         return true;
  //       } else {
  //         if (element.uid == null && element.selectedLanguage == prefs.getString('language') && element.verified == true) {
  //           return true;
  //         } else if (element.selectedLanguage == (prefs.getString('language') ?? 'English') &&
  //             element.state == prefs.getString('state') &&
  //             element.verified == true) {
  //           return true;
  //         } else {
  //           return false;
  //         }
  //       }
  //     }).toList();
  //     _data.sort((a, b) => b.timestamp!.compareTo(a.timestamp!));
  //     notifyListeners();
  //   });
  // }
  Future getApiData(mounted) async {
    Map<String, dynamic> response = {};
    List<ApiArticle> articles = [];
    // _apiArticle = [];
    int languageID = await returnCategoryId();
    try {
      print('GETTING SLIDER');
      await _postServices
          .getPostsSelection('slider')
          .then((value) {
            response = jsonDecode(value.body);
          })
          .whenComplete(() {
            for (int i = 0; i < response['data'].length; i++) {
              posts.add(PostModel.fromJson(response['data'][i]));
            }
          });
      // articles.sort((a, b) => DateTime.parse(a.createdAt!).millisecondsSinceEpoch.compareTo(DateTime.parse(a.createdAt!).millisecondsSinceEpoch));
      // articles.forEach((element) {
      //   if (element.createdAt!.contains(DateTime.now().toString().substring(0, 10)) && element.langId == languageID) {
      //     _apiArticle.add(element);
      //   } else {
      //     if (element.langId == languageID) {
      //       _apiArticle.add(element);
      //     }
      //     _apiArticle = _apiArticle.isEmpty
      //         ? []
      //         : _apiArticle.length < 15
      //         ? _apiArticle
      //         : _apiArticle.sublist(0, 15);
      //   }
      // });
      // _apiArticle.removeWhere((element) => element.visibility == '0' ? true : false);
      // print('${_apiArticle.length} BACKED FEATURED ARTICLES LENGTH');
      // print('${await returnCategoryId()} BACKEND LANGUAGE ID');
    } catch (e) {
      print('THIS ERROR HAS BEEN ENCOUNTERED FEATURED ${e.toString()}');
    }
    // _apiArticle = _apiArticle.reversed.toList();
    notifyListeners();
  }

  onRefresh(mounted) {
    featuredList.clear();
    _data.clear();
    _posts.clear();
    // _apiArticle.clear();
    getApiData(mounted);
    notifyListeners();
  }
}
