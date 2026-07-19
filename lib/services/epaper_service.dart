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
}
