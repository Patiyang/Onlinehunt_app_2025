import 'package:http/http.dart' as http;
import 'package:online_hunt_news/helpers&Widgets/key.dart';

import 'token_service.dart';

class PageViewServices {
  String baseUrl = 'https://onlinehunt.in/api/post_pageviews_month.php?api_key=$apiKey';
  Future<http.Response> getPageViews(String postId, {String type = 'all', String categoryid = 'all', int currentPage = 1, count = 6, String id = ''}) async {
    String url = 'https://onlinehunt.in/api/post_pageviews_month.php?api_key=$apiKey&post_id=$postId';
    print(url);
    final res = await TokenService().urlGetAuthentication(url);
    return res;
  }

  Future<http.Response> createPageView(body) async {
    // String url = HelperClass().getBaseUrl(param);
    print(baseUrl);
    final res = await TokenService().urlPostAuthentication(baseUrl, body);
    return res;
  }
}
