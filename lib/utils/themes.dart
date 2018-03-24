import 'package:flutter/material.dart';

enum CurrentTheme { dark, light }


final ThemeData darkTheme = new ThemeData(
    brightness: Brightness.dark,
    buttonColor: Colors.white,
    unselectedWidgetColor: Colors.white,
    primaryTextTheme:
        new TextTheme(caption: new TextStyle(color: Colors.white)));

final ThemeData lightTheme = new ThemeData(
    primaryColor: Colors.blue,
    backgroundColor: Colors.white,
    buttonColor: Colors.black,
    unselectedWidgetColor: Colors.white,
    primaryTextTheme:
        new TextTheme(caption: new TextStyle(color: Colors.white)));
