import 'package:kuyumcu_stok/enum/carat.dart';
import 'package:kuyumcu_stok/enum/extension/carat_extension.dart';

class GoldProduct {
  late int id;
  late String barcodeText;
  late int piece;
  late String name;
  late Carat carat; // x
  late double purityRate; // x => z
  late double laborCost; // k
  late double gram; // y
  late double cost; // s
  late double salesGrams;

  // ((z + k) * g) * y

  GoldProduct({
    required this.barcodeText,
    required this.piece,
    required this.name,
    required this.carat,
    required this.gram,
    required this.purityRate,
    required this.laborCost,
    required this.cost,
    required this.salesGrams,
  });

  GoldProduct.fromJson(Map<String, dynamic> json, this.id) {
    barcodeText = json['barcodeText'];
    piece = json['piece'];
    name = json['name'];
    carat = toCarat(json['carat'])!;
    gram = json['gram']!.toDouble();
    purityRate = json['purityRate']!.toDouble();
    laborCost = json['laborCost']!.toDouble();
    cost = json['cost']!.toDouble();
    salesGrams = json['salesGrams']!.toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      //'enteredDate': enteredDate.toIso8601String(),
      'barcodeText': barcodeText,
      'piece': piece,
      'name': name,
      'carat': carat.intDefinition,
      'gram': gram,
      'purityRate': purityRate,
      'laborCost': laborCost,
      'cost': cost,
      'salesGrams': salesGrams,
    };
  }
}
