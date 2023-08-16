import 'package:flutter/material.dart';

class ButtonStyleWidgets {
  static ButtonStyle buildBackButtonStyle() {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.hovered)) {
          return Colors.green;
        }
        return Colors.grey[600];
      }),
    );
  }

  static ButtonStyle buildSaveButtonStyle(String barcodeNo, String name,
      String purityRate, String laborCost, String gram, String costPrice) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            if (barcodeNo == '0000000000000' ||
                name.isEmpty ||
                purityRate.isEmpty ||
                laborCost.isEmpty ||
                gram.isEmpty ||
                costPrice.isEmpty) {
              return Colors.red;
            } else {
              return Colors.green;
            }
          }
          return Colors.grey[600];
        },
      ),
    );
  }
}
