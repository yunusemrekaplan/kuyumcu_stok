enum Carat {
  twentyFour,
  twentyTwo,
  eighteen,
  fourteen,
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
