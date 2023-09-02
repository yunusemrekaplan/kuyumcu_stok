class Calculate {
  static double calculateCostPrice(double purityRate, double gram, double laborCost) {
    double cost = (purityRate + laborCost) * gram;
    return cost;
  }
}
