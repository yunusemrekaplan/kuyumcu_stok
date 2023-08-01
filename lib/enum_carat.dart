enum Carat {
  twentyFour,
  twentyTwo,
  eighteen,
  fourteen,
}

extension Milyem on Carat {
  double get milDefinition {
    switch (this) {
      case Carat.twentyFour:
        return 999.9;
      case Carat.twentyTwo:
        return 916.0;
      case Carat.eighteen:
        return 750.0;
      case Carat.fourteen:
        return 585.0;
    }
  }
}