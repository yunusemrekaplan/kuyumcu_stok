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

  static var saglamogluUrl = Uri.parse("https://saglamoglualtin.com/sube");

  static Future getCurrenciesOfSaglamoglu() async {
    var res = await http
        .get(Uri.parse('https://canlidoviz.com/altin-fiyatlari/kapali-carsi'));
    final body = res.body;
    final document = parser.parse(body);

    //buildCurrenciesOfHakanAltin(document);

    /*Map<String, double> currencies = {
      'fineGoldBuy': fineGoldBuy,
      'fineGoldSale': fineGoldSale,
      'usdBuy': usdBuy,
      'usdSale': usdSale,
      'eurBuy': eurBuy,
      'eurSale': eurSale,
    };*/


    var temp = document
        .querySelector(
            'body > main > div > div.grid > section.content.col-12.col-lg-6')!
        .children[0]
        .children[0]
        .children[0]
        .children[1]
        .children[0]
        .children[1]
        .children[9]
        .children[1].text;

    var temp1 = document
        .querySelector(
            'body > main > div > div.grid > section.content.col-12.col-lg-6')!
        .children[0]
        .children[0]
        .children[0]
        .children[1]
        .children[0]
        .children[1]
        .children[9]
        .children[3].text;



    return temp1;
  }

  static Future<Map<String, double>> getCurrenciesOfHakanAltin() async {
    var res = await http.get(hakanAltin);
    final body = res.body;
    final document = parser.parse(body);

    buildCurrenciesOfHakanAltin(document);

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

  static String buildCurrenciesOfHakanAltin(Document document) {
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
