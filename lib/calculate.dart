import 'package:kuyumcu_stok/services/gold_service.dart';

class Calculate {
  static double calculateCostPrice(double purityRate, double gram, double laborCost) {
    /*print('saflık: $purityRate');
    print('gram: $gram');
    print('işçilik: $laborCost');*/
    double costPrice = (purityRate + laborCost) * GoldService.fGold * gram / 1000;
    //print('maliyet: $costPrice');
    return costPrice;
  }
}
