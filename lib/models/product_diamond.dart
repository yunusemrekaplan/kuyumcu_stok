class ProductDiamond {
  late int id;
  late String barcodeText;
  late String? name;
  late double gram;
  late double price;

  ProductDiamond.fromJson(Map<String, dynamic> json) {
    barcodeText = json['barcodeText'];
    name = json['name'] ?? '';
    gram = json['gram'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    return {
      'barcodeText': barcodeText,
      'name': name ?? '',
      'gram': gram,
      'price': price,
    };
  }
}