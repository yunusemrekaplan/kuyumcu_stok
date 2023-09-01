import 'package:flutter/material.dart';

const int backgroundColor = 0xFF07263C;

final themeMainColorData = ThemeData(
  //brightness: Brightness.dark,
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF2b384a),
    surfaceTintColor: Color(0xFFd0bcff),
    centerTitle: true,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    titleTextStyle: TextStyle(
      color: Colors.yellow,
      fontSize: 36,
    ),
  ),
);
