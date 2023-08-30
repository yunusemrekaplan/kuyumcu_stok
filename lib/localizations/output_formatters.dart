import 'package:intl/intl.dart';

class OutputFormatters {
  String buildNumberFormat(double number) {
    return NumberFormat('#,##0.0', 'tr_TR').format(number);
  }
}