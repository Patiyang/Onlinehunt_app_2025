import 'dart:convert';

import 'package:online_hunt_news/models/general_settings_model.dart';

import 'package:http/http.dart' as http;
import 'package:online_hunt_news/services/token_service.dart';

import '../helpers&Widgets/key.dart';

class GeneralSettingsServices {
  Future<List<GeneralSettingsModel>> getGeneralSettings() async {
    List response = [];
    List<GeneralSettingsModel> generalSettings = [];
    try {
      String url = 'https://onlinehunt.in/api/general_settings.php?api_key=$apiKey';
      http.Response res = await TokenService().urlGetAuthentication(url);
      print(url);
      if (!res.body.contains('false')) {
        response = jsonDecode(utf8.decode(res.bodyBytes));
        response.forEach((element) {
          generalSettings.add(GeneralSettingsModel.fromJson(element));
        });
      } else {
        response = [];
      }
    } catch (e) {
      print(e.toString());
    }
    return generalSettings;
  }

  Future<SettingsModel> getSettings() async {
    List response = [];
    SettingsModel? settingsModel;
    try {
      String url = 'https://onlinehunt.in/api/settings.php?api_key=$apiKey';
      http.Response res = await TokenService().urlGetAuthentication(url);
      print(url);
      if (!res.body.contains('false')) {
        response = jsonDecode(utf8.decode(res.bodyBytes));
        // settingsModel = response.where((element) =>element. false).first;
        settingsModel = SettingsModel.fromJson(response[1]);
        // response.forEach((element) {
        //   generalSettings.add(SettingsModel.fromJson(element));
        // });
      } else {
        response = [];
      }
    } catch (e) {
      print(e.toString());
    }
    return settingsModel!;
  }
}
