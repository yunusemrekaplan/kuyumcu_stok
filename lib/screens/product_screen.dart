// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/models/product.dart';

class ProductScreen extends StatefulWidget {
  late Product product;
  ProductScreen({super.key, required this.product});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
