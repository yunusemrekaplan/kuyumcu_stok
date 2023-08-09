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
  @override
  void initState() {
    //ProductDbHelper().queryAllRows().then((value) => print(value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
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
                      columnSpacing: 20,
                      horizontalMargin: 10,
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
                      columns: [
                        DataColumn(
                          label: Container(
                            width: width * .1,
                            child: const Text(
                              'İsim',
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: width * .1,
                            child: const Text(
                              'Gram',
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: width * .1,
                            child: const Text(
                              'Karat',
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: width * .1,
                            child: const Text(
                              'Saflık Oranı',
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: width * .1,
                            child: const Text(
                              'İşçilik',
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: width * .1,
                            child: const Text(
                              'Maliyet',
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: width * .1,
                            child: const Text(''),
                          ),
                        ),
                      ],
                      rows: ProductDbHelper()
                          .products
                          .map(
                            (e) => DataRow(
                              //key: ValueKey(e.id),
                              //selected: selects[e.id]!,
                              cells: [
                                DataCell(Text(
                                  e.name!,
                                  style: const TextStyle(fontSize: 20),
                                )),
                                DataCell(Text(
                                  e.gram.toString(),
                                  style: const TextStyle(fontSize: 20),
                                )),
                                DataCell(Text(
                                  e.carat.intDefinition.toString(),
                                  style: const TextStyle(fontSize: 20),
                                )),
                                DataCell(Text(
                                  e.purityRate.toString(),
                                  style: const TextStyle(fontSize: 20),
                                )),
                                DataCell(Text(
                                  e.laborCost.toString(),
                                  style: const TextStyle(fontSize: 20),
                                )),
                                DataCell(Text(
                                  e.costPrice.toString(),
                                  style: const TextStyle(fontSize: 20),
                                )),
                                DataCell(Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          ProductDbHelper().products.remove(e);
                                          ProductDbHelper().delete(e.id);
                                        });
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          ProductDbHelper().products.remove(e);
                                          ProductDbHelper().delete(e.id);
                                        });
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ],
                                )),
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
            //width: 1050,
            height: 70,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/product-add-screen', (route) => false);
                    },
                    child: const Text(
                      'Ürün Ekle',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
