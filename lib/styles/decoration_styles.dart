import 'package:flutter/material.dart';

class DecorationStyles {
  static BoxConstraints buildBoxConstraints(Size size) => BoxConstraints.tight(size);

  static BorderSide buildBorderSide() => const BorderSide(color: Colors.white);

  static Color textFormFieldColors = Colors.white;

  static InputDecoration buildInputDecoration(Size size) {
    return InputDecoration(
      contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, -1.5),
      //border: const OutlineInputBorder(),
      constraints: buildBoxConstraints(size),
      focusedBorder: UnderlineInputBorder(
        borderSide: buildBorderSide(),
      ),
      border: OutlineInputBorder(
        borderSide: buildBorderSide(),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: buildBorderSide(),
      ),
      fillColor: textFormFieldColors,
      focusColor: textFormFieldColors,
      hoverColor: textFormFieldColors,
      //hintText: '9789756249840',
    );
  }

  static InputDecoration buildDropdownButtonInputDecoration() {
    return InputDecoration(
      constraints: DecorationStyles.buildBoxConstraints(const Size(240, 38)),
      contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      focusedBorder: UnderlineInputBorder(
        borderSide: buildBorderSide(),
      ),
      border: OutlineInputBorder(
        borderSide: buildBorderSide(),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: buildBorderSide(),
      ),
      fillColor: textFormFieldColors,
      focusColor: textFormFieldColors,
      hoverColor: textFormFieldColors,
    );
  }
}