import 'package:kuyumcu_stok/enum_carat.dart';
import 'package:kuyumcu_stok/models/barcode.dart';

class Product {
  late int id;
  late String barcodeText;
  late Barcode barcode;
  late String? name;
  late Carat carat; // x
  late double purityRate; // x => z
  late double laborCost; // k
  late double gram; // y
  late double costGram; // t
  late double costPrice; // s

  // ((z + k) * g) * y


  Product(
      {required this.barcodeText,
      required this.name,
      required this.carat,
      required this.gram,
      required this.purityRate,
      required this.laborCost,
      required this.costPrice,}) {
   /* BarcodeDbHelper barcodeDbHelper = BarcodeDbHelper();
    barcodeDbHelper.getBarcodeById(barcodeId).then((value) => barcode = Barcode.fromJson(value!));*/
  }

  Product.fromJson(Map<String, dynamic> json, this.id) {
    barcodeText = json['barcodeText'];
    name = json['name'] ?? '';
    carat = toCarat(json['carat'])!;
    gram = json['gram']!.toDouble();
    //costGram = json['costGram'];
    purityRate = json['purityRate']!.toDouble();
    laborCost = json['laborCost']!.toDouble();
    costPrice = json['costPrice']!.toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      'barcodeText': barcodeText,
      'name': name ?? '',
      'carat': carat.intDefinition,
      'gram': gram,
      //'costGram': costGram,
      'purityRate': purityRate,
      'laborCost': laborCost,
      'costPrice': costPrice,
    };
  }
}
