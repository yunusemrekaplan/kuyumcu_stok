import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/theme/theme.dart';

class ButtonStyles {
  static final ButtonStyles _instance = ButtonStyles._internal();

  factory ButtonStyles() {
    return _instance;
  }

  ButtonStyles._internal();

  ButtonStyle buildBasicButtonStyle() {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.hovered)) {
          return Colors.green;
        }
        return buttonColor;
      }),
    );
  }

  ButtonStyle buildSaveButtonStyle(bool state) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            if (state) {
              return Colors.red;
            } else {
              return Colors.green;
            }
          }
          return buttonColor;
        },
      ),
    );
  }


  ButtonStyle buildUpdateButtonStyle(int state) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            if (state == 2) {
              return Colors.green;
            } else {
              return Colors.red;
            }
          }
          return buttonColor;
        },
      ),
    );
  }

}
