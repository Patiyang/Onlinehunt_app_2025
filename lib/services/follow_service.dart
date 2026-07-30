import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:online_hunt_news/blocs/sign_in_bloc.dart';
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';
import 'package:provider/provider.dart';
import 'token_service.dart';

class FollowService {
  Future<bool> followStatus(int following_id, BuildContext context) async {
    Map<String, dynamic> mapRes = {};
    final sb = context.read<SignInBloc>();
    String url = '${HelperClass.mainIp}follow/status?following_id=$following_id&follower_id=${int.parse(sb.uid!)}';
    print(url);
    final res = await http.get(Uri.parse(url));
    mapRes = jsonDecode(res.body);
    return mapRes['is_following'];
  }

  Future<bool> followUser(int following_id,String name, BuildContext context) async {
    Map<String, dynamic> mapRes = {};
    final sb = context.read<SignInBloc>();
    String url = '${HelperClass.mainIp}follow';
    print(url);
    bool status = false;
    try {
      http.Response res = await TokenService().urlPostAuthentication(url, {'following_id': following_id, 'follower_id': '${int.parse(sb.uid!)}'});
      mapRes = jsonDecode(res.body);

      if (res.statusCode == 200) {
        // apiUserModel = UserModel.fromJson(mapRes['user']);
        status = mapRes['success'];
        Fluttertoast.showToast(msg: '${'now_following'.tr()} $name');
      } else {
        print('mapRes is $mapRes');
        Fluttertoast.showToast(msg: '${'follow_failed'.tr()} $name');
      }
    } catch (e) {
      print(e.toString());
    }
    return status;
  }


  Future<bool> unfollowUser(int following_id,String name, BuildContext context) async {
    Map<String, dynamic> mapRes = {};
    final sb = context.read<SignInBloc>();
    String url = '${HelperClass.mainIp}unfollow';
    print(url);
    bool status = false;
    try {
      http.Response res = await TokenService().urlPostAuthentication(url, {'following_id': following_id, 'follower_id': '${int.parse(sb.uid!)}'});
      mapRes = jsonDecode(res.body);

      if (res.statusCode == 200) {
        // apiUserModel = UserModel.fromJson(mapRes['user']);
        status = mapRes['success'];
        Fluttertoast.showToast(msg: '${'unfollowed'.tr()} $name');
      } else {
        print('mapRes is $mapRes');
        Fluttertoast.showToast(msg: '${'unfollow_failed'.tr()} $name');
      }
    } catch (e) {
      print(e.toString());
    }
    return status;
  }
}
