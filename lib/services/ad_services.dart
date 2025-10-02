import 'dart:convert';

import 'package:online_hunt_news/helpers&Widgets/key.dart';
import 'package:online_hunt_news/services/token_service.dart';
import 'package:http/http.dart' as http;

import '../helpers&Widgets/helper_class.dart';
import '../models/mobile_ads_model.dart';

class AdServices {
  Future getAdsUrl(String categoryId, String currentPage, String adspace) async {
    String url = 'https://onlinehunt.in/api/mobile_ad_spaces.php?api_key=$apiKey&categoryid=$categoryId&currentpage=$currentPage&adspace=$adspace';
    final res = await TokenService().urlGetAuthentication(url);
    print(url);

    return res;
  }

  Future<List<MobileAdsaModel>> getMobileAds(String currentPage, {String adspace = '', String categoryId = ''}) async {
    List<MobileAdsaModel> adsModel = [];
    http.Response? res;
    try {
      await getAdsUrl(categoryId, currentPage, adspace).then((value) {
        res = value;
        Map body = jsonDecode(res!.body);
        print(body['status']);
        if (body['status'] == true) {
          // for (int i = 0; i <= body['data'].length; i++) {
          //   adsModel.add(MobileAdsaModel.fromJson(body['data'][i]));
          // }
          adsModel.add(MobileAdsaModel.fromJson(body['data'][0]));
          // print(adsModel);
        } else {
          adsModel = [];
        }
      });
    } catch (e) {
      print(e.toString());
    }
    return adsModel;
  }

  Future<http.Response> updateViews(String viewCount, String id) async {
    var body = {"api_key": apiKey, "id": id, "ad_views": viewCount};
    String url = HelperClass().getBaseUrl('mobile_ad_spaces');
    final res = await TokenService().urlPutAuthentication(url, body);
    return res;
  }
}
