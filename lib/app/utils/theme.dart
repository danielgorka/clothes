import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  static final ThemeData light = _theme(false);

  static final ThemeData dark = _theme(true);

  static ThemeData _theme(bool isDark) {
    final brightness = isDark ? Brightness.dark : Brightness.light;
    return ThemeData(
      brightness: brightness,
      primarySwatch: mainColor,
      primaryColor: mainColor,
      accentColor: mainColor,
      canvasColor: isDark ? null : Colors.white,
      appBarTheme: AppBarTheme(
        elevation: 1,
        brightness: brightness,
        color: isDark ? Colors.grey[800] : Colors.white,
      ),
      floatingActionButtonTheme: _floatingActionButtonTheme(isDark),
      elevatedButtonTheme: _elevatedButtonTheme(isDark),
      textButtonTheme: _textButtonTheme(isDark),
    );
  }

  static FloatingActionButtonThemeData _floatingActionButtonTheme(bool isDark) {
    return FloatingActionButtonThemeData(
      backgroundColor: isDark ? Colors.grey[900]! : Colors.white,
      foregroundColor: mainColor,
      elevation: 0.0,
      focusElevation: 0.0,
      hoverElevation: 0.0,
      disabledElevation: 0.0,
      highlightElevation: 0.0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isDark ? Colors.transparent : Colors.grey[300]!,
          //width: 0.5,
        ),
        borderRadius: BorderRadius.circular(32.0),
      ),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(bool isDark) {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        ),
        textStyle: MaterialStateProperty.all(
          const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
            letterSpacing: 0.5,
          ),
        ),
        foregroundColor: MaterialStateProperty.all(
          isDark ? Colors.black : Colors.white,
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme(bool isDark) {
    return TextButtonThemeData(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        ),
        textStyle: MaterialStateProperty.all(
          const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
            letterSpacing: 0.5,
          ),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
      ),
    );
  }

  static const SystemUiOverlayStyle overlayLight = SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
  );

  static final SystemUiOverlayStyle overlayDark = SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.grey[850],
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
  );
}
