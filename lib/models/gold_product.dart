import 'package:kuyumcu_stok/enum_carat.dart';

class GoldProduct {
  late int id;
  late int isSold;
  late DateTime enteredDate;
  DateTime? soldDate;
  late String barcodeText;
  late String name;
  late Carat carat; // x
  late double purityRate; // x => z
  late double laborCost; // k
  late double gram; // y
  late double costPrice; // s
  late double soldPrice;
  late double earnedProfit;

  // ((z + k) * g) * y

  GoldProduct({
    required this.isSold,
    required this.enteredDate,
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
    if (isSold == 1) {
      soldDate = DateTime.tryParse(json['soldDate']);
      earnedProfit = json['earnedProfit'];
    }
    enteredDate = DateTime.parse(json['enteredDate']);
    barcodeText = json['barcodeText'];
    name = json['name'];
    carat = toCarat(json['carat'])!;
    gram = json['gram']!.toDouble();
    purityRate = json['purityRate']!.toDouble();
    laborCost = json['laborCost']!.toDouble();
    costPrice = json['costPrice']!.toDouble();
  }

  Map<String, dynamic> toJson() {
    if (isSold == 0) {
      return {
        'isSold': isSold,
        'enteredDate': enteredDate.toIso8601String(),
        'barcodeText': barcodeText,
        'name': name,
        'carat': carat.intDefinition,
        'gram': gram,
        'purityRate': purityRate,
        'laborCost': laborCost,
        'costPrice': costPrice,
      };
    }
    else {
      return {
        'isSold': isSold,
        'enteredDate': enteredDate.toIso8601String(),
        'soldDate': soldDate!.toIso8601String(),
        'barcodeText': barcodeText,
        'name': name,
        'carat': carat.intDefinition,
        'gram': gram,
        'purityRate': purityRate,
        'laborCost': laborCost,
        'costPrice': costPrice,
        'earnedProfit': earnedProfit,
      };
    }
  }
}
