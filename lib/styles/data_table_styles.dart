import 'package:flutter/material.dart';

class DataTableStyles {
  static MaterialStateProperty<Color?> buildDataRowColor() {
    return MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered)) {
          return Colors.grey[400];
        }
        return null;
      },
    );
  }

  static TableBorder buildTableBorder() {
    return const TableBorder(
      top: BorderSide(width: 1),
      left: BorderSide(width: 1),
      right: BorderSide(width: 1),
      bottom: BorderSide(width: 1),
      horizontalInside: BorderSide(width: 1),
      verticalInside: BorderSide(width: 1),
      //borderRadius: BorderRadius.all(Radius.circular(20)),
    );
  }

  static MaterialStateProperty<Color?> buildHeadingRowColor() {
    return MaterialStateProperty.resolveWith((states) {
      return Colors.grey[400];
    });
  }
}
