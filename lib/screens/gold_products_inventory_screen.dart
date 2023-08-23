import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/enum_carat.dart';
import 'package:kuyumcu_stok/models/gold_product.dart';
import 'package:kuyumcu_stok/screens/gold_product_edit_screen.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';
import 'package:kuyumcu_stok/widgets/styles/decoration_styles.dart';

class GoldProductsInventoryScreen extends StatefulWidget {
  const GoldProductsInventoryScreen({super.key});

  @override
  State<GoldProductsInventoryScreen> createState() => _GoldProductsInventoryScreenState();
}

class _GoldProductsInventoryScreenState extends State<GoldProductsInventoryScreen> {
  late List<GoldProduct> products;
  late TextEditingController searchController;

  int _sortColumnIndex = 0;
  bool _sortAscending = true;



  _GoldProductsInventoryScreenState() {
    products = GoldProductDbHelper().products;
    searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
      ),
      drawer: const MyDrawer(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                height: 25,
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height - 170,
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
                            headingRowColor:
                                MaterialStateProperty.resolveWith((states) {
                              return Colors.grey[400];
                            }),
                            sortColumnIndex: _sortColumnIndex,
                            sortAscending: _sortAscending,
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
                              //borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            columns: [
                              DataColumn(
                                label: SizedBox(
                                  width: width * .1,
                                  child: const Text(
                                    'İsim',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                                onSort: (columnIndex, ascending) =>
                                    _sortData(columnIndex, ascending),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: width * .1,
                                  child: const Text(
                                    'Gram',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                                onSort: (columnIndex, ascending) =>
                                    _sortData(columnIndex, ascending),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: width * .1,
                                  child: const Text(
                                    'Karat',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                                onSort: (columnIndex, ascending) =>
                                    _sortData(columnIndex, ascending),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: width * .1,
                                  child: const Text(
                                    'Saflık Oranı',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                                onSort: (columnIndex, ascending) =>
                                    _sortData(columnIndex, ascending),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: width * .1,
                                  child: const Text(
                                    'İşçilik',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                                onSort: (columnIndex, ascending) =>
                                    _sortData(columnIndex, ascending),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: width * .1,
                                  child: const Text(
                                    'Maliyet',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                                onSort: (columnIndex, ascending) =>
                                    _sortData(columnIndex, ascending),
                              ),
                              DataColumn(
                                label: Container(
                                  width: width * .12,
                                  color: Colors.white,
                                  child: TextFormField(
                                    controller: searchController,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      height: 1,
                                      color: Colors.black,
                                    ),
                                    decoration: DecorationStyles.buildInputDecoration(const Size(100, 35)),
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        setState(() {
                                          products = GoldProductDbHelper().products
                                              .where(
                                                (e) => e.isSold == 0,
                                          ).toList();
                                        });
                                      }
                                      setState(() {
                                        products = GoldProductDbHelper().products
                                            .where(
                                              (e) => e.isSold == 0,
                                        ).toList();
                                        print(value);
                                        products = products
                                            .where(
                                              (e) => e.name.toLowerCase().contains(value.toLowerCase()),
                                        ).toList();
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                            rows: products
                                .where(
                                  (e) => e.isSold == 0,
                                )
                                .map(
                                  (e) => DataRow(
                                    color: MaterialStateProperty.resolveWith<
                                        Color?>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.hovered)) {
                                          return Colors.grey[400];
                                        }
                                        return null;
                                      },
                                    ),
                                    cells: [
                                      DataCell(Text(
                                        e.name,
                                        style: const TextStyle(fontSize: 20),
                                      )),
                                      DataCell(Text(
                                          NumberFormat('#,##0.0', 'tr_TR').format(e.gram),
                                        style: const TextStyle(fontSize: 20),
                                      )),
                                      DataCell(Text(
                                        e.carat.intDefinition.toString(),
                                        style: const TextStyle(fontSize: 20),
                                      )),
                                      DataCell(Text(
                                       NumberFormat('#,##0.0', 'tr_TR').format(e.purityRate),
                                        style: const TextStyle(fontSize: 20),
                                      )),
                                      DataCell(Text(
                                          NumberFormat('#,##0.0', 'tr_TR').format(e.laborCost),
                                        style: const TextStyle(fontSize: 20),
                                      )),
                                      DataCell(Text(
                                          NumberFormat('#,##0.0', 'tr_TR').format(e.cost),
                                        style: const TextStyle(fontSize: 20),
                                      )),
                                      DataCell(
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                setState(
                                                  () {
                                                    GoldProductDbHelper()
                                                        .products
                                                        .remove(e);
                                                    GoldProductDbHelper()
                                                        .delete(e.id);
                                                  },
                                                );
                                              },
                                              icon: const Icon(Icons.delete),
                                              color: Colors.red[800],
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          GoldProductEditScreen(
                                                              product: e),
                                                    ),
                                                    (route) => false);
                                              },
                                              icon: const Icon(Icons.edit),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    onSelectChanged: (selected) {},
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
              ),
              Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, bottom: 15, top: 15),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return Colors.green;
                              }
                              return Colors.grey[600];
                            },
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(context,
                              '/gold-product-add-screen', (route) => false);
                        },
                        child: const Text(
                          'Ürün Ekle',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sortData(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      if (columnIndex == 0) {
        if (ascending) {
          products.sort((a, b) => a.name.compareTo(b.name));
        } else {
          products.sort((a, b) => b.name.compareTo(a.name));
        }
      } else if (columnIndex == 1) {
        if (ascending) {
          products.sort((a, b) => a.gram.compareTo(b.gram));
        } else {
          products.sort((a, b) => b.gram.compareTo(a.gram));
        }
      } else if (columnIndex == 2) {
        if (ascending) {
          products.sort(
              (a, b) => a.carat.intDefinition.compareTo(b.carat.intDefinition));
        } else {
          products.sort(
              (a, b) => b.carat.intDefinition.compareTo(a.carat.intDefinition));
        }
      } else if (columnIndex == 3) {
        if (ascending) {
          products.sort((a, b) => a.purityRate.compareTo(b.purityRate));
        } else {
          products.sort((a, b) => b.purityRate.compareTo(a.purityRate));
        }
      } else if (columnIndex == 4) {
        if (ascending) {
          products.sort((a, b) => a.laborCost.compareTo(b.laborCost));
        } else {
          products.sort((a, b) => b.laborCost.compareTo(a.laborCost));
        }
      } else if (columnIndex == 5) {
        if (ascending) {
          products.sort((a, b) => a.cost.compareTo(b.cost));
        } else {
          products.sort((a, b) => b.cost.compareTo(a.cost));
        }
      }
    });
  }
}
