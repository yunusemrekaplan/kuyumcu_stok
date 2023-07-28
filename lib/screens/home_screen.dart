// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/screens/barcode_screen.dart';
import 'package:kuyumcu_stok/services/isbn_service.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';

import 'dart:typed_data';
import 'dart:io';

import 'package:aspose_barcode_cloud/api.dart';
import 'package:http/http.dart' as http;
import 'package:aspose_barcode_cloud/api.dart' as barcode;


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
                IsbnService.generateBarcode();
                //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => BarcodeScreen()));
              },
              child: Text('Barkod Üret', style: TextStyle(fontSize: 26,),),
            ),
            /*TextButton(
              onPressed: () {},
              style: const ButtonStyle(
                textStyle: MaterialStatePropertyAll(
                  TextStyle(
                    fontSize: 40,
                    color: Colors.black,
                  ),
                ),
              ),
              child: const Text('Ürünler'),
            ),*/
          ],
        ),
      ),
    );
  }
}
