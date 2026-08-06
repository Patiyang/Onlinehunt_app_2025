import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:hive/hive.dart';

part 'pdf_timer.g.dart';

@HiveType(typeId: 0)
class PDFItemModel extends HiveObject {
  @HiveField(0)
  final int pdf_id;

  @HiveField(1)
   int pdf_milliseconds;

  @HiveField(2)
  String? file_name;

  @HiveField(3)
  String? thumbnail_name;

  @HiveField(4)
   String? title;

  @HiveField(5)
   String? publication;

  @HiveField(6)
   String? issue_date;

  @HiveField(7)
   String? cover_image;

  @HiveField(8)
   String? pdf_url;

  PDFItemModel({
    required this.pdf_id,
    required this.pdf_milliseconds,
    required this.title,
    required this.publication,
    required this.issue_date,
    required this.cover_image,
    required this.pdf_url,
    this.file_name,
    this.thumbnail_name,
  });
}
