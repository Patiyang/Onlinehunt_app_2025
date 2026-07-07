import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:online_hunt_news/models/api_live_news.dart';
import 'package:online_hunt_news/services/live_news_service.dart';

class LiveNewsBloc extends ChangeNotifier {
  List<LiveNews> _data = [];
  List<LiveNews> get data => _data;
  bool _loading = true;
  bool get loading => _loading;

  Future getApiData(mounted, BuildContext context) async {
    Map<String, dynamic> response = {};
    if (mounted) {
      _loading = true;
      _data = [];
      print('GETTING Live News');
      await LiveNewsService().getLiveNews().then((value) {
        response = jsonDecode(value.body);
        // print(response['data']);
        for (int i = 0; i < response['data'].length; i++) {
          _data.add(LiveNews.fromJson(response['data'][i]));
        }
        print('length of live  news links is  ${_data.length}');
      });
      _loading = false;
    }

    notifyListeners();
  }

  onRefresh(mounted, {BuildContext? context}) {
    _data.clear();
    getApiData(mounted, context!);
    notifyListeners();
  }
}
