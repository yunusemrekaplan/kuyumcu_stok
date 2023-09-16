import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/theme/theme.dart';

class DataTableStyles {
  static MaterialStateProperty<Color?> buildDataRowColor() {
    return MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered)) {
          return backgroundColor;
        }
        else if (states.contains(MaterialState.pressed)) {
          return buttonColor;
        }
        return null;
      },
    );
  }

  static TableBorder buildTableBorder() {
    return const TableBorder(
      horizontalInside: BorderSide(
        width: 0.1,
        color: Colors.white,
      ),
      verticalInside: BorderSide(
        width: 0.6,
        color: Colors.white,
      ),
      borderRadius: BorderRadius.all(Radius.circular(25)),
    );
  }

  static MaterialStateProperty<Color?> buildHeadingRowColor() {
    return MaterialStateProperty.resolveWith((states) {
      return buttonColor;
    });
  }
}
