import 'package:http/http.dart' as http;
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';

import 'token_service.dart';

class CommentServices {
  Future<http.Response> getComments(String postId, int currentPage) async {
    String url = HelperClass().getCommentsBaseUrl(postid: postId, currentPage: currentPage);
    final res = await TokenService().urlGetAuthentication(url);
    return res;
  }

  Future<http.Response> createComment(String param, body) async {
    String url = HelperClass().getBaseUrl(param);
    final res = await TokenService().urlPostAuthentication(url, body);
    return res;
  }

  Future<http.Response> deleteComment(String id, {param}) async {
    String url = HelperClass().getCommentsDeleteUrl(postid: id);
    final res = await TokenService().urlDeleteAuthentication(url, param);
    return res;
  }
}
