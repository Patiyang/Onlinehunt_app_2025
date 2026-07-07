import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:online_hunt_news/helpers&Widgets/key.dart';

class HelperClass {
  static const baseUrl = "https://onlinehunt.in/api/";
  static const fileUpload = "https://onlinehunt.in/api/uploads/videos/";
  static const publicMainIpAddress = 'https://onlinehunt.in/';
  static const publicTestIpAddress = 'http://192.168.0.104/';

  static const String testipAddress = 'http://${kIsWeb ? '127.0.0.1' : '192.168.0.104'}/api/';
  static const serverpAddress = 'https://onlinehunt.in/api/';
  static const mainIp = serverpAddress;
  static const avatarIp = publicMainIpAddress;
  static const liveshareIp = 'https://onlinehunt.in/p/';
  static const testshareIp = 'http://192.168.0.104/p/';

  static const shareIp = liveshareIp;

  static const tokenKey = 'token';
  String getBaseUrl(String param, {int currentPage = 1, count = 6, String type = 'all', String categoryid = 'all', String id = ''}) {
    return 'https://onlinehunt.in/api/$param.php?api_key=$apiKey&currentpage=$currentPage&count=$count&type=$type&categoryid=$categoryid&id=$id';
  }

  String getCommentsBaseUrl({int currentPage = 1, count = 10, required String postid}) {
    return 'https://onlinehunt.in/api/comments.php?api_key=$apiKey&currentpage=$currentPage&count=$count&postid=$postid';
  }

  String getCommentsDeleteUrl({required String postid}) {
    return 'https://onlinehunt.in/api/comments.php?api_key=$apiKey&id=$postid';
  }

  getDate(DateTime? date, {bool? altDate}) {
    String _d = altDate == true ? DateFormat('dd MMM yyyy').format(date!) : DateFormat('dd/MM/yyyy').format(date!);
    return _d;
  }

  getCategoryColor(String color) {
   return Color(int.parse(color.replaceFirst('#', '0xFF')));
  }
}
