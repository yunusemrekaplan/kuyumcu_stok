import 'package:intl/intl.dart';

class OutputFormatters {

  static String buildNumberFormat0f(double number) {
    return NumberFormat('#,##0', 'tr_TR').format(number);
  }

  static String buildNumberFormat1f(double number) {
    return NumberFormat('#,##0.0', 'tr_TR').format(number);
  }

  static String buildNumberFormat2f(double number) {
    return NumberFormat('#,##0.00', 'tr_TR').format(number);
  }

  static String buildNumberFormat3f(double number) {
    return NumberFormat('#,##0.000', 'tr_TR').format(number);
  }

}