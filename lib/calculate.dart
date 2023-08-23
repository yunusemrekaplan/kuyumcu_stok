class Calculate {
  static double calculateCostPrice(double purityRate, double gram, double laborCost) {
    double costPrice = (purityRate + laborCost) * gram;
    return costPrice;
  }
}
