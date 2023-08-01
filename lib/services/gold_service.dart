import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class GoldService {

  static late double fGold;
  static String? sFGold;

  static var url = Uri.parse("https://www.hasaltin.com/");

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

    sFGold = response;
    var temp = response.split(',');
    fGold = double.parse(temp[0]);
    fGold += double.parse(temp[1]) / 100;
    return response;
  }
}
