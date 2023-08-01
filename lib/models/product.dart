import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/enum_carat.dart';
import 'package:kuyumcu_stok/models/barcode.dart';
import 'package:kuyumcu_stok/data/barcode_db_helper.dart';
import 'package:kuyumcu_stok/services/gold_service.dart';

class Product {
  late int id;
  late int barcodeId;
  late Barcode barcode;
  late String? name;
  late int carat; // x
  late double gram; // y
  late double costGram; // t
  late double mil; // z
  late double costPrice; // s

  // (x + z) * y = t
  // t * g = s
  // (x + z) * y * g = s

  Product(
      {required this.barcodeId,
      required this.name,
      required this.carat,
      required this.gram}) {
    BarcodeDbHelper barcodeDbHelper = BarcodeDbHelper();
    barcodeDbHelper
        .getBarcodeById(barcodeId)
        .then((value) => barcode = Barcode.fromJson(value!));

    switch (carat) {
      case 14:
        mil = Carat.fourteen.milDefinition;
        costGram = (carat + mil) * gram;
        costPrice = costGram * GoldService.fGold;
        break;
      case 18:
        mil = Carat.eighteen.milDefinition;
        costGram = (carat + mil) * gram;
        costPrice = costGram * GoldService.fGold;
        break;
      case 22:
        mil = Carat.twentyTwo.milDefinition;
        costGram = (carat + mil) * gram;
        costPrice = costGram * GoldService.fGold;
        break;
      case 24:
        mil = Carat.twentyFour.milDefinition;
        costGram = (carat + mil) * gram;
        costPrice = costGram * GoldService.fGold;
        break;
      default:
      //throw('Bilinmeyen karat değeri');
    }
  }

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    barcodeId = json['barcodeId'];
    name = json['name'] ?? '';
    carat = json['carat'];
    gram = json['gram'];
    costGram = json['costGram'];
    mil = json['mil'];
    costPrice = json['costPrice'];
  }

  Map<String, dynamic> toJson() {
    return {
      'barcodeId': barcodeId,
      'name': name ?? '',
      'carat': carat,
      'gram': gram,
      'costGram': costGram,
      'mil': mil,
      'costPrice': costPrice,
    };
  }
}
