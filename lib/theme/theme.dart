import 'package:flutter/material.dart';

const Color backgroundColor = Color(0xFF07263C);
const Color secondColor = Color(0xFF2b384a);

final mainThemeData = ThemeData(
  //brightness: Brightness.dark,
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    backgroundColor: secondColor,
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
