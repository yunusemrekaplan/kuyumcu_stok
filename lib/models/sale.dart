import 'package:kuyumcu_stok/models/stock_gold_product.dart';

class Sale {
  late StockGoldProduct product;
  late DateTime soldDate;
  late int piece;
  late double costPrice; // s
  late double soldPrice;
  late double soldGram;
  late double earnedProfit;

  Sale({
    required this.product,
    required this.soldDate,
    required this.piece,
    required this.costPrice,
    required this.soldPrice,
    required this.soldGram,
    required this.earnedProfit,
  });
}
