import 'package:kuyumcu_stok/services/currency_service.dart';

class Calculate {
  static double calculateCostPrice(double purityRate, double gram, double laborCost) {
    double costPrice = (purityRate + laborCost) * gram;
    return costPrice;
  }
}
