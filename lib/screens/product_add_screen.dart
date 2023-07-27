import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';

class ProductAddScreen extends StatelessWidget {
  ProductAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: MyDrawer(),
      body: Column(
        children: [

        ],
      ),
    );
  }
}
