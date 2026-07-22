import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_hunt_news/config/config.dart';

class ThemeModel {
  static String? _fontFamily = 'Manrope';
  String? get fontFamily => _fontFamily;

  set myValue(String value) {
    _fontFamily = value;
  }

  final lightMode = ThemeData(
    primaryColor: Config().appColor,
    primarySwatch: getMaterialColorFromColor(Config().appColor),
    colorScheme: ColorScheme.light(surface: Colors.white),

    // colorSchemeSeed: Colors.blue, // Generates a cohesive blue color scheme
    useMaterial3: true,
    iconTheme: IconThemeData(color: Colors.grey[900]),
    fontFamily: _fontFamily,
    scaffoldBackgroundColor: Colors.grey[100],
    brightness: Brightness.light,
    primaryColorDark: Colors.grey[800],
    primaryColorLight: Colors.white,
    secondaryHeaderColor: Colors.grey[600],

    shadowColor: Colors.grey[300],
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.grey[900]),
      actionsIconTheme: IconThemeData(color: Colors.grey[900]),
      titleTextStyle: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.6,
        wordSpacing: 1,
        color: Colors.grey[900],
      ),
    ),
    textTheme: TextTheme(
      titleMedium: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.grey[900]),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Config().appColor,
      unselectedItemColor: Colors.grey[400],
    ),
  );

  final darkMode = ThemeData(
    primaryColor: Config().appColor,
    primarySwatch: getMaterialColorFromColor(Config().appColor),
    colorScheme: ColorScheme.dark(surface: Colors.grey[900]!),
    // colorSchemeSeed: Colors.blue, // Generates a cohesive blue color scheme
    useMaterial3: true,
    iconTheme: IconThemeData(color: Colors.white),
    fontFamily: _fontFamily,
    scaffoldBackgroundColor: Color(0xff303030),
    brightness: Brightness.dark,
    primaryColorDark: Colors.grey[300],
    primaryColorLight: Colors.grey[800],
    secondaryHeaderColor: Colors.grey[400],
    shadowColor: Color(0xff282828),
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: Colors.grey[900],
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(fontFamily: _fontFamily, fontSize: 18, letterSpacing: -0.6, wordSpacing: 1, fontWeight: FontWeight.w700, color: Colors.white),
    ),
    textTheme: TextTheme(
      titleMedium: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.grey[900],
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey[500],
    ),
  );

  static Color getShade(Color color, {bool darker = false, double value = .1}) {
    assert(value >= 0 && value <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((darker ? (hsl.lightness - value) : (hsl.lightness + value)).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static MaterialColor getMaterialColorFromColor(Color color) {
    Map<int, Color> _colorShades = {
      50: getShade(color, value: 0.5),
      100: getShade(color, value: 0.4),
      200: getShade(color, value: 0.3),
      300: getShade(color, value: 0.2),
      400: getShade(color, value: 0.1),
      500: color,
      600: getShade(color, value: 0.1, darker: true),
      700: getShade(color, value: 0.15, darker: true),
      800: getShade(color, value: 0.2, darker: true),
      900: getShade(color, value: 0.25, darker: true),
    };
    return MaterialColor(color.value, _colorShades);
  }
}
