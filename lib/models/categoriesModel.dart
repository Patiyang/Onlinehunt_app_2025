import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesModel {
  static const CATEGORYNAME = 'name';
  static const HINDICATEGORYNAME = 'hindi';
  static const KARNATAKACATEGORYNAME = 'karnataka';
  static const CATEGORYIMAGE = 'thumbnail';
  static const CATEGORYTIME = 'timestamp';
  static const CATEGORYVISIBILITY = 'visible';

  final String? categoyName;
  final String? hindiCategoryName;
  final String? karnatakaCategoryName;
  final String? categoryImage;
  final String? timestamp;
  final bool? visibility;
  CategoriesModel({
    this.categoyName,
    this.hindiCategoryName,
    this.karnatakaCategoryName,
    this.categoryImage,
    this.timestamp,
    this.visibility,
  });

  factory CategoriesModel.fromFireStore(DocumentSnapshot snap) {
    Map c = snap.data() as Map<dynamic, dynamic>;
    return CategoriesModel(
      categoyName: c[CATEGORYNAME],
      hindiCategoryName: c[HINDICATEGORYNAME],
      karnatakaCategoryName: c[KARNATAKACATEGORYNAME]??c[CATEGORYNAME],
      categoryImage: c[CATEGORYIMAGE]??c[CATEGORYNAME],
      timestamp: c[CATEGORYTIME],
      visibility: c[CATEGORYVISIBILITY] ?? false,
    );
  }
}
