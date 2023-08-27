import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/enum_carat.dart';
import 'package:kuyumcu_stok/models/stock_gold_product.dart';
import 'package:kuyumcu_stok/screens/gold_product_edit_screen.dart';
import 'package:kuyumcu_stok/styles/button_styles.dart';
import 'package:kuyumcu_stok/styles/data_table_styles.dart';
import 'package:kuyumcu_stok/styles/decoration_styles.dart';
import 'package:kuyumcu_stok/styles/text_styles.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';

class GoldProductsInventoryScreen extends StatefulWidget {
  const GoldProductsInventoryScreen({super.key});

  @override
  State<GoldProductsInventoryScreen> createState() =>
      _GoldProductsInventoryScreenState();
}

class _GoldProductsInventoryScreenState
    extends State<GoldProductsInventoryScreen> {
  late List<StockGoldProduct> products;
  late TextEditingController searchController;

  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  _GoldProductsInventoryScreenState() {
    products = GoldProductDbHelper().products;
    searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final verticalScrollController = ScrollController();
    final horizontalScrollController = ScrollController();

    final double width = MediaQuery.of(context).size.width - 60;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
      ),
      drawer: const MyDrawer(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          children: [
            buildTableHeightPaddingBox(),
            Container(
              color: Colors.white,
              width: double.infinity,
              height: MediaQuery.of(context).size.height - 170,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20.0),
                      child: SingleChildScrollView(
                        controller: verticalScrollController,
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          headingRowColor:
                              DataTableStyles.buildHeadingRowColor(),
                          sortColumnIndex: _sortColumnIndex,
                          sortAscending: _sortAscending,
                          columnSpacing: 35,
                          horizontalMargin: 10,
                          showCheckboxColumn: false,
                          border: DataTableStyles.buildTableBorder(),
                          columns: buildDataColumns(width),
                          rows: buildRowList(context).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            buildTableHeightPaddingBox(),
            Expanded(child: buildProductAddButton(context)),
          ],
        ),
      ),
    );
  }

  List<DataColumn> buildDataColumns(double width) {
    return [
      buildBarcodeDataColumn(width),
      buildNameDataColumn(width),
      buildGramDataColumn(width),
      buildCaratDataColumn(width),
      buildPurityRateDataColumn(width),
      buildLaborCostDataColumn(width),
      buildCostDataColumn(width),
      buildActionsDataColumn(width),
    ];
  }

  List<DataCell> buildDataCells(StockGoldProduct e, BuildContext context) {
    return [
      buildBarkodDataCell(e),
      buildNameDataCell(e),
      buildGramDataCell(e),
      buildCaratDataCell(e),
      buildPurityRateDataCell(e),
      buildLaborCostDataCell(e),
      buildCostDataCell(e),
      buildActionsDataCell(context, e),
    ];
  }

  DataColumn buildBarcodeDataColumn(double width) {
    return DataColumn(
      label: const SizedBox(
        //width: width * .22,
        child: Text(
          'Barkod',
          style: TextStyle(fontSize: 22),
        ),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  DataColumn buildNameDataColumn(double width) {
    return DataColumn(
      label: const SizedBox(
        //width: width * .22,
        child: Text(
          'Name',
          style: TextStyle(fontSize: 22),
        ),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  DataColumn buildGramDataColumn(double width) {
    return DataColumn(
      label: const SizedBox(
        //width: width * .13,
        child: Text(
          'Gram',
          style: TextStyle(fontSize: 22),
        ),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  DataColumn buildCaratDataColumn(double width) {
    return DataColumn(
      label: const SizedBox(
        //width: width * .13,
        child: Text(
          'Karat',
          style: TextStyle(fontSize: 22),
        ),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  DataColumn buildPurityRateDataColumn(double width) {
    return DataColumn(
      label: const SizedBox(
        //width: width * .13,
        child: Text(
          'Saflık',
          style: TextStyle(fontSize: 22),
        ),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  DataColumn buildLaborCostDataColumn(double width) {
    return DataColumn(
      label: const SizedBox(
        //width: width * .13,
        child: Text(
          'İşçilik',
          style: TextStyle(fontSize: 22),
        ),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  DataColumn buildCostDataColumn(double width) {
    return DataColumn(
      label: const SizedBox(
        //width: width * .13,
        child: Text(
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
        //width: width * .13,
        color: Colors.white,
        child: TextFormField(
          controller: searchController,
          style: const TextStyle(
            fontSize: 20,
            height: 1,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: '9784753492558',
            hintStyle: const TextStyle(
              fontSize: 20,
            ),
            contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
            constraints:
                DecorationStyles.buildBoxConstraints(const Size(180, 35)),
          ),
          onChanged: onSearch,
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

  Iterable<DataRow> buildRowList(BuildContext context) {
    return products
        .where(
          (e) => e.isSold == 0,
        )
        .map(
          (e) => DataRow(
            color: DataTableStyles.buildDataRowColor(),
            cells: buildDataCells(e, context),
            onSelectChanged: (selected) {},
          ),
        );
  }

  DataCell buildBarkodDataCell(StockGoldProduct e) {
    return DataCell(Text(
      e.barcodeText,
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildNameDataCell(StockGoldProduct e) {
    return DataCell(Text(
      e.name,
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildGramDataCell(StockGoldProduct e) {
    return DataCell(Text(
      NumberFormat('#,##0.0', 'tr_TR').format(e.gram),
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildCaratDataCell(StockGoldProduct e) {
    return DataCell(Text(
      e.carat.intDefinition.toString(),
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildPurityRateDataCell(StockGoldProduct e) {
    return DataCell(Text(
      NumberFormat('#,##0.0', 'tr_TR').format(e.purityRate),
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildLaborCostDataCell(StockGoldProduct e) {
    return DataCell(Text(
      NumberFormat('#,##0.0', 'tr_TR').format(e.laborCost),
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildCostDataCell(StockGoldProduct e) {
    return DataCell(Text(
      NumberFormat('#,##0.0', 'tr_TR').format(e.cost),
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildActionsDataCell(BuildContext context, StockGoldProduct e) {
    return DataCell(
      Row(
        children: [
          buildDeleteButton(context, e),
          buildEditButton(context, e),
          buildPrinterButton(),
        ],
      ),
    );
  }

  IconButton buildDeleteButton(BuildContext context, StockGoldProduct e) {
    return IconButton(
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
      color: Colors.red[600],
      iconSize: 26,
    );
  }

  IconButton buildEditButton(BuildContext context, StockGoldProduct e) {
    return IconButton(
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
      iconSize: 26,
    );
  }

  IconButton buildPrinterButton() {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.print),
      iconSize: 26,
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

  void onSearch(value) {
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
      //print(value);
      products = products
          .where(
            (e) => e.barcodeText.contains(value),
          )
          .toList();
    });
  }
}
