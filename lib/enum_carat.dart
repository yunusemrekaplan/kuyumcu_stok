enum Carat {
  twentyFour,
  twentyTwo,
  eighteen,
  fourteen,
}

extension PurityRate on Carat {
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

extension IntCarat on Carat {
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