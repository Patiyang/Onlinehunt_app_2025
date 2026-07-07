
import 'package:http/http.dart' as http;
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LiveNewsService {

Future<http.Response> getLiveNews() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lang_id = prefs.getInt('lang_id') ?? 1;
    String url = '${HelperClass.mainIp}live-news?lang_id=$lang_id';
    print(url);
    final res = await http.get(Uri.parse(url));
    return res;
  }
}
