import 'package:kuyumcu_stok/enum_carat.dart';
import 'package:kuyumcu_stok/services/gold_service.dart';

class Calculate {
  static Map<String, double> calculateCostPrice(Carat carat, double gram) {
    double mil = carat.milDefinition;
    double costGram = (carat.intDefinition + mil) * gram;
    double costPrice = costGram * GoldService.fGold;
    return {
      'costGram': costGram,
      'carat': carat.milDefinition,
      'costPrice': costPrice,
    };
  }
}
