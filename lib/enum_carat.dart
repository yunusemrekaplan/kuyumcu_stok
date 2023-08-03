enum Carat {
  twentyFour,
  twentyTwo,
  eighteen,
  fourteen,
}

extension ToPurityRate on Carat {
  double get purityRateDefinition {
    switch (this) {
      case Carat.twentyFour:
        return 995;
      case Carat.twentyTwo:
        return 916;
      case Carat.eighteen:
        return 750;
      case Carat.fourteen:
        return 585;
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

Carat? toCarat(int carat) {
  switch (carat) {
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
