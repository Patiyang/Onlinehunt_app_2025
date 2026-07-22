import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:online_hunt_news/models/epaper_model.dart';
import 'package:online_hunt_news/services/epaper_service.dart';

class DailyPeriodicalBloc extends ChangeNotifier {
  List<EpaperModel> _data = [];
  List<EpaperModel> get data => _data;

  bool _loading = true;
  bool get loading => _loading;

  Future getData(mounted, {int ?limit}) async {
    Map<String, dynamic> response = {};
    if (mounted) {
      _loading = true;
      _data = [];
      print('GETTING magazine News');
      await EpaperServices().getAllEpapers(limit: limit=5).then((value) {
        response = jsonDecode(value.body);
        // print(response['data']);
        for (int i = 0; i < response['data'].length; i++) {
          _data.add(EpaperModel.fromJson(response['data'][i]));
        }
        print('length of all papers links is  ${_data.length}');
      });
      _loading = false;
    }

    notifyListeners();
  }

  setLoading(bool isloading) {
    _loading = isloading;
    notifyListeners();
  }

  onRefresh(mounted, {int ?limit}) {
    _loading = true;
    _data.clear();
    getData(mounted,limit: limit);
    notifyListeners();
  }
}


class WeeklyPeriodicalBloc extends ChangeNotifier {
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
      await EpaperServices().getPeriodicals('weekly',limit: limit=5).then((value) {
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

class FortnightlyPeriodicalBloc extends ChangeNotifier {
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
      await EpaperServices().getPeriodicals('fortnightly',limit: limit=5).then((value) {
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

class MonthlyPeriodicalBloc extends ChangeNotifier {
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
      await EpaperServices().getPeriodicals('monthly',limit: limit=5).then((value) {
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