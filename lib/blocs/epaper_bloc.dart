import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:online_hunt_news/models/epaper_model.dart';
import 'package:online_hunt_news/services/epaper_service.dart';

class EpaperBloc extends ChangeNotifier {
  List<EpaperModel> _data = [];
  List<EpaperModel> get data => _data;

  List<EpaperModel> _PDFdata = [];
  List<EpaperModel> get PDFdata => _PDFdata;

  bool _loading = true;
  bool get loading => _loading;

  bool _loadingPDF = true;
  bool get loadingPDF => _loadingPDF;

  Future getWebData(mounted) async {
    Map<String, dynamic> response = {};
    if (mounted) {
      _loading = true;
      _data = [];
      print('GETTING web epaper News');
      await EpaperServices().getEpapers('websites').then((value) {
        response = jsonDecode(value.body);
        // print(response['data']);
        for (int i = 0; i < response['data'].length; i++) {
          _data.add(EpaperModel.fromJson(response['data'][i]));
        }
        print('length of epaper links is  ${_data.length}');
      });
      _loading = false;
    }

    notifyListeners();
  }

  Future getPDFData(mounted) async {
    Map<String, dynamic> response = {};
    if (mounted) {
      _loadingPDF = true;
      _PDFdata = [];
      print('GETTING pdfepaper News');
      await EpaperServices().getEpapers('pdfs').then((value) {
        response = jsonDecode(value.body);
        // print(response['data']);
        for (int i = 0; i < response['data'].length; i++) {
          _PDFdata.add(EpaperModel.fromJson(response['data'][i]));
        }
        print('length of PDF epaper links is  ${_PDFdata.length}');
      });
      _loadingPDF = false;
    }

    notifyListeners();
  }

  setLoading(bool isloading) {
    _loading = isloading;
    notifyListeners();
  }

  setPDFLoading(bool isloading) {
    _loadingPDF = isloading;
    notifyListeners();
  }

  onRefresh(mounted) {
    _loading = true;
    _data.clear();
    getWebData(mounted);
    notifyListeners();
  }

  onPDFRefresh(mounted) {
    _loadingPDF = true;
    _PDFdata.clear();
    getPDFData(mounted);
    notifyListeners();
  }
}
