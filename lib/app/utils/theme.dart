import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
abstract class AppTheme {
  static const int _mainColorValue = 0xFF32B1FF;

  static const MaterialColor mainColor = MaterialColor(
    _mainColorValue,
    {
      50: Color(0xff8ed4ff),
      100: Color(0xff84d0ff),
      200: Color(0xff70c8ff),
      300: Color(0xff5bc1ff),
      400: Color(0xff46b9ff),
      500: Color(_mainColorValue),
      600: Color(0xff2d9fe5),
      700: Color(0xff288ecc),
      800: Color(0xff237cb2),
      900: Color(0xff1e6a99),
    },
  );

  static ThemeData light = ThemeData(
    primarySwatch: mainColor,
    primaryColor: mainColor,
    accentColor: mainColor,
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: mainColor,
    primaryColor: mainColor,
    accentColor: mainColor,
  );
}
