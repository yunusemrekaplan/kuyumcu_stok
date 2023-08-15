// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/services/currency_service.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int counter = 0;

  String gold = '....';

  @override
  void initState() {
    gold = CurrencyService.fineGoldSale.toString();
    CurrencyService.getGoldPrices().then(
      (value) => setState(
        () {
          gold = value['fineGoldSale']!.toString();
          print(value);
        },
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const MyDrawer(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                List<Map<String, dynamic>> maps;
                await GoldProductDbHelper().queryAllRows().then((value)
                {
                  maps = value;
                  print(maps.length);
                  maps.map((e) {
                    print(e);

                  });
                });
                //value.map((e) => print(e));
                //products.add(Product.fromJson(e))
                //print(products.length);
              },
              child: const Text(
                'Altın',
                style: TextStyle(
                  fontSize: 26,
                ),
              ),
            ),
            Text(
              gold,
              style: TextStyle(fontSize: 50),
            ),
          ],
        ),
      ),
    );
  }
}
