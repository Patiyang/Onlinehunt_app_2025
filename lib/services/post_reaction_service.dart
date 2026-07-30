import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:online_hunt_news/blocs/sign_in_bloc.dart';
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';
import 'package:online_hunt_news/services/token_service.dart';
import 'package:provider/provider.dart';

class PostReactionService {
  Future<String?> postReactionValue(int post_id, BuildContext context) async {
    Map<String, dynamic> mapRes = {};
    final sb = context.read<SignInBloc>();
    String url = '${HelperClass.mainIp}reactions/user?post_id=$post_id&user_id=${int.parse(sb.uid!)}';
    print(url);
    final res = await http.get(Uri.parse(url));
    mapRes = jsonDecode(res.body);
    return mapRes['reaction'];
  }

  Future<bool> createReaction(int post_id, String reaction, BuildContext context) async {
    Map<String, dynamic> mapRes = {};
    final sb = context.read<SignInBloc>();
    String url = '${HelperClass.mainIp}reactions';
    print(url);
    bool success = false;
    try {
      http.Response res = await TokenService().urlPostAuthentication(url, {'post_id': post_id, 'reaction': reaction, 'user_id': '${int.parse(sb.uid!)}'});
      mapRes = jsonDecode(res.body);

      if (res.statusCode == 200) {
        // apiUserModel = UserModel.fromJson(mapRes['user']);
        success = mapRes['success'];
        // Fluttertoast.showToast(msg: '${'now_following'.tr()} $reaction');
      } else {
        print('mapRes is $mapRes');
        // Fluttertoast.showToast(msg: '${'follow_failed'.tr()} $reaction');
      }
    } catch (e) {
      print(e.toString());
    }
    return success;
  }

  Future<bool> removeReaction(int post_id, BuildContext context) async {
    Map<String, dynamic> mapRes = {};
    final sb = context.read<SignInBloc>();
    String url = '${HelperClass.mainIp}reactions/remove';
    print(url);
    bool success = false;
    try {
      http.Response res = await TokenService().urlPostAuthentication(url, {'post_id': post_id, 'user_id': '${int.parse(sb.uid!)}'});
      mapRes = jsonDecode(res.body);

      if (res.statusCode == 200) {
        // apiUserModel = UserModel.fromJson(mapRes['user']);
        success = mapRes['success'];
        // Fluttertoast.showToast(msg: '${'now_following'.tr()} $post_id');
      } else {
        print('mapRes is $mapRes');
        // Fluttertoast.showToast(msg: '${'follow_failed'.tr()} $post_id');
      }
    } catch (e) {
      print(e.toString());
    }
    return success;
  }
}
