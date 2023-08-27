class ProductEntry {
  late int id;
  late int productId;
  late DateTime enteredDate;
  late int piece;

  ProductEntry({
    required this.productId,
    required this.enteredDate,
    required this.piece,
  });

  ProductEntry.fromJson(Map<String, dynamic> json, this.id) {
    productId = json['productId'];
    enteredDate = json['enteredDate'];
    piece = json['piece'];
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'enteredDate': enteredDate,
      'piece': piece,
    };
  }
}
