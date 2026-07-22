import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:online_hunt_news/models/epaper_categories.dart';
import 'package:online_hunt_news/models/epaper_model.dart';
import 'package:online_hunt_news/services/epaper_service.dart';


class FeaturedEpapersBloc extends ChangeNotifier {
  List<EpaperModel> _data = [];
  List<EpaperModel> get data => _data;

  bool _loading = true;
  bool get loading => _loading;

  Future getData(mounted) async {
    Map<String, dynamic> response = {};
    if (mounted) {
      _loading = true;
      _data = [];
      print('GETTING magazine News');
      await EpaperServices().getFeatured().then((value) {
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

  onRefresh(mounted) {
    _loading = true;
    _data.clear();
    getData(mounted);
    notifyListeners();
  }
}


class MagazineCategoriesBloc extends ChangeNotifier {
  List<MagazineCategory> _data = [];
  List<MagazineCategory> get data => _data;

  bool _loading = true;
  bool get loading => _loading;

  Future getData(mounted) async {
    Map<String, dynamic> response = {};
    if (mounted) {
      _loading = true;
      _data = [];
      print('GETTING magazine News');
      await EpaperServices().getMagazineCategories().then((value) {
        response = jsonDecode(value.body);
        // print(response['data']);
        for (int i = 0; i < response['data'].length; i++) {
          _data.add(MagazineCategory.fromJson(response['data'][i]));
        }
        print('length of magazine categories is  ${_data.length}');
      });
      _loading = false;
    }

    notifyListeners();
  }

  setLoading(bool isloading) {
    _loading = isloading;
    notifyListeners();
  }

  onRefresh(mounted) {
    _loading = true;
    _data.clear();
    getData(mounted);
    notifyListeners();
  }
}