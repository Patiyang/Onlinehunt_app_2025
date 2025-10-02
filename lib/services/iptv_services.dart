import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';
import 'package:online_hunt_news/models/iptv_like_model.dart';
import 'package:online_hunt_news/models/iptv_model.dart';

import '../helpers&Widgets/key.dart';
import 'token_service.dart';

class IptvServices {
  Future<http.Response> getIptvLinks(String param) async {
    String url = HelperClass().getBaseUrl(param);
    print(url);
    final res = await TokenService().urlGetAuthentication(url);
    return res;
  }

  Future<http.Response> getIptv(String id) async {
    String url = 'https://onlinehunt.in/api/single_iptv.php?api_key=$apiKey&id=$id';
    print(url);
    final res = await TokenService().urlGetAuthentication(url);
    return res;
  }

  Future<IptvModel?> getSingleIptv(String id) async {
    IptvModel? iptvModel;
    List response = [];
    try {
      await getIptv(id)
          .then((value) {
            response = jsonDecode(utf8.decode(value.bodyBytes));
          })
          .whenComplete(() {
            iptvModel = IptvModel.fromJson(response.first);
          });
    } catch (e) {
      print(e.toString());
    }
    return iptvModel!;
  }

  Future<List<IptvLikeModel>> getIptvFavorite(String? postId, String userId) async {
    List response = [];
    List<IptvLikeModel> follows = [];
    try {
      String url = 'https://onlinehunt.in/api/iptv_likes.php?api_key=$apiKey&iptv_id=$postId&user_id=$userId';
      http.Response res = await TokenService().urlGetAuthentication(url);
      print(url);
      if (!res.body.contains('false')) {
        response = jsonDecode(utf8.decode(res.bodyBytes));
        response.forEach((element) {
          follows.add(IptvLikeModel.fromJson(element));
        });
      } else {
        response = [];
      }
    } catch (e) {
      print(e.toString());
    }
    return follows;
  }

  Future<http.Response> createIptvFav(param) async {
    String url = 'https://onlinehunt.in/api/iptv_likes.php';
    print('creating iptv faav');
    final res = await TokenService().urlPostAuthentication(url, param);
    print(res.body);
    return res;
  }

  Future<http.Response> deleteIptvFav(param) async {
    String url = 'https://onlinehunt.in/api/iptv_likes.php';
    print('deleting iptv faav');
    final res = await TokenService().urlDeleteAuthentication(url, param);
    print(res.body);
    return res;
  }
}
