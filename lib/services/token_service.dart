import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:dio/dio.dart'

class TokenService {
  urlGetAuthentication(String url) async {
    final result = await http.get(Uri.parse(url), headers: {"Accept": "application/json; charset=UTF-8"}).catchError((e){
      print("Error in urlGetAuthentication: $e");
      return http.Response('{"error": "Failed to fetch data"}', 500);
    });
    return result;
  }

  urlPutAuthentication(String url, body) async {
    final result = await http.put(
      Uri.parse(url),
      headers: {
        "Accept": "application/json; charset=UTF-8",
      },
      body: jsonEncode(body),
    );
    return result;
  }

  urlPostAuthentication(String url, body) async {
    final result = await http.post(
      Uri.parse(url),
      headers: {
        "Accept": "application/json;  charset=UTF-8",
      },
      body: jsonEncode(body),
    );
    return result;
  }

  urlDeleteAuthentication(String url, body) async {
    final result = await http.delete(
      Uri.parse(url),
      headers: {"Accept": "application/json; charset=UTF-8"},
      body: jsonEncode(body)
    );
    return result;
  }
}
