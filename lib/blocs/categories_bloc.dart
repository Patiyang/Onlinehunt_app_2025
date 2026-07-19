import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:online_hunt_news/models/categoryModel.dart' as cat;
import 'package:online_hunt_news/services/category_services.dart';

// import '../../helpers&Widgets/key.dart';

class CategoriesBloc extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<cat.Category> _data = [];
  List<cat.Category> get data => _data;

  CategoryServices categoryServices = CategoryServices();

  bool? _hasData;
  bool? get hasData => _hasData;

  Future categoriesStream(mounted) async {
    Map<String, dynamic> response = {};

    data.clear();
    try {
      await categoryServices
          .getCategories()
          .then((value) {
            response = jsonDecode(value.body);
          })
          .whenComplete(() {
            for (var element in response['data']) {
              print(element);
              data.add(cat.Category.fromJson(element));
            }
          });

      _isLoading = false;
      notifyListeners();
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
    _data.clear();
    categoriesStream(mounted);
    notifyListeners();
  }
}
