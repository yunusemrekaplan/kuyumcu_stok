import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/models/product.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> products = [
    Product(name: 'Yüzük', gram: 5.4, mil: 560),
    Product(name: 'Kolye', gram: 7.2, mil: 740),
    Product(name: 'Bileklik', gram: 11.6, mil: 600),
    Product(name: 'Bilezik', gram: 18.4, mil: 870),
    Product(name: 'Yüzük', gram: 3.1, mil: 480),
    Product(name: 'Yüzük', gram: 3.1, mil: 480),
    Product(name: 'Yüzük', gram: 3.1, mil: 480),
    Product(name: 'Yüzük', gram: 3.1, mil: 480),
    Product(name: 'Yüzük', gram: 3.1, mil: 480),
    Product(name: 'Yüzük', gram: 3.1, mil: 480),
    Product(name: 'Yüzük', gram: 3.1, mil: 480),
    Product(name: 'Yüzük', gram: 3.1, mil: 480),
    Product(name: 'Yüzük', gram: 3.1, mil: 480),
    Product(name: 'Yüzük', gram: 3.1, mil: 480),
    Product(name: 'Yüzük', gram: 3.1, mil: 480),
    Product(name: 'Yüzük', gram: 3.1, mil: 480),
    Product(name: 'Yüzük', gram: 3.1, mil: 480),
    Product(name: 'Yüzük', gram: 3.1, mil: 480),
    Product(name: 'Yüzük', gram: 3.1, mil: 480),
    Product(name: 'Yüzük', gram: 3.1, mil: 480),
    Product(name: 'Yüzük', gram: 3.1, mil: 480),
    Product(name: 'Yüzük', gram: 3.1, mil: 480),
    Product(name: 'Yüzük', gram: 3.1, mil: 480),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const MyDrawer(),
      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 1,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('İsim')),
                    DataColumn(label: Text('Gram')),
                    DataColumn(label: Text('Milyem')),
                  ],
                  rows: products.map(
                    (e) => DataRow(
                      cells: [
                        DataCell(Text(e.name)),
                        DataCell(Text(e.gram.toString())),
                        DataCell(Text(e.mil.toString())),
                      ],
                    ),
                  ).toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
