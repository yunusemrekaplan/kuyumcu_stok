import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/data/product_entry_db_helper.dart';
import 'package:kuyumcu_stok/enum/carat.dart';
import 'package:kuyumcu_stok/extension/carat_extension.dart';
import 'package:kuyumcu_stok/models/gold_product.dart';
import 'package:kuyumcu_stok/screens/gold_screens/gold_product_edit_screen.dart';
import 'package:kuyumcu_stok/styles/button_styles.dart';
import 'package:kuyumcu_stok/styles/data_table_styles.dart';
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
    final verticalScrollController = ScrollController();
    //final horizontalScrollController = ScrollController();

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
                          rows: buildRowList(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            buildTableHeightPaddingBox(),
            Expanded(child: buildStockAddButton(context)),
          ],
        ),
      ),
    );
  }

  List<DataColumn> buildDataColumns(double width) {
    return [
      buildBarcodeDataColumn(width),
      buildPieceDataColumn(width),
      buildNameDataColumn(width),
      buildCaratDataColumn(width),
      buildPurityRateDataColumn(width),
      buildLaborCostDataColumn(width),
      buildGramDataColumn(width),
      buildSalesGramDataColumn(width),
      buildCostDataColumn(width),
      buildActionsDataColumn(width),
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

  DataColumn buildPieceDataColumn(double width) {
    return DataColumn(
      label: const SizedBox(
        //width: width * .22,
        child: Text(
          'Adet',
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

  DataColumn buildSalesGramDataColumn(double width) {
    return DataColumn(
      label: const SizedBox(
        //width: width * .13,
        child: Text(
          'Satış Gramı',
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

  List<DataRow> buildRowList(BuildContext context) {
    List<DataRow> res = products
        .where(
          (e) => e.piece > 0,
        )
        .map(
          (e) => DataRow(
            color: DataTableStyles.buildDataRowColor(),
            cells: buildDataCells(e, context),
            onSelectChanged: (selected) {},
          ),
        )
        .toList();
    /*res.add(DataRow(cells: [
       DataCell(Text('')),
       DataCell(Text('')),
       DataCell(Text('')),
       DataCell(Text('')),
       DataCell(Text('')),
       DataCell(Text('')),
       DataCell(Text('')),
       DataCell(Text('')),
       DataCell(Text('')),
       DataCell(Text('')),
     ]));*/
    return res;
  }

  List<DataCell> buildDataCells(GoldProduct e, BuildContext context) {
    return [
      buildBarkodDataCell(e),
      buildPieceDataCell(e),
      buildNameDataCell(e),
      buildCaratDataCell(e),
      buildPurityRateDataCell(e),
      buildLaborCostDataCell(e),
      buildGramDataCell(e),
      buildSalesGramsDataCell(e),
      buildCostDataCell(e),
      buildActionsDataCell(context, e),
    ];
  }

  DataCell buildBarkodDataCell(GoldProduct e) {
    return DataCell(Text(
      e.barcodeText,
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildPieceDataCell(GoldProduct e) {
    return DataCell(Text(
      e.piece.toString(),
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildNameDataCell(GoldProduct e) {
    return DataCell(Text(
      e.name,
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
      e.purityRate.toString().replaceAll('.', ','),//NumberFormat('#,##0.0', 'tr_TR').format(e.purityRate),
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildLaborCostDataCell(GoldProduct e) {
    return DataCell(Text(
      e.laborCost.toString().replaceAll('.', ','),//NumberFormat('#,##0.0', 'tr_TR').format(e.laborCost),
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildGramDataCell(GoldProduct e) {
    return DataCell(Text(
      e.gram.toString().replaceAll('.', ','),//NumberFormat('#,##0.0', 'tr_TR').format(e.gram),
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildSalesGramsDataCell(GoldProduct e) {
    return DataCell(Text(
      e.salesGrams.toString().replaceAll('.', ','),//NumberFormat('#,##0.0', 'tr_TR').format(e.salesGrams),
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildCostDataCell(GoldProduct e) {
    return DataCell(Text(
        e.cost.toString().replaceAll('.', ','),//NumberFormat('#,##0.0', 'tr_TR').format(e.cost),
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildActionsDataCell(BuildContext context, GoldProduct e) {
    return DataCell(
      Row(
        children: [
          buildDeleteButton(context, e),
          buildEditButton(context, e),
          buildPrinterButton(),
          buildAddButton(),
        ],
      ),
    );
  }

  IconButton buildDeleteButton(BuildContext context, GoldProduct e) {
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

  IconButton buildEditButton(BuildContext context, GoldProduct e) {
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

  IconButton buildAddButton() {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.add_box_outlined),
      iconSize: 26,
    );
  }

  Container buildStockAddButton(BuildContext context) {
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
                'Stok Ekle',
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
          products.sort((a, b) => a.barcodeText.compareTo(b.barcodeText));
        } else {
          products.sort((a, b) => b.barcodeText.compareTo(a.barcodeText));
        }
      }
      else if (columnIndex == 1) {
        if (ascending) {
          products.sort((a, b) => a.piece.compareTo(b.piece));
        } else {
          products.sort((a, b) => b.piece.compareTo(a.piece));
        }
      }
      else if (columnIndex == 2) {
        if (ascending) {
          products.sort(
              (a, b) => a.name.compareTo(b.name));
        } else {
          products.sort(
              (a, b) => b.name.compareTo(a.name));
        }
      }
      else if (columnIndex == 3) {
        if (ascending) {
          products.sort((a, b) => a.carat.intDefinition.compareTo(b.carat.intDefinition));
        } else {
          products.sort((a, b) => b.carat.intDefinition.compareTo(a.carat.intDefinition));
        }
      }
      else if (columnIndex == 4) {
        if (ascending) {
          products.sort((a, b) => a.purityRate.compareTo(b.purityRate));
        } else {
          products.sort((a, b) => b.purityRate.compareTo(a.purityRate));
        }
      }
      else if (columnIndex == 5) {
        if (ascending) {
          products.sort((a, b) => a.laborCost.compareTo(b.laborCost));
        } else {
          products.sort((a, b) => b.laborCost.compareTo(a.laborCost));
        }
      }
      else if (columnIndex == 6) {
        if (ascending) {
          products.sort((a, b) => a.gram.compareTo(b.gram));
        } else {
          products.sort((a, b) => b.gram.compareTo(a.gram));
        }
      }
      else if (columnIndex == 7) {
        if (ascending) {
          products.sort((a, b) => a.salesGrams.compareTo(b.salesGrams));
        } else {
          products.sort((a, b) => b.salesGrams.compareTo(a.salesGrams));
        }
      }
      else if (columnIndex == 8) {
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
              (e) => e.piece > 0,
            )
            .toList();
      });
    }
    setState(() {
      products = GoldProductDbHelper()
          .products
          .where(
            (e) => e.piece > 0,
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
