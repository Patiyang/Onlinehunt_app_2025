import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:hive/hive.dart';

part 'pdf_timer.g.dart';



@HiveType(typeId: 0)
class PDFItemModel extends HiveObject {
  @HiveField(0)
  final int  pdf_id;
  @HiveField(1)
  final int pdf_milliseconds;
  // @HiveField(2)
  // final String name;
  // @HiveField(3)
  // final String caption;
  // @HiveField(4)
  // final String file_name;
  // @HiveField(5)
  // final String ig_link;
  // @HiveField(6)
  // final String file_type;
  // @HiveField(7)
  // final String link_id;
  // @HiveField(8)
  // final DateTime createdAt;
  // @HiveField(9)
  // final String profile_picture_url;
  // @HiveField(10)
  // final String download_url;

  PDFItemModel({
    required this.pdf_id,
    required this.pdf_milliseconds,
    // required this.name,
    // required this.caption,
    // required this.file_name,
    // required this.ig_link,
    // required this.file_type,
    // required this.link_id,
    // required this.profile_picture_url,
    // required this.createdAt,
    // required this.download_url
  });
}
