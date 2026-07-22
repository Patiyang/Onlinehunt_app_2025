import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:online_hunt_news/models/epaper_model.dart';
import 'package:online_hunt_news/services/epaper_service.dart';

class MagazineBloc extends ChangeNotifier {
  List<EpaperModel> _data = [];
  List<EpaperModel> get data => _data;

  bool _loading = true;
  bool get loading => _loading;

  Future getData(mounted,{int ?limit}) async {
    Map<String, dynamic> response = {};
    if (mounted) {
      _loading = true;
      _data = [];
      print('GETTING magazine News');
      await EpaperServices().getMagazines(limit: limit!).then((value) {
        response = jsonDecode(value.body);
        // print(response['data']);
        for (int i = 0; i < response['data'].length; i++) {
          _data.add(EpaperModel.fromJson(response['data'][i]));
        }
        print('length of magazine links is  ${_data.length}');
      });
      _loading = false;
    }

    notifyListeners();
  }

  setLoading(bool isloading) {
    _loading = isloading;
    notifyListeners();
  }

  onRefresh(mounted,{int ?limit}) {
    _loading = true;
    _data.clear();
    getData(mounted,limit: limit);
    notifyListeners();
  }
}


class FavoriteMagazineBloc extends ChangeNotifier {
  List<EpaperModel> _data = [];
  List<EpaperModel> get data => _data;

  bool _loading = true;
  bool get loading => _loading;

  Future getData(mounted, int category_id, {int ?limit}) async {
    Map<String, dynamic> response = {};
    if (mounted) {
      _loading = true;
      _data = [];
      print('GETTING magazine News');
      await EpaperServices().getMagazines(category_id: category_id,limit: limit=5).then((value) {
        response = jsonDecode(value.body);
        // print(response['data']);
        for (int i = 0; i < response['data'].length; i++) {
          _data.add(EpaperModel.fromJson(response['data'][i]));
        }
        print('length of magazine links is  ${_data.length}');
      });
      _loading = false;
    }

    notifyListeners();
  }

  setLoading(bool isloading) {
    _loading = isloading;
    notifyListeners();
  }

  onRefresh(mounted,int category_id, {int ?limit}) {
    _loading = true;
    _data.clear();
    getData(mounted,category_id,limit: limit);
    notifyListeners();
  }
}


