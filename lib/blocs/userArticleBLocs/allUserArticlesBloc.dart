import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:online_hunt_news/models/apiArticleModel.dart';
import 'package:online_hunt_news/models/apiUserModel.dart';
import 'package:online_hunt_news/models/article.dart';
import 'package:online_hunt_news/services/post_service.dart';
import 'package:online_hunt_news/services/userServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllUserArticlesBloc with ChangeNotifier {
  List<Article> _data = [];
  List<Article> get data => _data;
  List<ApiArticle> _apiArticle = [];
  List<ApiArticle> get apiArticle => _apiArticle;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<DocumentSnapshot> _snap = [];
  PostServices _postServices = PostServices();
  UserServices _userServices = UserServices();
  DocumentSnapshot? _lastVisible;
  DocumentSnapshot? get lastVisible => _lastVisible;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  // Future<Null> getData(mounted) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   QuerySnapshot rawData;

  //   rawData = await firestore.collection('contents').orderBy('timestamp', descending: true).where('uid', isEqualTo: auth.currentUser!.uid).get();

  //   if (rawData.docs.length > 0) {
  //     _snap.clear();
  //     _lastVisible = rawData.docs[rawData.docs.length - 1];
  //     if (mounted) {
  //       print('mountrd: ' + mounted.toString());
  //       _isLoading = false;
  //       _snap.addAll(rawData.docs);
  //       _data = _snap.map((e) => Article.fromFirestore(e)).where((element) => true).toList();
  //       notifyListeners();
  //     }
  //   } else {
  //     _isLoading = false;
  //     print('no items available');
  //     notifyListeners();
  //   }
  //   return null;
  // }

  Future getApiData(mounted) async {
    _apiArticle.clear();
    List response = [];
    List<ApiArticle> articles = [];
    // _apiArticle = [];
    String userIdd = await getUserId();
    final SharedPreferences sp = await SharedPreferences.getInstance();

    if (mounted) {
      try {
        // print('GETTING ALL USER ARTICLES');
        // Fluttertoast.showToast(msg: userIdd);
        await UserServices().userArticles(sp.getString('uid')).then((value) {
          articles = value;
        });
        articles.forEach((element) {
          if (element.userId == userIdd) {
            _apiArticle.add(element);
          }
        });
        _isLoading = false;
      } catch (e) {
        _isLoading = false;
        print('THIS ERROR HAS BEEN ENCOUNTERED FEATURED ${e.toString()}');
      }
    }

    // _apiArticle = _apiArticle.reversed.toList();
    notifyListeners();
  }

  Future getUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List response = [];
    List<UserModel> dummyList = [];
    String userId = '';
    try {
      await _userServices
          .getUsers('users')
          .then((value) {
            response = jsonDecode(utf8.decode(value.bodyBytes));
          })
          .whenComplete(() {
            response.forEach((element) {
              dummyList.add(UserModel.fromJson(element));
            });
          });
      dummyList.forEach((element) {
        if (element.email == sp.getString('email')) {
          userId = element.id!;
        }
      });
      // Fluttertoast.showToast(msg: userId);
    } catch (e) {
      print(e.toString());
    }
    return userId;
  }

  setLoading(bool isloading) {
    _isLoading = isloading;
    notifyListeners();
  }

  onRefresh(mounted) {
    _isLoading = true;
    _snap.clear();
    _data.clear();
    _apiArticle.clear();
    _lastVisible = null;
    getApiData(mounted);
    notifyListeners();
  }
}
