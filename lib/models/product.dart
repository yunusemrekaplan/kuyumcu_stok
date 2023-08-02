import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/calculate.dart';
import 'package:kuyumcu_stok/enum_carat.dart';
import 'package:kuyumcu_stok/models/barcode.dart';
import 'package:kuyumcu_stok/data/barcode_db_helper.dart';
import 'package:kuyumcu_stok/services/gold_service.dart';

class Product {
  late int id;
  late int barcodeId;
  late Barcode barcode;
  late String? name;
  late Carat carat; // x
  late double purityRate; // x => z
  late double laborCost; // k
  late double gram; // y
  late double costGram; // t
  late double costPrice; // s

  // ((z + k) * g) * y


  Product(
      {required this.barcodeId,
      required this.name,
      required this.carat,
      required this.gram}) {
    BarcodeDbHelper barcodeDbHelper = BarcodeDbHelper();
    barcodeDbHelper
        .getBarcodeById(barcodeId)
        .then((value) => barcode = Barcode.fromJson(value!));

    costPrice = Calculate.calculateCostPrice(purityRate, gram, laborCost);
  }

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    barcodeId = json['barcodeId'];
    name = json['name'] ?? '';
    carat = json['carat'];
    gram = json['gram'];
    costGram = json['costGram'];
    purityRate = json['mil'];
    costPrice = json['costPrice'];
  }

  Map<String, dynamic> toJson() {
    return {
      'barcodeId': barcodeId,
      'name': name ?? '',
      'carat': carat,
      'gram': gram,
      'costGram': costGram,
      'mil': purityRate,
      'costPrice': costPrice,
    };
  }
}
