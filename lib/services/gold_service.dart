import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:web_scraper/web_scraper.dart';

class GoldService {
  static double fGold = 1700;

  static var url = Uri.parse("https://www.hasaltin.com/");
  var data;

  static Future<String> getGoldPrices() async {
    var res = await http.get(url);
    final body = res.body;
    final document = parser.parse(body);
    var response = document
        .getElementsByClassName('datalist')[0]
        .getElementsByClassName('box')[0]
        .getElementsByClassName('kur')[0]
        .getElementsByClassName('alis')[0].children[1].text
        .toString();
    return response;
  }
}
