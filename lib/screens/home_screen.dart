// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/data/product_gold_db_helper.dart';
import 'package:kuyumcu_stok/models/barcode.dart';
import 'package:kuyumcu_stok/data/barcode_db_helper.dart';
import 'package:kuyumcu_stok/models/product_gold.dart';
import 'package:kuyumcu_stok/services/gold_service.dart';
import 'package:kuyumcu_stok/services/isbn_service.dart';
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
    gold = GoldService.sFGold!;
    GoldService.getGoldPrices().then(
      (value) => setState(
        () {
          gold = value['fine_gold_sale']!;
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
                /*late Barcode barcode;
                IsbnService.generateBarcode(IsbnService.generateCode()).then(
                  (value) async {
                    print('girdi');
                    barcode = value;
                    print(barcode.path);
                    print(barcode.text);

                    await BarcodeDbHelper()
                        .insert('barcodes', barcode.toJson())
                        .then((value) => print('inserted row id: $value'));
                  },
                );*/
                /*GoldService.getGoldPrices().then((value) {
                  setState(() {
                    gold = value!;
                  });
                });*/
                List<ProductGold> products = [];
                List<Map<String, dynamic>> maps;
                await ProductGoldDbHelper().queryAllRows().then((value)
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
