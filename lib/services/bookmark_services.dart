import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:online_hunt_news/blocs/sign_in_bloc.dart';
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';
import 'package:provider/provider.dart';
import 'token_service.dart';

class BookmarkServices {
  Future<bool> bookmarkStatus(int post_id, BuildContext context) async {
    Map<String, dynamic> mapRes = {};
    final sb = context.read<SignInBloc>();
    String url = '${HelperClass.mainIp}reading-list/status?post_id=$post_id&user_id=${int.parse(sb.uid!)}';
    print(url);
    final res = await http.get(Uri.parse(url));
    mapRes = jsonDecode(res.body);
    return mapRes['saved'];
  }

  Future<http.Response> getUserBookmarks( int user_id) async {
    // final sb = context.read<SignInBloc>();
    String url = '${HelperClass.mainIp}reading-list?user_id=$user_id';
    print(url);
    final res = await TokenService().urlGetAuthentication(url);
    return res;
  }

  Future<bool> addToBookmarks(int post_id, BuildContext context) async {
    Map<String, dynamic> mapRes = {};
    final sb = context.read<SignInBloc>();
    String url = '${HelperClass.mainIp}reading-list';
    print(url);
    bool status = false;
    try {
      http.Response res = await TokenService().urlPostAuthentication(url, {'post_id': post_id, 'user_id': '${int.parse(sb.uid!)}'});
      mapRes = jsonDecode(res.body);

      if (res.statusCode == 200) {
        // apiUserModel = UserModel.fromJson(mapRes['user']);
        status = mapRes['success'];
        Fluttertoast.showToast(msg: '${'bookmark_added'.tr()} ');
      } else {
        print('mapRes is $mapRes');
        Fluttertoast.showToast(msg: '${'failed_bookmark'.tr()} ');
      }
    } catch (e) {
      print(e.toString());
    }
    return status;
  }

  Future<bool> removeBookmark(int post_id, BuildContext context) async {
    Map<String, dynamic> mapRes = {};
    final sb = context.read<SignInBloc>();
    String url = '${HelperClass.mainIp}reading-list/remove';
    print(url);
    bool status = false;
    try {
      http.Response res = await TokenService().urlPostAuthentication(url, {'post_id': post_id, 'user_id': '${int.parse(sb.uid!)}'});
      mapRes = jsonDecode(res.body);

      if (res.statusCode == 200) {
        // apiUserModel = UserModel.fromJson(mapRes['user']);
        status = mapRes['success'];
        Fluttertoast.showToast(msg: '${'bookmark_removed'.tr()} ');
      } else {
        print('mapRes is $mapRes');
        status = mapRes['success'];
        Fluttertoast.showToast(msg: '${'failed_bookmark_removed'.tr()} ');
      }
    } catch (e) {
      print(e.toString());
    }
    return status;
  }
}
