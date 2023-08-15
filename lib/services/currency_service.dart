import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class CurrencyService {
  static late double fineGoldBuy;
  static late double fineGoldSale;
  static late double usdBuy;
  static late double usdSale;
  static late double eurBuy;
  static late double eurSale;

  static var hakanAltin = Uri.parse("https://www.hakanaltin.com");

  static var url = Uri.parse("https://www.hasaltin.com/");

  static Future<Map<String, double>> getGoldPrices() async {
    var res = await http.get(hakanAltin);
    final body = res.body;
    final document = parser.parse(body);

    buildCurrencies(document);

    Map<String, double> currencies = {
      'fineGoldBuy': fineGoldBuy,
      'fineGoldSale': fineGoldSale,
      'usdBuy': usdBuy,
      'usdSale': usdSale,
      'eurBuy': eurBuy,
      'eurSale': eurSale,
    };

    return currencies;
  }

  static String buildCurrencies(Document document) {
    var fineGoldBuyTemp = document
        .getElementById('fxdouble_main')!
        .children[0]
        .children[1]
        .children[1]
        .children[0]
        .children[3]
        .children[0]
        .text
        .toString();
    var fineGoldSaleTemp = document
        .getElementById('fxdouble_main')!
        .children[0]
        .children[1]
        .children[1]
        .children[0]
        .children[4]
        .children[0]
        .text
        .toString();
    var usdBuyTemp = document
        .getElementById('fxdouble_main')!
        .children[1]
        .children[1]
        .children[1]
        .children[0]
        .children[3]
        .children[0]
        .text
        .toString();
    var usdSaleTemp = document
        .getElementById('fxdouble_main')!
        .children[1]
        .children[1]
        .children[1]
        .children[0]
        .children[4]
        .children[0]
        .text
        .toString();
    var eurBuyTemp = document
        .getElementById('fxdouble_main')!
        .children[1]
        .children[1]
        .children[1]
        .children[1]
        .children[3]
        .children[0]
        .text
        .toString();
    var eurSaleTemp = document
        .getElementById('fxdouble_main')!
        .children[1]
        .children[1]
        .children[1]
        .children[1]
        .children[4]
        .children[0]
        .text
        .toString();

    fineGoldBuy = double.parse(swapDotAndComma(fineGoldBuyTemp));
    fineGoldSale = double.parse(swapDotAndComma(fineGoldSaleTemp));
    usdBuy = double.parse(swapDotAndComma(usdBuyTemp));
    usdSale = double.parse(swapDotAndComma(usdSaleTemp));
    eurBuy = double.parse(swapDotAndComma(eurBuyTemp));
    eurSale = double.parse(swapDotAndComma(eurSaleTemp));
    return fineGoldSaleTemp;
  }

  static String swapDotAndComma(String input) {
    return input
        .split('')
        .map((char) => char == '.'
            ? ''
            : char == ','
                ? '.'
                : char)
        .join('');
  }
}
