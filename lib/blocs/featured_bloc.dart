import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:online_hunt_news/models/article.dart';
import 'package:online_hunt_news/models/postModel.dart';
import 'package:online_hunt_news/services/post_service.dart';

import '../helpers&Widgets/key.dart';

class FeaturedBloc with ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // List<ApiArticle> get apiArticle => _apiArticle;
  List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;
  // List featuredList = [];
  PostServices _postServices = PostServices();


  Future getApiData(mounted) async {
    Map<String, dynamic> response = {};
    // _apiArticle = [];
    posts.clear();
    await returnCategoryId();
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

    } catch (e) {
      print('THIS ERROR HAS BEEN ENCOUNTERED FEATURED ${e.toString()}');
    }
    // _apiArticle = _apiArticle.reversed.toList();
    notifyListeners();
  }

  onRefresh(mounted) async {
    // featuredList.clear();
    _posts.clear();
    // _apiArticle.clear();
    await getApiData(mounted);
    notifyListeners();
  }
}
