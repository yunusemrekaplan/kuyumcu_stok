import 'package:flutter/services.dart';

final inputFormatDouble = FilteringTextInputFormatter.allow(RegExp(r'^\d+,?\d{0,3}'));

final inputFormatOnlyDigits = FilteringTextInputFormatter.allow(RegExp(r'\d'));

class ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;
    if (text.contains('.')) {
      text = text.replaceAll('.', '');
    }
    List<String> split = text.split(',');
    if (split.length > 2) {
      return oldValue;
    }
    String integerPart = split[0];
    if (integerPart.length > 3) {
      RegExp regExp = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
      integerPart = integerPart.replaceAllMapped(regExp, (match) => '${match[1]}.');
    }
    String newString = integerPart;
    if (split.length == 2) {
      String decimalPart = split[1];
      newString += ',$decimalPart';
    }
    return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(offset: newString.length));
  }
}