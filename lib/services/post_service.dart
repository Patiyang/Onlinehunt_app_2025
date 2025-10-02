import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'token_service.dart';

class PostServices {
  Future<http.Response> getPostsSelection(String param, {int page = 1}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lang_id = prefs.getInt('lang_id') ?? 1;
    String url = '${HelperClass.mainIp}posts/selection/$param?exclude=keywords&lang_id=$lang_id';
    // print(url);
    http.Response res = await TokenService().urlGetAuthentication(url);

    // print(res.data);
    return res;
  }

  Future<http.Response> getAllPosts(String param, {String exclude = ''}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lang_id = prefs.getInt('lang_id') ?? 1;
    String url = '${HelperClass.mainIp}posts?exclude=${'keywords,$exclude'}&limit=10&lang_id=$lang_id';
    print(url);
    final res = await TokenService().urlGetAuthentication(url);
    return res;
  }

  Future<http.Response> getRelatedPosts(int post_id, {String exclude = ''}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lang_id = prefs.getInt('lang_id') ?? 1;
    String url = '${HelperClass.mainIp}posts/$post_id/similar?limit=5&offset=0&exclude=content,keywords';
    print(url);
    final res = await TokenService().urlGetAuthentication(url);
    return res;
  }

  Future<http.Response> getPost(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lang_id = prefs.getInt('lang_id') ?? 1;

    String url = '${HelperClass.mainIp}posts/$id?exclude=keywords&lang_id=$lang_id';
    print(url);
    final res = await TokenService().urlGetAuthentication(url);
    return res;
  }

  Future<http.Response> createPosts(String param, body) async {
    String url = HelperClass().getBaseUrl(param);
    final res = await TokenService().urlPostAuthentication(url, body);
    return res;
  }

  Future uploadDoc(File file) async {
    // String token = await SharedPrefs().getTokenString();
    // List<int> imagebytes = file.readAsBytesSync();
    // String imageStr = "data:image/jpg;base64,${base64Encode(imagebytes)}";
    // print(await file.readAsBytes());
    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: basename(file.path)),
        // "name": basename(file.path),
        // 'api_key': '53b7a9e4-2489-4314240c0889-fa93-433d'
      });
      String url = "${HelperClass.baseUrl}upload_file.php";
      var response = await dio
          .post(
            url,
            data: formData,
            options: Options(
              headers: {
                'Accept': 'application/json',
                // 'Authorization': 'Bearer $token',
              },
            ),
          )
          .catchError((onError) {
            print(onError);
          });
      // print('status message is ${response.statusCode}');

      return response;
    } catch (e) {
      print("error$e");
    }
  }

  Future<http.Response> updatePosts(String param, body) async {
    String url = HelperClass().getBaseUrl(param);
    final res = await TokenService().urlPutAuthentication(url, body);
    return res;
  }
}
