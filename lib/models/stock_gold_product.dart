import 'package:kuyumcu_stok/enum_carat.dart';

class StockGoldProduct {
  late int id;
  late String barcodeText;
  late String name;
  late Carat carat; // x
  late double purityRate; // x => z
  late double laborCost; // k
  late double gram; // y
  late double cost; // s

  // ((z + k) * g) * y

  StockGoldProduct({
    required this.barcodeText,
    required this.name,
    required this.carat,
    required this.gram,
    required this.purityRate,
    required this.laborCost,
    required this.cost,
  });

  StockGoldProduct.fromJson(Map<String, dynamic> json, this.id) {
    barcodeText = json['barcodeText'];
    name = json['name'];
    carat = toCarat(json['carat'])!;
    gram = json['gram']!.toDouble();
    purityRate = json['purityRate']!.toDouble();
    laborCost = json['laborCost']!.toDouble();
    cost = json['cost']!.toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      //'enteredDate': enteredDate.toIso8601String(),
      'barcodeText': barcodeText,
      'name': name,
      'carat': carat.intDefinition,
      'gram': gram,
      'purityRate': purityRate,
      'laborCost': laborCost,
      'cost': cost,
    };
  }
}
