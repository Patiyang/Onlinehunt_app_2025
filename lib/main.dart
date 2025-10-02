
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'models/admob_helper.dart';
import 'models/theme_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AdmobHelper.initialize();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark));
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String getLanguages() {
    if (prefs.getString('language') == 'English') {
      ThemeModel().myValue = 'Manrope';
      return 'en';
    } else if (prefs.getString('language') == 'Kannada') {
      ThemeModel().myValue = 'NotoSerif';
      return 'kn';
    } else if (prefs.getString('language') == 'Hindi') {
      ThemeModel().myValue = 'Karma';
      return 'hi';
    } else {
      return 'en';
    }
  }

  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en'),
        Locale('kn'),
        Locale('hi'),
      ],
      path: 'assets/translations',
      fallbackLocale: Locale(getLanguages()),
      startLocale: Locale(getLanguages()),
      useOnlyLangCode: true,
      child: MyApp(),
    ),
  );
}
