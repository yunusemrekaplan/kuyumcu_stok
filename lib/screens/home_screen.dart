// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/models/barcode.dart';
import 'package:kuyumcu_stok/services/barcode_db_helper.dart';
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
              onPressed: () async {
                late Barcode barcode;
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
                );
              },
              child: const Text(
                'Barkod Üret',
                style: TextStyle(
                  fontSize: 26,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
