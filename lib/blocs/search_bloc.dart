import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_hunt_news/models/apiArticleModel.dart';
import 'package:online_hunt_news/models/article.dart';
import 'package:online_hunt_news/services/post_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers&Widgets/key.dart';

class SearchBloc with ChangeNotifier {
  SearchBloc() {
    getRecentSearchList();
  }

  List<String> _recentSearchData = [];
  List<String> get recentSearchData => _recentSearchData;

  String _searchText = '';
  String get searchText => _searchText;

  bool _searchStarted = false;
  bool get searchStarted => _searchStarted;

  TextEditingController _textFieldCtrl = TextEditingController();
  TextEditingController get textfieldCtrl => _textFieldCtrl;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  PostServices _postServices = PostServices();
  Future getRecentSearchList() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _recentSearchData = sp.getStringList('recent_search_data') ?? [];
    notifyListeners();
  }

  Future addToSearchList(String value) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _recentSearchData.add(value);
    await sp.setStringList('recent_search_data', _recentSearchData);
    notifyListeners();
  }

  Future removeFromSearchList(String value) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _recentSearchData.remove(value);
    await sp.setStringList('recent_search_data', _recentSearchData);
    notifyListeners();
  }

  Future<List> getData() async {
    List<Article> data = [];
    QuerySnapshot rawData = await firestore.collection('contents').orderBy('timestamp', descending: true).get();

    List<DocumentSnapshot> _snap = [];
    _snap.addAll(
      rawData.docs.where(
        (u) =>
            (u['title'].toLowerCase().contains(_searchText.toLowerCase()) ||
            u['category'].toLowerCase().contains(_searchText.toLowerCase()) ||
            u['description'].toLowerCase().contains(_searchText.toLowerCase())),
      ),
    );
    data = _snap.map((e) => Article.fromFirestore(e)).toList();
    return data;
  }

  Future getApiData() async {
    Map<String, dynamic> response = {};
    List<ApiArticle> articles = [];
    List<ApiArticle> _apiArticle = [];
    int languageID = await returnCategoryId();
    try {
      // Fluttertoast.showToast(msg: 'GETTING RECENT');
      await _postServices
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
        if ((element.title!.toLowerCase().contains(_searchText.toLowerCase()) ||
            element.content!.toLowerCase().contains(_searchText.toLowerCase()) ||
            element.summary!.toLowerCase().contains(_searchText.toLowerCase()))) {
          print(element.title);
          _apiArticle.add(element);
        }
      });
      _apiArticle.removeWhere((element) => element.visibility == '0' ? true : false);
    } catch (e) {
      print('THIS ERROR HAS BEEN ENCOUNTERED RECENT ${e.toString()}');
    }
    return _apiArticle;
  }

  setSearchText(value) {
    _textFieldCtrl.text = value;
    _searchText = value;
    _searchStarted = true;
    notifyListeners();
  }

  saerchInitialize() {
    _textFieldCtrl.clear();
    _searchStarted = false;
    notifyListeners();
  }
}
