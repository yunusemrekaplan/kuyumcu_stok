// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/models/barcode.dart';
import 'package:kuyumcu_stok/services/gold_service.dart';
import 'package:kuyumcu_stok/services/isbn_service.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  int counter = 0;

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
              onPressed: () {
                late Barcode barcode;
                IsbnService.generateBarcode().then((value) => () {
                  barcode = value;
                  print(barcode.path);
                  print(barcode.text);
                });
                //GoldService.getGoldPrices();
              },
              child: Text('Barkod Üret', style: TextStyle(fontSize: 26,),),
            ),
          ],
        ),
      ),
    );
  }
}
