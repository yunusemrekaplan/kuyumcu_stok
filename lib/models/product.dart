import 'package:kuyumcu_stok/models/barcode.dart';

class Product {
  late int id;
  late Barcode barcode;
  late String name;
  late int carat; // x
  late double gram; // y
  late double costGram; // t
  late double mil; // z
  late double costPrice; // s

  // (x + z) * y = t
  // t * g = s
  // (x + z) * y * g = s

  Product({
    required this.barcode,
    required this.name,
    required this.carat,
    required this.gram,
    required this.costGram,
    required this.mil,
    required this.costPrice,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    barcode = Barcode.fromJson(json['barcode']);
    name = json['name'] ?? '';
    carat = json['carat'];
    gram = json['gram'];
    costGram = json['costGram'];
    mil = json['mil'];
    costPrice = json['costPrice'];
  }

  Map<String, dynamic> toJson() {
    return {
      'barcode': barcode.toJsonWithId(),
      'name' : name ?? '',
      'carat' : carat,
      'gram' : gram,
      'costGram' : costGram,
      'mil' : mil,
      'costPrice' : costPrice,
    };
  }
}
