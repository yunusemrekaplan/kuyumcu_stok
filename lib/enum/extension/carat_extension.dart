import 'package:kuyumcu_stok/enum/carat.dart';

extension ToPurityRate on Carat {
  double get purityRateDefinition {
    switch (this) {
      case Carat.twentyFour:
        return 995.0;
      case Carat.twentyTwo:
        return 916.0;
      case Carat.eighteen:
        return 750.0;
      case Carat.fourteen:
        return 585.0;
    }
  }
}

extension ToInt on Carat {
  int get intDefinition {
    switch (this) {
      case Carat.twentyFour:
        return 24;
      case Carat.twentyTwo:
        return 22;
      case Carat.eighteen:
        return 18;
      case Carat.fourteen:
        return 14;
    }
  }
}

extension ToCarat on int {
  Carat? get caratDefinition {
    switch (this) {
      case 24:
        return Carat.twentyFour;
      case 22:
        return Carat.twentyTwo;
      case 18:
        return Carat.eighteen;
      case 14:
        return Carat.fourteen;
      default:
        return null;
    }
  }
}