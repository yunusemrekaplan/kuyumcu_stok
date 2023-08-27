import 'package:flutter/services.dart';

class InputFormatters {

  static FilteringTextInputFormatter inputDouble() {
    return FilteringTextInputFormatter.allow(RegExp(r'[0-9,]'));
  }

  static FilteringTextInputFormatter inputOnlyDigits() {
    return FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
  }
}