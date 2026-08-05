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
  final int pdf_milliseconds;

  @HiveField(2)
  String? file_name;

  @HiveField(3)
  String? pdf_original_name;

  PDFItemModel({required this.pdf_id, required this.pdf_milliseconds, this.file_name,this.pdf_original_name});
}
