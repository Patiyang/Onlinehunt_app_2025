import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:online_hunt_news/models/categoryModel.dart' as cat;
import 'package:online_hunt_news/services/category_services.dart';

import '../../helpers&Widgets/key.dart';

class CategoriesBloc extends ChangeNotifier {
  DocumentSnapshot? _lastVisible;
  DocumentSnapshot? get lastVisible => _lastVisible;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<cat.Category> _data = [];
  List<cat.Category> get data => _data;

  // List<ApiCategories> _apiCategories = [];
  // List<ApiCategories> get apiCategories => _apiCategories;
  List<DocumentSnapshot> _snap = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  CategoryServices categoryServices = CategoryServices();

  bool? _hasData;
  bool? get hasData => _hasData;

  // Future<Null> getData(mounted) async {
  //   _hasData = true;
  //   QuerySnapshot rawData;

  //   if (_lastVisible == null)
  //     rawData = await firestore.collection('categories').orderBy('timestamp', descending: false).limit(30).get();
  //   else
  //     rawData = await firestore.collection('categories').orderBy('timestamp', descending: false).startAfter([_lastVisible!['timestamp']]).limit(30).get();

  //   if (rawData.docs.length > 0) {
  //     _lastVisible = rawData.docs[rawData.docs.length - 1];
  //     if (mounted) {
  //       _isLoading = false;
  //       _snap.addAll(rawData.docs);
  //       _data = _snap.map((e) => CategoryModel.fromFirestore(e)).toList();
  //     }
  //   } else {
  //     if (_lastVisible == null) {
  //       _isLoading = false;
  //       _hasData = false;
  //       print('no items');
  //     } else {
  //       _isLoading = false;
  //       _hasData = true;
  //       print('no more items');
  //     }
  //   }

  //   notifyListeners();
  //   return null;
  // }

  Future categoriesStream(mounted) async {
    Map<String, dynamic> response = {};
    List<cat.Category> dummyList = [];
    int language = await returnCategoryId();
    // List<ApiCategories> apiCategories = [];
    try {
      await categoryServices
          .getCategories()
          .then((value) {
            response = jsonDecode(value.body);
          })
          .whenComplete(() {
            for (var element in response['data']) {
              // print(element);
              data.add(cat.Category.fromJson(element));
            }

            // response['data'].forEach((element) {
            //   print(element);
            //   dummyList.add(cat.Category.fromJson(jsonDecode(element)));
            // });
          });
      // dummyList.forEach((element) {
      //   // if (element.languageId == language) {
      //   _apiCategories.add(element);
      //   // }
      // });
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Error fetching categories: $e');
    }

    notifyListeners();
  }

  setLoading(bool isloading) {
    _isLoading = isloading;
    notifyListeners();
  }

  onRefresh(mounted) {
    _isLoading = true;
    _snap.clear();
    _data.clear();
    // _apiCategories.clear();
    _lastVisible = null;
    categoriesStream(mounted);
    // getData(mounted);
    notifyListeners();
  }
}
