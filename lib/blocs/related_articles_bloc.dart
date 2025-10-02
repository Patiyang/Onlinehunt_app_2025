// import 'dart:convert';
// import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import 'package:online_hunt_news/models/admob_helper.dart';
// import 'package:online_hunt_news/models/apiArticleModel.dart';
// import 'package:online_hunt_news/models/article.dart';
// import 'package:online_hunt_news/models/postModel.dart';
// import 'package:online_hunt_news/services/post_service.dart';
// import '../helpers&Widgets/key.dart';

// class RelatedBloc extends ChangeNotifier {
//   // List<Article> _data = [];
//   // List<Article> get data => _data;
//   // List<ApiArticle> _apiArticle = [];
//   // List<ApiArticle> get apiArticle => _apiArticle;
//   List<PostModel> _posts = [];
//   List<PostModel> get posts => _posts;
//   List<Object> _adsList = [];
//   List get adsList => _adsList;
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   PostServices _postServices = PostServices();
//   bool _loading = true;
//   bool get loading => _loading;

//   Future getPosts(String categoryId, mounted) async {
//     _posts.clear();
//     Map<String, dynamic> response = {};
//     List<PostModel> dummyList = [];
//     int language = await returnCategoryId();
//     // List<ApiCategories> apiCategories = [];
//     try {
//       if (mounted) {
//         _loading = true;
//         await _postServices
//             .getRelatedPosts('posts')
//             .then((value) {
//               response = jsonDecode(value.body);
//             })
//             .whenComplete(() {
//               for (int i = 0; i < response['data'].length; i++) {
//                 posts.add(PostModel.fromJson(response['data'][i]));
//               }
//             });
//         // dummyList.forEach((element) {
//         //   if (element.langId == language && element.categoryId == categoryId) {
//         //     _apiArticle.add(element);
//         //   }
//         // });
//         // _apiArticle.removeWhere((element) => element.visibility == '0' ? true : false);

//         _adsList = List.from(_apiArticle);

//         if (_adsList.isNotEmpty) {
//           for (
//             int i = 1;
//             i <=
//                 (_apiArticle.length > 20
//                     ? getAriclesLength()
//                     : _apiArticle.length > 10
//                     ? 1
//                     : 0);
//             i++
//           ) {
//             var min = 1;
//             var random = Random();
//             var randomPositions = min + random.nextInt(_apiArticle.length);

//             adsList.insert(randomPositions, AdmobHelper.getBannerAd()..load());
//           }
//         } else {
//           _adsList = List.from(_apiArticle);
//         }

//         _loading = false;
//         print('${posts.length} BACKEND RECENT ARTICLES LENGTH');
//       }
//     } catch (e) {
//       _loading = false;
//       print(e.toString());
//     }
//     notifyListeners();
//   }

//   getAriclesLength() {
//     if (_apiArticle.length > 20 && _apiArticle.length < 75) {
//       return 4;
//     } else if (_apiArticle.length > 75 && _apiArticle.length < 100) {
//       return 6;
//     } else if (_apiArticle.length > 100) {
//       return 8;
//     }
//   }

//   onRefresh(mounted, String stateName, String timestamp) {
//     // _loading = true
//     _data.clear();
//     // getData(stateName, timestamp);
//     getApiCategories(stateName, mounted);
//     notifyListeners();
//   }
// }
