import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:web_scraper/web_scraper.dart';

class GoldService {
  static double fGold = 1700;

  static Future<void> getGoldPrices() async {

    /*
    final response = await http.get(Uri.parse('https://www.haremaltin.com/canli-piyasalar/#'));
    if (response.statusCode == 200) {
      print(response.body);
      http.read()
      ///[@id="view"]/section[2]/div/div/div/div[1]/div[2]/div[2]/table/tbody/tr[1]/td[2]/span/text()
    } else {
      throw Exception('Failed to load data');
    }

    */
    final response = await http.get(Uri.parse('https://www.haremaltin.com/canli-piyasalar'));
    final document = parser.parse(response.body);
/*
    final elements = document.querySelector("#view > section.dashboard-content.container-fluid > div.row > div.col-lg-12 > div.dashboard-left.dashboard-grid > div.box > div.list-table");
    print(elements);
    for (final element in elements) {
      final columns = element.querySelectorAll('td');
      print('${columns[0].text} - ${columns[1].text}');
    }
    */

    final elements1 = document.querySelectorAll('#view > section.dashboard-content.container-fluid > div > div > div > div:nth-child(1) > div.list-table > div:nth-child(2) > table > tbody > tr:nth-child(1) > td:nth-child(2) > span > span');
    print(elements1.first.text);

    //final altinHas = elements1[0].querySelectorAll('td')[1].text;
/*
    late List<Map<String, dynamic>> maps;

    final webScraper = WebScraper('https://www.altinkaynak.com');
    if (await webScraper.loadWebPage('/canli-kurlar/altin')) {
      maps = webScraper.getElement('#sidebar-wrapper', []);
      //body > section.currency-gold.container > div:nth-child(1) > div.col-lg-8 > div > div.tableContent.evo-tableContent > div:nth-child(1) > table > tbody > #tr__ALTIN > td
      //#tr__ALTIN
      //body > section.currency-gold.container > div > div.col-lg-8 > div > div.tableContent.viewContainer > div > table.table > tbody > tr > td.home-container-th > span.item
      //print(maps);

      print(maps);

      for(int i=0; i<maps.length; i++) {
        print(maps[i]);
      }

      maps.map((e) => print(e.toString()));
    }
    else {
      print('NULL');
    }
    */
  }
}