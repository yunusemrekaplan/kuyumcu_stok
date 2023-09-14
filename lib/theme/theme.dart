import 'package:flutter/material.dart';

const Color backgroundColor = Color(0xFF1c2139);
const Color secondColor = Color(0xFF262b49);
const Color buttonColor = Color(0xFF3d4575);
const Color appBarColor = Color(0xFF0e1432);

final mainThemeData = ThemeData(
  //brightness: Brightness.dark,
  useMaterial3: true,
  appBarTheme: AppBarTheme(
    backgroundColor: appBarColor,
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
