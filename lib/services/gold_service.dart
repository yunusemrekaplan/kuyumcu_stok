import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class GoldService {
  static late double fGold;
  static String? sFGold;

  static var url = Uri.parse("https://www.hasaltin.com/");

  static Future<String?> getGoldPrices() async {
    var res = await http.get(url);
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

    sFGold = currencies['fine_gold_sale']!;
    var temp = currencies['fine_gold_sale']!.split(',');
    fGold = double.parse(temp[0]);
    fGold += double.parse(temp[1]) / 100;
    return currencies['fine_gold_sale'];
  }
}
