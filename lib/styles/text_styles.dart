import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle buildTextStyle() {
    return const TextStyle(
      fontSize: 30,
    );
  }

  static TextStyle buildButtonTextStyle() {
    return const TextStyle(
      fontSize: 20,
      color: Colors.white,
    );
  }

  static TextStyle buildTextFormFieldTextStyle() {
    return const TextStyle(
      fontSize: 24,
      height: 1,
    );
  }
}