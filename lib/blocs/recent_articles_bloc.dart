import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:online_hunt_news/models/postModel.dart';
import 'package:online_hunt_news/services/post_service.dart';
// import 'package:webfeed/webfeed.dart';

import '../helpers&Widgets/key.dart';

class RecentBloc extends ChangeNotifier {
  // List<Article> _data = [];
  // List<Article> get data => _data;
  // List<RssItem> _rssData = [];
  // List<RssItem> get rssData => _rssData;
  // List<ApiArticle> _apiArticle = [];
  // List<ApiArticle> get apiArticle => _apiArticle;
  List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _snap = [];
  PostServices _postServices = PostServices();

  DocumentSnapshot? _lastVisible;
  DocumentSnapshot? get lastVisible => _lastVisible;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  // Future<Null> getData(mounted) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   QuerySnapshot rawData;

  //   if (_lastVisible == null)
  //     rawData = await firestore.collection('contents').orderBy('timestamp', descending: true).limit(4).get();
  //   else
  //     rawData = await firestore.collection('contents').orderBy('timestamp', descending: true).startAfter([_lastVisible!['timestamp']]).limit(4).get();

  //   if (rawData.docs.length > 0) {
  //     _snap.clear();
  //     _lastVisible = rawData.docs[rawData.docs.length - 1];
  //     if (mounted) {
  //       print('mountrd: ' + mounted.toString());

  //       _snap.addAll(rawData.docs);
  //       _data = _snap.map((e) => Article.fromFirestore(e)).where((element) {
  //         if ((prefs.getString('language') == null || prefs.getStringList('district') == null) && element.verified == true) {
  //           return true;
  //         } else if (element.articleType == 'rss' &&
  //             element.verified == true &&
  //             element.state == '' &&
  //             element.district == '' &&
  //             element.selectedLanguage == prefs.getString('language')) {
  //           return true;
  //         } else {
  //           if (element.uid == null && element.selectedLanguage == prefs.getString('language') && element.verified == true) {
  //             return true;
  //           } else if (element.selectedLanguage == (prefs.getString('language') ?? 'English') &&
  //               element.state == prefs.getString('state') &&
  //               element.verified == true) {
  //             return true;
  //           } else {
  //             return false;
  //           }
  //         }
  //       }).toList();
  //       notifyListeners();
  //     }
  //   } else {
  //     // _isLoading = false;
  //     print('no items available');
  //     notifyListeners();
  //   }
  //   return null;
  // }

  Future getApiData(mounted) async {
    Map<String, dynamic> response = {};
    List<PostModel> articles = [];
    // _apiArticle = [];
    int languageID = await returnCategoryId();
    if (mounted) {
      try {
        print('GETTING RECENT');
        await _postServices
            .getAllPosts('posts')
            .then((value) {
              response = jsonDecode(utf8.decode(value.bodyBytes));
            })
            .whenComplete(() {
              print(response['data']);
              for (int i = 0; i < response['data'].length; i++) {
                posts.add(PostModel.fromJson(response['data'][i]));
              }
            });
        // articles.forEach((element) {
        //   if (element.langId == languageID) {
        //     _apiArticle.add(element);
        //   }
        // });
        // _apiArticle.removeWhere((element) => element.visibility == '0' ? true : false);

        // _apiArticle = _apiArticle.isEmpty
        //     ? []
        //     : _apiArticle.length < 4
        //     ? _apiArticle
        //     : _apiArticle.sublist(0, 4);
        // print('${_apiArticle.length} BACKED RECENT ARTICLES LENGTH');
        _isLoading = false;
      } catch (e) {
        _isLoading = false;
        print('THIS ERROR HAS BEEN ENCOUNTERED RECENT ${e.toString()}');
      }
    }

    notifyListeners();
  }

  // returnCategoryId() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   if (preferences.getString('language') == 'English') {
  //     return '1';
  //   } else if (preferences.getString('language') == 'Kannada') {
  //     return '3';
  //   }
  // }

  setLoading(bool isloading) {
    _isLoading = isloading;
  }

  onRefresh(mounted) {
    _isLoading = true;
    _snap.clear();
    _posts.clear();
    _lastVisible = null;
    // getData(mounted);
    posts.clear();
    getApiData(mounted);
    notifyListeners();
  }
}
