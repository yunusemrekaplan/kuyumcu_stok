import 'package:kuyumcu_stok/enum_carat.dart';

class GoldProduct {
  late int id;
  late int isSold;
  late String barcodeText;
  late String name;
  late Carat carat; // x
  late double purityRate; // x => z
  late double laborCost; // k
  late double gram; // y
  //late double costGram; // t
  late double costPrice; // s

  // ((z + k) * g) * y

  GoldProduct({
    required this.isSold,
    required this.barcodeText,
    required this.name,
    required this.carat,
    required this.gram,
    required this.purityRate,
    required this.laborCost,
    required this.costPrice,
  });

  GoldProduct.fromJson(Map<String, dynamic> json, this.id) {
    isSold = json['isSold'];
    barcodeText = json['barcodeText'];
    name = json['name'];
    carat = toCarat(json['carat'])!;
    gram = json['gram']!.toDouble();
    purityRate = json['purityRate']!.toDouble();
    laborCost = json['laborCost']!.toDouble();
    costPrice = json['costPrice']!.toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      'isSold': isSold,
      'barcodeText': barcodeText,
      'name': name,
      'carat': carat.intDefinition,
      'gram': gram,
      'purityRate': purityRate,
      'laborCost': laborCost,
      'costPrice': costPrice,
    };
  }
}
