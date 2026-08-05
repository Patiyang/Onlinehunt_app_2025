import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:online_hunt_news/models/article.dart';
import 'package:online_hunt_news/models/bookmarkPostModel.dart';
import 'package:online_hunt_news/models/postModel.dart';
import 'package:online_hunt_news/services/bookmark_services.dart';
import 'package:online_hunt_news/services/post_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkBloc extends ChangeNotifier {
  List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;
  List featuredList = [];
  BookmarkServices _bookmarkServices = BookmarkServices();
  bool _loading = true;
  bool get loading => _loading;
  // Future<List> getArticles() async {
  //   String _collectionName = 'contents';
  //   String _fieldName = 'bookmarked items';
  //   List<Article> data = [];
  //   List<DocumentSnapshot> _snap = [];

  //   SharedPreferences sp = await SharedPreferences.getInstance();
  //   String? _uid = sp.getString('uid');

  //   final DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(_uid);
  //   DocumentSnapshot snap = await ref.get();
  //   List d = snap[_fieldName];

  //   if (d.isNotEmpty) {
  //     QuerySnapshot rawData = await FirebaseFirestore.instance.collection(_collectionName).where('timestamp', whereIn: d).get();
  //     _snap.addAll(rawData.docs);
  //     data = _snap.map((e) => Article.fromFirestore(e)).toList();
  //   }

  //   return data;
  // }

  // Future onBookmarkIconClick(String? timestamp) async {
  //   final SharedPreferences sp = await SharedPreferences.getInstance();
  //   String? _uid = sp.getString('uid');
  //   String _fieldName = 'bookmarked items';

  //   final DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(_uid);
  //   DocumentSnapshot snap = await ref.get();
  //   List d = snap[_fieldName];

  //   if (d.contains(timestamp)) {
  //     List a = [timestamp];
  //     await ref.update({_fieldName: FieldValue.arrayRemove(a)});
  //   } else {
  //     d.add(timestamp);
  //     await ref.update({_fieldName: FieldValue.arrayUnion(d)});
  //   }

  //   notifyListeners();
  // }

  // Future onLoveIconClick(String? timestamp) async {
  //   final SharedPreferences sp = await SharedPreferences.getInstance();
  //   final String _collectionName = 'contents';
  //   String? _uid = sp.getString('uid');
  //   String _fieldName = 'loved items';

  //   final DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(_uid);
  //   final DocumentReference ref1 = FirebaseFirestore.instance.collection(_collectionName).doc(timestamp);

  //   DocumentSnapshot snap = await ref.get();
  //   DocumentSnapshot snap1 = await ref1.get();
  //   List d = snap[_fieldName];
  //   int? _loves = snap1['loves'];

  //   if (d.contains(timestamp)) {
  //     List a = [timestamp];
  //     await ref.update({_fieldName: FieldValue.arrayRemove(a)});
  //     ref1.update({'loves': _loves! - 1});
  //   } else {
  //     d.add(timestamp);
  //     await ref.update({_fieldName: FieldValue.arrayUnion(d)});
  //     ref1.update({'loves': _loves! + 1});
  //   }
  // }

  Future getApiData(mounted, int user_id) async {
    Map<String, dynamic> response = {};
    // _apiArticle = [];
    posts.clear();
    // await returnCategoryId();
    try {
      print('GETTING SLIDER');
      await _bookmarkServices
          .getUserBookmarks(user_id)
          .then((value) {
            response = jsonDecode(value.body);
          })
          .whenComplete(() {
            for (int i = 0; i < response['data'].length; i++) {
              posts.add(PostModel.fromJson(response['data'][i]));
            }
          });
    } catch (e) {
      print('THIS ERROR HAS BEEN ENCOUNTERED FEATURED ${e.toString()}');
    }
    _loading = false;

    // _apiArticle = _apiArticle.reversed.toList();
    notifyListeners();
  }

  Future<List<BookmarkPostModel>> getFutureData(mounted, int user_id) async {
    Map<String, dynamic> response = {};
    // _apiArticle = [];
    List<BookmarkPostModel> posts = [];
    // await returnCategoryId();
    try {
      print('GETTING SLIDER');
      await _bookmarkServices
          .getUserBookmarks(user_id)
          .then((value) {
            response = jsonDecode(value.body);
          })
          .whenComplete(() {
            for (int i = 0; i < response['data'].length; i++) {
              posts.add(BookmarkPostModel.fromJson(response['data'][i]));
            }
          });
    } catch (e) {
      print('THIS ERROR HAS BEEN ENCOUNTERED FEATURED ${e.toString()}');
    }
    _loading = false;
    return posts;
    // _apiArticle = _apiArticle.reversed.toList();
    // notifyListeners();
  }

  onRefresh(mounted, int user_id) async {
    _loading = true;

    featuredList.clear();
    _posts.clear();
    // _apiArticle.clear();
    await getApiData(mounted, user_id);
    notifyListeners();
  }
}
