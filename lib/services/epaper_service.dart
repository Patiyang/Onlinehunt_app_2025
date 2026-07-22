import 'package:http/http.dart' as http;
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'token_service.dart';

class EpaperServices {


  Future<http.Response> getEpapers(String source_type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lang_id = prefs.getInt('lang_id') ?? 1;
    String url = '${HelperClass.mainIp}newspapers/$source_type?lang_id=$lang_id';
    print(url);
    final res = await http.get(Uri.parse(url));
    return res;
  }
  Future<http.Response> getAllEpapers({int limit =10}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lang_id = prefs.getInt('lang_id') ?? 1;
    String url = '${HelperClass.mainIp}newspapers?lang_id=$lang_id&limit=$limit';
    print(url);
    final res = await http.get(Uri.parse(url));
    return res;
  }
  Future<http.Response> getMagazines({int? category_id, int limit=10}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lang_id = prefs.getInt('lang_id') ?? 1;
    String url = '${HelperClass.mainIp}magazines?lang_id=$lang_id&category_id=$category_id&limit=$limit';
    print(url);
    final res = await http.get(Uri.parse(url));
    return res;
  }

  //http://onlinehunt.in.local/api/periodicals?frequency=weekly&lang_id=2
  Future<http.Response> getPeriodicals(String period,{int limit =10}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lang_id = prefs.getInt('lang_id') ?? 1;
    String url = '${HelperClass.mainIp}periodicals?frequency=$period&lang_id=$lang_id&limit=$limit';
    print(url);
    final res = await http.get(Uri.parse(url));
    return res;
  }

  Future<http.Response> getFeatured() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lang_id = prefs.getInt('lang_id') ?? 1;
    String url = '${HelperClass.mainIp}epapers/featured?lang_id=$lang_id';
    print('epapers url is: ' + url);
    final res = await http.get(Uri.parse(url));
    return res;
  }

  Future<http.Response> getMagazineCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lang_id = prefs.getInt('lang_id') ?? 1;
    String url = '${HelperClass.mainIp}magazine-categories?lang_id=$lang_id';
    print('epapers url is: ' + url);
    final res = await http.get(Uri.parse(url));
    return res;
  }
}
