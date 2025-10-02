import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';
import 'package:online_hunt_news/helpers&Widgets/key.dart';
import 'package:online_hunt_news/models/apiArticleModel.dart';
import 'package:online_hunt_news/models/apiUserModel.dart';
import 'package:online_hunt_news/models/followingModel.dart';
import 'package:online_hunt_news/models/like_model.dart';
import 'package:online_hunt_news/services/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserServices {
  Future<http.Response> getUsers(String param) async {
    String url = HelperClass().getBaseUrl(param);
    final res = await TokenService().urlGetAuthentication(url);
    return res;
  }

  Future<http.Response> createUser(String param, body) async {
    String url = HelperClass().getBaseUrl(param);
    final res = await TokenService().urlPostAuthentication(url, body);
    return res;
  }

  Future<ApiUserModel> getUserDetails() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    List<ApiUserModel> dummyList = [];
    ApiUserModel apiUser = ApiUserModel();
    List response = [];
    String? _email = sp.getString('email');
    if (sp.getString('uid')!.isEmpty) {
      try {
        await getUsers('users')
            .then((value) {
              response = jsonDecode(utf8.decode(value.bodyBytes));
            })
            .whenComplete(() {
              response.forEach((element) {
                dummyList.add(ApiUserModel.fromJson(element));
              });
            });
        dummyList.forEach((element) {
          if (element.email == _email) {
            apiUser = element;
          }
        });

        sp.setString('uid', apiUser.id!);
      } catch (e) {
        print(e.toString());
      }
    }

    return apiUser;
  }

  Future<ApiUserModel> getUserById(String id) async {
    List<ApiUserModel> dummyList = [];
    ApiUserModel apiUser = ApiUserModel();
    List response = [];
    try {
      await getUsers('users')
          .then((value) {
            response = jsonDecode(utf8.decode(value.bodyBytes));
          })
          .whenComplete(() {
            response.forEach((element) {
              dummyList.add(ApiUserModel.fromJson(element));
            });
          });
      dummyList.forEach((element) {
        if (element.id == id) {
          apiUser = element;
        }
      });
    } catch (e) {
      print(e.toString());
    }
    return apiUser;
  }

  Future<http.Response> getUsersAlt(String id, String param) async {
    String url = 'https://onlinehunt.in/api/$param.php?api_key=$apiKey&id=$id';
    // print(url);
    final res = await TokenService().urlGetAuthentication(url);
    return res;
  }

  Future<ApiUserModel> userDetails(String id) async {
    ApiUserModel apiUser = ApiUserModel();
    List response = [];
    try {
      await getUsersAlt(id, 'single_user')
          .then((value) {
            response = jsonDecode(utf8.decode(value.bodyBytes));
          })
          .whenComplete(() {
            apiUser = ApiUserModel.fromJson(response.first);
          });
    } catch (e) {
      print(e.toString());
    }
    return apiUser;
  }

  Future<List<ApiArticle>> userArticles(String? id, {int? currentPage}) async {
    List response = [];
    List<ApiArticle> userArticles = [];
    try {
      await getUsersAlt(id!, 'single_user_posts')
          .then((value) {
            response = jsonDecode(utf8.decode(value.bodyBytes));
          })
          .whenComplete(() {
            response.forEach((element) {
              userArticles.add(ApiArticle.fromJson(element));
            });
          });
    } catch (e) {
      print('error is ${e.toString()}');
    }
    return userArticles;
  }

  Future<ApiUserModel> signInUser(String email, String password) async {
    Map mapRes = {};
    ApiUserModel? apiUserModel;
    String url = 'https://onlinehunt.in/api/signIn.php?api_key=$apiKey&email=$email&password=$password';
    try {
      http.Response res = await TokenService().urlGetAuthentication(url);
      mapRes = jsonDecode(res.body);
      // print(url);
      // print(mapRes['userdata']);
      if (mapRes['status'] == true) {
        apiUserModel = ApiUserModel.fromJson(mapRes['userdata']);
        Fluttertoast.showToast(msg: mapRes['message']);
      } else {
        Fluttertoast.showToast(msg: mapRes['message']);
      }
    } catch (e) {
      print(e.toString());
    }
    return apiUserModel!;
  }

  Future<http.Response> getFollowingUrl(int uid, String type) async {
    String url = 'https://onlinehunt.in/api/followers.php?api_key=$apiKey&uid=$uid&type=$type';
    print(url);
    final res = await TokenService().urlGetAuthentication(url);

    return res;
  }

  Future<List<FollowingModel>> getFollowing(int? id, String type) async {
    List response = [];
    List<FollowingModel> userArticles = [];
    try {
      await getFollowingUrl(id!, type)
          .then((value) {
            if (!value.body.contains('false')) {
              response = jsonDecode(utf8.decode(value.bodyBytes));
            } else {
              response = [];
            }
          })
          .whenComplete(() {
            response.forEach((element) {
              userArticles.add(FollowingModel.fromJson(element));
            });
          });
    } catch (e) {
      print(e.toString());
    }
    return userArticles;
  }

  Future<http.Response> createFollow(param) async {
    String url = 'https://onlinehunt.in/api/followers.php?api_key=$apiKey';
    print(url);
    final res = await TokenService().urlPostAuthentication(url, param);
    return res;
  }

  Future<http.Response> deleteFollow(param) async {
    String url = 'https://onlinehunt.in/api/followers.php?api_key=$apiKey';
    print(url);
    final res = await TokenService().urlDeleteAuthentication(url, param);
    return res;
  }

  Future<List<LikeModel>> getAllFavorite(String userId) async {
    List response = [];
    List<LikeModel> follows = [];
    try {
      String url = 'https://onlinehunt.in/api/likes.php?api_key=$apiKey&post_id=all&user_id=$userId';
      http.Response res = await TokenService().urlGetAuthentication(url);
      print(url);
      if (!res.body.contains('false')) {
        response = jsonDecode(utf8.decode(res.bodyBytes));
        response.forEach((element) {
          follows.add(LikeModel.fromJson(element));
        });
      } else {
        response = [];
      }
    } catch (e) {
      print(e.toString());
    }
    return follows;
  }

  Future<List<LikeModel>> getFavorite(String? postId, String userId) async {
    List response = [];
    List<LikeModel> follows = [];
    try {
      String url = 'https://onlinehunt.in/api/likes.php?api_key=$apiKey&post_id=$postId&user_id=$userId';
      http.Response res = await TokenService().urlGetAuthentication(url);
      print(url);
      if (!res.body.contains('false')) {
        response = jsonDecode(utf8.decode(res.bodyBytes));
        response.forEach((element) {
          follows.add(LikeModel.fromJson(element));
        });
      } else {
        response = [];
      }
    } catch (e) {
      print(e.toString());
    }
    return follows;
  }

  Future<http.Response> createFav(param) async {
    String url = 'https://onlinehunt.in/api/likes.php';
    print('creating');
    final res = await TokenService().urlPostAuthentication(url, param);
    return res;
  }

  Future<http.Response> deleteFav(param) async {
    String url = 'https://onlinehunt.in/api/likes.php';
    print('deleting');
    final res = await TokenService().urlDeleteAuthentication(url, param);
    print(res.body);
    return res;
  }
}
