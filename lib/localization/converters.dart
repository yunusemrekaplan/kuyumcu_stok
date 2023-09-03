import 'package:intl/intl.dart';

class Converters {
  static String doubleNumToTr(String num) {
    List<String> res = num.split('');
    for (int i = 0; i < res.length; i++) {
      if (res[i] == '.') {
        res[i] = '';
      } else if (res[i] == ',') {
        res[i] = '.';
      }
    }
    return res.join('');
  }

  static String doubleNumFromTr(String num) {
    List<String> res = num.split('');
    for (int i = 0; i < res.length; i++) {
      if (res[i] == ',') {
        res[i] = '';
      } else if (res[i] == '.') {
        res[i] = ',';
      }
    }
    return res.join('');
  }

  static String dateToTr(DateTime dateTime) {
    return '${DateFormat.yMd('tr-Tr').format(dateTime)}  ${DateFormat.Hm().format(dateTime)}';
  }
}
