import 'dart:convert';

class ProductSale {
  late int id;
  late Map<String, dynamic> product;
  late DateTime soldDate;
  late int piece;
  late double costPrice; // s
  late double soldPrice;
  late double soldGram;
  late double earnedProfitTL;
  late double earnedProfitGram;

  ProductSale({
    required this.product,
    required this.soldDate,
    required this.piece,
    required this.costPrice,
    required this.soldPrice,
    required this.soldGram,
    required this.earnedProfitTL,
    required this.earnedProfitGram,
  });

  ProductSale.fromJson(Map<String, dynamic> json, this.id) {
    product = jsonDecode(json['product']);
    soldDate = DateTime.parse(json['soldDate']);
    piece = json['piece'];
    costPrice = json['costPrice'];
    soldPrice = json['soldPrice'];
    soldGram = json['soldGram'];
    earnedProfitTL = json['earnedProfitTL'];
    earnedProfitGram = json['earnedProfitGram'];
  }

  Map<String, dynamic> toJson() {
    return {
      'product': jsonEncode(product),
      'soldDate': soldDate.toIso8601String(),
      'piece': piece,
      'costPrice': costPrice,
      'soldPrice': soldPrice,
      'soldGram': soldGram,
      'earnedProfitTL': earnedProfitTL,
      'earnedProfitGram': earnedProfitGram,
    };
  }
}
