class EnteredGoldProduct {
  late int id;
  late int num;
  late int stockProductId;
  late DateTime enteredDate;

  EnteredGoldProduct({
    required this.num,
    required this.stockProductId,
    required this.enteredDate,
  });

  EnteredGoldProduct.fromJson(Map<String, dynamic> json, this.id) {
    num = json['num'];
    stockProductId = json['productId'];
    enteredDate = json['enteredDate'];
  }

  Map<String, dynamic> toJson() {
    return {
      'num': num,
      'productId': stockProductId,
      'enteredDate': enteredDate,
    };
  }
}
