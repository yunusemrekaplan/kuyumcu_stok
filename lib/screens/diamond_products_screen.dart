import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/data/diamond_product_db_helper.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';

class DiamondProductsScreen extends StatefulWidget {
  const DiamondProductsScreen({super.key});

  @override
  State<DiamondProductsScreen> createState() => _DiamondProductsScreenState();
}

class _DiamondProductsScreenState extends State<DiamondProductsScreen> {
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
            height: MediaQuery.of(context).size.height - 145,
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
                              'Ücret',
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
                      rows: DiamondProductDbHelper()
                          .products
                          .map(
                            (e) => DataRow(
                              cells: [
                                DataCell(Text(
                                  e.name.toString(),
                                  style: const TextStyle(fontSize: 20),
                                )),
                                DataCell(Text(
                                  e.gram.toString(),
                                  style: const TextStyle(fontSize: 20),
                                )),
                                DataCell(Text(
                                  e.price.toString(),
                                  style: const TextStyle(fontSize: 20),
                                )),
                                DataCell(Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          DiamondProductDbHelper()
                                              .products
                                              .remove(e);
                                          DiamondProductDbHelper().delete(e.id);
                                        });
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          DiamondProductDbHelper()
                                              .products
                                              .remove(e);
                                          DiamondProductDbHelper().delete(e.id);
                                        });
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ],
                                )),
                              ],
                              /*onSelectChanged: (selected) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ProductDiamondScreen(product: e)),
                                  (route) => false);
                        },*/
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
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context,
                        '/diamond-product-add-screen', (route) => false);
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
        ],
      ),
    );
  }
}
