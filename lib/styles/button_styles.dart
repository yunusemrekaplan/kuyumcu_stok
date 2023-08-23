import 'package:flutter/material.dart';

class ButtonStyles {
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


  static ButtonStyle buildUpdateButtonStyle(int satete) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            if (satete == 2) {
              return Colors.green;
            } else {
              return Colors.red;
            }
          }
          return Colors.grey[600];
        },
      ),
    );
  }

}
