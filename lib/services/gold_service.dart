import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class CurrencyService {
  static late double fineGoldBuy;
  static late double fineGoldSale;
  static late double usdBuy;
  static late double usdSale;
  static late double eurBuy;
  static late double eurSale;

  //static String? sFGold;


  static var saglamogluUrl = Uri.parse("https://saglamoglualtin.com");

  static var url = Uri.parse("https://www.hasaltin.com/");

  static Future<Map<String, String>> getGoldPrices() async {
    var res = await http.get(saglamogluUrl);
    final body = res.body;
    final document = parser.parse(body);
    var response = document
        .getElementsByClassName('datalist')[0]
        .getElementsByClassName('box')[0]
        .getElementsByClassName('kur')[0]
        .getElementsByClassName('alis')[0]
        .children[1]
        .text
        .toString();

    Map<String, String> currencies = {
      'fine_gold_buy': document
          .getElementsByClassName('datalist')[0]
          .getElementsByClassName('box')[0]
          .getElementsByClassName('kur')[0]
          .getElementsByClassName('alis')[0]
          .children[1]
          .text
          .toString(),
      'fine_gold_sale': document
          .getElementsByClassName('datalist')[0]
          .getElementsByClassName('box')[0]
          .getElementsByClassName('kur')[0]
          .getElementsByClassName('satis')[0]
          .children[1]
          .text
          .toString(),
      'USD_buy': document
          .getElementsByClassName('datalist')[1]
          .getElementsByClassName('box')[0]
          .getElementsByClassName('kur')[0]
          .getElementsByClassName('alis')[0]
          .children[1]
          .text
          .toString(),
      'USD_sale': document
          .getElementsByClassName('datalist')[1]
          .getElementsByClassName('box')[0]
          .getElementsByClassName('kur')[0]
          .getElementsByClassName('satis')[0]
          .children[1]
          .text
          .toString(),
      'EUR_buy': document
          .getElementsByClassName('datalist')[1]
          .getElementsByClassName('box')[1]
          .getElementsByClassName('kur')[0]
          .getElementsByClassName('alis')[0]
          .children[1]
          .text
          .toString(),
      'EUR_sale': document
          .getElementsByClassName('datalist')[1]
          .getElementsByClassName('box')[1]
          .getElementsByClassName('kur')[0]
          .getElementsByClassName('satis')[0]
          .children[1]
          .text
          .toString(),
    };

    var temp = currencies['fine_gold_sale']!.split(',');
    fineGoldBuy = double.parse(temp[0]);
    fineGoldBuy += double.parse(temp[1]) / 100;
    return currencies;
  }
}
