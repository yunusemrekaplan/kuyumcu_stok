import 'package:flutter/services.dart';

final inputFormatDouble = FilteringTextInputFormatter.allow(RegExp(r'[\d,]'));

final inputFormatOnlyDigits = FilteringTextInputFormatter.allow(RegExp(r'\d'));
