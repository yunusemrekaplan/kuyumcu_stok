import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/data/product_db_helper.dart';
import 'package:kuyumcu_stok/enum_carat.dart';
import 'package:kuyumcu_stok/screens/product_screen.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  Map<int, bool> selects = {};

  @override
  void initState() {
    ProductDbHelper().products.map((e) => {
          selects.update(e.id, (value) => false),
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height - 150,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: DataTable(
                      showCheckboxColumn: false,
                      border: const TableBorder(
                        top: BorderSide(width: 1),
                        left: BorderSide(width: 1),
                        right: BorderSide(width: 1),
                        bottom: BorderSide(width: 1),
                        horizontalInside: BorderSide(width: 1),
                        verticalInside: BorderSide(width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      columns: const [
                        DataColumn(label: Text('İsim')),
                        DataColumn(label: Text('Gram')),
                        DataColumn(label: Text('Karat')),
                        DataColumn(label: Text('Maliyet')),
                      ],
                      rows: ProductDbHelper()
                          .products
                          .map(
                            (e) => DataRow(
                              //key: ValueKey(e.id),
                              //selected: selects[e.id]!,
                              cells: [
                                DataCell(Text(e.name!)),
                                DataCell(Text(e.gram.toString())),
                                DataCell(Text(e.carat.intDefinition.toString())),
                                DataCell(Text(e.costPrice.toString())),
                              ],
                              onSelectChanged: (selected) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ProductScreen(product: e)),
                                    (route) => false);
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 1050,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/product-add-screen', (route) => false);
                  },
                  child: const Text('Ürün Ekle'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
