import 'package:kuyumcu_stok/enum/month.dart';

extension ToString on Month {
  String get nameDefinition {
    switch(this) {
      case Month.january:
        return 'Ocak';
      case Month.february:
        return 'Şubat';
      case Month.march:
        return 'Mart';
      case Month.april:
        return 'Nisan';
      case Month.may:
        return 'Mayıs';
      case Month.june:
        return 'Haziran';
      case Month.july:
        return 'Temmuz';
      case Month.august:
        return 'Ağustos';
      case Month.september:
        return 'Eylül';
      case Month.october:
        return 'Ekim';
      case Month.november:
        return 'Kasım';
      case Month.december:
        return 'Aralık';
    }
  }
}

extension ToInt on Month {
  int get intDefinition {
    switch(this) {
      case Month.january:
        return 1;
      case Month.february:
        return 2;
      case Month.march:
        return 3;
      case Month.april:
        return 4;
      case Month.may:
        return 5;
      case Month.june:
        return 6;
      case Month.july:
        return 7;
      case Month.august:
        return 8;
      case Month.september:
        return 9;
      case Month.october:
        return 10;
      case Month.november:
        return 11;
      case Month.december:
        return 12;
    }
  }
}