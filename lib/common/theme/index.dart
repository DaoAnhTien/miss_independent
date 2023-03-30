import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

class ThemeApp {
  static String get fontFamily => 'Lato';
  static TextStyle get baseTextStyle =>
      TextStyle(fontSize: 16, fontFamily: fontFamily);

  static ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: kPrimaryColor,
    hintColor: const Color(0xFFC5C5C5),
    cardColor: Colors.white,
    textTheme: ThemeData.light().textTheme.copyWith(
          labelSmall: baseTextStyle.copyWith(fontSize: 13, color: Colors.black),
          labelMedium:
              baseTextStyle.copyWith(fontSize: 15, color: Colors.black),
          labelLarge: baseTextStyle.copyWith(fontSize: 17, color: Colors.black),
          displaySmall: baseTextStyle.copyWith(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: baseTextStyle.copyWith(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          displayLarge: baseTextStyle.copyWith(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          bodySmall: baseTextStyle.copyWith(fontSize: 12, color: Colors.black),
          bodyMedium: baseTextStyle.copyWith(fontSize: 14, color: Colors.black),
          bodyLarge: baseTextStyle.copyWith(fontSize: 16, color: Colors.black),
        ),
    appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        centerTitle: true,
        backgroundColor: kPrimaryColor),
    colorScheme: const ColorScheme.light()
        .copyWith(background: const Color(0xFFFFFFFF), primary: kPrimaryColor)
        .copyWith(error: const Color(0xFFe74c3c)),
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: kPrimaryColor,
    hintColor: const Color(0xFFC5C5C5),
    cardColor: Colors.black,
    errorColor: const Color(0xFFe74c3c),
    textTheme: ThemeData.dark().textTheme.copyWith(
          headline1: baseTextStyle.copyWith(
              fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
          headline2: baseTextStyle.copyWith(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          headline3: baseTextStyle.copyWith(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          headline4: baseTextStyle.copyWith(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          headline5: baseTextStyle.copyWith(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          headline6: baseTextStyle.copyWith(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          caption: baseTextStyle.copyWith(fontSize: 15, color: Colors.white),
          subtitle1: baseTextStyle.copyWith(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          subtitle2: baseTextStyle.copyWith(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          bodyText1: baseTextStyle.copyWith(fontSize: 16, color: Colors.white),
          bodyText2: baseTextStyle.copyWith(fontSize: 14, color: Colors.white),
          button: baseTextStyle.copyWith(fontSize: 16, color: Colors.white),
          overline: baseTextStyle.copyWith(fontSize: 16, color: Colors.white),
        ),
    appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        backgroundColor: kPrimaryColor),
    colorScheme:
        const ColorScheme.dark().copyWith(background: const Color(0xFF363535)),
  );
}
