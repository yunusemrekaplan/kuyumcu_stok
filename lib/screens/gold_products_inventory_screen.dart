import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/enum_carat.dart';
import 'package:kuyumcu_stok/models/gold_product.dart';
import 'package:kuyumcu_stok/screens/gold_product_edit_screen.dart';
import 'package:kuyumcu_stok/styles/button_styles.dart';
import 'package:kuyumcu_stok/styles/decoration_styles.dart';
import 'package:kuyumcu_stok/styles/text_styles.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';

class GoldProductsInventoryScreen extends StatefulWidget {
  const GoldProductsInventoryScreen({super.key});

  @override
  State<GoldProductsInventoryScreen> createState() =>
      _GoldProductsInventoryScreenState();
}

class _GoldProductsInventoryScreenState
    extends State<GoldProductsInventoryScreen> {
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
              buildTableHeightPaddingBox(),
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
                        buildTableWidthPaddingBox(),
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
                            columns: buildDataColumns(width),
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
                                    cells: buildDataCells(e, context),
                                    onSelectChanged: (selected) {},
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        buildTableWidthPaddingBox(),
                      ],
                    ),
                  ),
                ),
              ),
              buildTableHeightPaddingBox(),
              buildProductAddButton(context),
            ],
          ),
        ),
      ),
    );
  }

  List<DataColumn> buildDataColumns(double width) {
    return [
      buildNameDataColumn(width),
      buildGramDataColumn(width),
      buildCaratDataColumn(width),
      buildPurityRateDataColumn(width),
      buildLaborCostDataColumn(width),
      buildCostDataColumn(width),
      buildActionsDataColumn(width),
    ];
  }

  DataColumn buildNameDataColumn(double width) {
    return DataColumn(
      label: SizedBox(
        width: width * .1,
        child: const Text(
          'İsim',
          style: TextStyle(fontSize: 22),
        ),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  DataColumn buildGramDataColumn(double width) {
    return DataColumn(
      label: SizedBox(
        width: width * .1,
        child: const Text(
          'Gram',
          style: TextStyle(fontSize: 22),
        ),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  DataColumn buildCaratDataColumn(double width) {
    return DataColumn(
      label: SizedBox(
        width: width * .1,
        child: const Text(
          'Karat',
          style: TextStyle(fontSize: 22),
        ),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  DataColumn buildPurityRateDataColumn(double width) {
    return DataColumn(
      label: SizedBox(
        width: width * .1,
        child: const Text(
          'Saflık Oranı',
          style: TextStyle(fontSize: 22),
        ),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  DataColumn buildLaborCostDataColumn(double width) {
    return DataColumn(
      label: SizedBox(
        width: width * .1,
        child: const Text(
          'İşçilik',
          style: TextStyle(fontSize: 22),
        ),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  DataColumn buildCostDataColumn(double width) {
    return DataColumn(
      label: SizedBox(
        width: width * .1,
        child: const Text(
          'Maliyet',
          style: TextStyle(fontSize: 22),
        ),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  DataColumn buildActionsDataColumn(double width) {
    return DataColumn(
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
                products = GoldProductDbHelper()
                    .products
                    .where(
                      (e) => e.isSold == 0,
                    )
                    .toList();
              });
            }
            setState(() {
              products = GoldProductDbHelper()
                  .products
                  .where(
                    (e) => e.isSold == 0,
                  )
                  .toList();
              print(value);
              products = products
                  .where(
                    (e) => e.name.toLowerCase().contains(value.toLowerCase()),
                  )
                  .toList();
            });
          },
        ),
      ),
    );
  }

  SizedBox buildTableWidthPaddingBox() {
    return const SizedBox(
      width: 30,
    );
  }

  SizedBox buildTableHeightPaddingBox() {
    return const SizedBox(
      height: 30,
    );
  }

  Container buildProductAddButton(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 10),
            child: ElevatedButton(
              style: ButtonStyles.buildBasicButtonStyle(),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/gold-product-add-screen', (route) => false);
              },
              child: Text(
                'Ürün Ekle',
                style: TextStyles.buildButtonTextStyle(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DataCell> buildDataCells(GoldProduct e, BuildContext context) {
    return [
      buildNameDataCell(e),
      buildGramDataCell(e),
      buildCaratDataCell(e),
      buildPurityRateDataCell(e),
      buildLaborCostDataCell(e),
      buildCostDataCell(e),
      buildActionsDataCell(context, e),
    ];
  }

  DataCell buildNameDataCell(GoldProduct e) {
    return DataCell(Text(
      e.name,
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildGramDataCell(GoldProduct e) {
    return DataCell(Text(
      NumberFormat('#,##0.0', 'tr_TR').format(e.gram),
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildCaratDataCell(GoldProduct e) {
    return DataCell(Text(
      e.carat.intDefinition.toString(),
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildPurityRateDataCell(GoldProduct e) {
    return DataCell(Text(
      NumberFormat('#,##0.0', 'tr_TR').format(e.purityRate),
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildLaborCostDataCell(GoldProduct e) {
    return DataCell(Text(
      NumberFormat('#,##0.0', 'tr_TR').format(e.laborCost),
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildCostDataCell(GoldProduct e) {
    return DataCell(Text(
      NumberFormat('#,##0.0', 'tr_TR').format(e.cost),
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildActionsDataCell(BuildContext context, GoldProduct e) {
    return DataCell(
      Row(
        children: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Ürünü silmek istediğinize emin misiniz?'),
                  actions: [
                    TextButton(
                      child: const Text(
                        'Evet',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        setState(
                          () {
                            GoldProductDbHelper().products.remove(e);
                            GoldProductDbHelper().delete(e.id);
                          },
                        );
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text(
                        'Hayır',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
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
                    builder: (BuildContext context) =>
                        GoldProductEditScreen(product: e),
                  ),
                  (route) => false);
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.print),
          ),
        ],
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
