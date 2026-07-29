import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:online_hunt_news/models/epaper_model.dart';
import 'package:online_hunt_news/services/epaper_service.dart';

class SingleEpaperBloc extends ChangeNotifier {
  EpaperModel? _data;
  EpaperModel get data => _data!;

  bool _loading = true;
  bool get loading => _loading;

  Future getData(mounted, int id, int lang_id) async {
    Map<String, dynamic> response = {};
    if (mounted) {
      _loading = true;
      // _data = [];
      print('GETTING  epaper News');
      await EpaperServices().getEpaper(id, lang_id).then((value) {
        response = jsonDecode(value!.body);
        _data = response['data'];
        // print(response['data']);
        // for (int i = 0; i < response['data'].length; i++) {
        //   _data.add(EpaperModel.fromJson(response['data'][i]));
        // }
        print('title of epaper links is  ${_data!.title}');
      });
      _loading = false;
    }

    notifyListeners();
  }

  setLoading(bool isloading) {
    _loading = isloading;
    notifyListeners();
  }

  // onRefresh(mounted) {
  //   _loading = true;
  //   _data.clear();
  //   getData(mounted);
  //   notifyListeners();
  // }
}
