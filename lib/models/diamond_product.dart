class DiamondProduct {
  late int id;
  late String barcodeText;
  late String? name;
  late double gram;
  late double price;

  DiamondProduct({required this.barcodeText, required this.name, required this.gram, required this.price});

  DiamondProduct.fromJson(Map<String, dynamic> json) {
    barcodeText = json['barcodeText'];
    name = json['name'] ?? '';
    gram = json['gram'] * 1.0;
    price = json['price'] * 1.0;
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