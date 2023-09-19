import 'dart:convert';

class ProductEntry {
  late int id;
  late Map<String, dynamic> product;
  late DateTime enteredDate;
  late int piece;

  ProductEntry({
    required this.product,
    required this.enteredDate,
    required this.piece,
  });

  ProductEntry.fromJson(Map<String, dynamic> json, this.id) {
    product = jsonDecode(json['product']);
    enteredDate = DateTime.parse(json['enteredDate']);
    piece = json['piece'];
  }

  Map<String, dynamic> toJson() {
    return {
      'product': jsonEncode(product),
      'enteredDate': enteredDate.toIso8601String(),
      'piece': piece,
    };
  }
}
