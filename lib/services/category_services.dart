import 'package:http/http.dart' as http;
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'token_service.dart';

class CategoryServices {
  Future<http.Response> getCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lang_id = prefs.getInt('lang_id') ?? 1;
    String url = '${HelperClass.mainIp}categories?lang_id=$lang_id';
    print(url);
    http.Response res = await TokenService().urlGetAuthentication(url);
    // print(res.body);
    return res;
  }

  Future<http.Response> getCategoriesWithPosts(int category_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lang_id = prefs.getInt('lang_id') ?? 1;
    String url = '${HelperClass.mainIp}categories/$category_id?lang_id=$lang_id';
    print(url);
    http.Response res = await TokenService().urlGetAuthentication(url);
    // print(res.body);
    return res;
  }
}
