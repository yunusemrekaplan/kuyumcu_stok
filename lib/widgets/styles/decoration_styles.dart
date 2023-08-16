import 'package:flutter/material.dart';

class DecorationStyleWidgets {
  static BoxConstraints buildBoxConstraints(Size size) => BoxConstraints.tight(size);

  static InputDecoration buildInputDecoration(Size size) {
    return InputDecoration(
      contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 20),
      border: const OutlineInputBorder(),
      constraints: buildBoxConstraints(size),
      //hintText: '9789756249840',
    );
  }
}