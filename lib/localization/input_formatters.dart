import 'package:flutter/services.dart';

final inputDouble = FilteringTextInputFormatter.allow(RegExp(r'[\d,.]'));

final inputOnlyDigits = FilteringTextInputFormatter.allow(RegExp(r'\d'));
