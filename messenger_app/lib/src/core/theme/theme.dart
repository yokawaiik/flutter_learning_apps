import 'package:flutter/material.dart';

const _primary = Color(0xff8bc34a);
const _primaryVariant = Color(0xff5a9216);
const _secondary = Color(0xffba68c8);
const _secondaryVariant = Color(0xff883997);

class MessengerTheme {
  final themeLight = ThemeData(
    colorScheme: ColorScheme(
      primary: _primary,
      primaryVariant: _primaryVariant,
      secondary: _secondary,
      secondaryVariant: _secondaryVariant,
      surface: Color(0xffffffff),
      background: Color(0xffc7d7c1),
      error: Color(0xffd32f2f),
      onPrimary: Color(0xff000000),
      onSecondary: Color(0xffffffff),
      onSurface: Color(0xff000000),
      onBackground: Color(0xff000000),
      onError: Color(0xffffffff),
      brightness: Brightness.light,
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: BorderSide(
          color: _primaryVariant,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: BorderSide(
          color: _primary,
          width: 2.0,
        ),
      ),
    ),
    textTheme: TextTheme(
      headline4: TextStyle(color: _primary, fontWeight: FontWeight.w600),
    ),
    checkboxTheme: CheckboxThemeData(
      
      fillColor: MaterialStateColor.resolveWith(
        (states) {
          if (states.contains(MaterialState.selected)) {
            return _primary; // the color when checkbox is selected;
          }
          return _primaryVariant; //the color when checkbox is unselected;
        },
      ),

    ),
  );
}

final messengerTheme = MessengerTheme();
