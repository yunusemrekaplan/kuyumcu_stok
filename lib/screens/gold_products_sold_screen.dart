import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/models/gold_product.dart';
import 'package:kuyumcu_stok/styles/data_table_styles.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';
import 'package:intl/date_symbol_data_local.dart';

class GoldProductsSoldScreen extends StatefulWidget {
  const GoldProductsSoldScreen({super.key});

  @override
  State<GoldProductsSoldScreen> createState() => _GoldProductsSoldScreenState();
}

class _GoldProductsSoldScreenState extends State<GoldProductsSoldScreen> {
  late List<GoldProduct> products;

  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  _GoldProductsSoldScreenState() {
    products = GoldProductDbHelper().products;
    initializeDateFormatting('tr_TR', null);
  }

  @override
  Widget build(BuildContext context) {
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
            Expanded(
              child: Container(
                color: Colors.white,
                width: double.infinity,
                height: MediaQuery.of(context).size.height - 170,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTableWidthPaddingBox(),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        child: DataTable(
                          headingRowColor:
                              DataTableStyles.buildHeadingRowColor(),
                          sortColumnIndex: _sortColumnIndex,
                          sortAscending: _sortAscending,
                          columnSpacing: 20,
                          horizontalMargin: 10,
                          showCheckboxColumn: false,
                          border: DataTableStyles.buildTableBorder(),
                          columns: buildDataColumns(width),
                          rows: buildRowList().toList(),
                        ),
                      ),
                    ),
                    buildTableWidthPaddingBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DataColumn> buildDataColumns(double width) {
    return [
      buildSoldDateDataColumn(width),
      buildNameDataColumn(width),
      buildCostPriceDataColumn(width),
      buildSoldPriceDataColumn(width),
      buildEarnedProfitDataColumn(width),
    ];
  }

  DataColumn buildSoldDateDataColumn(double width) {
    return DataColumn(
      label: SizedBox(
        width: width * .09,
        child: const Text(
          'Satış Tarihi',
          style: TextStyle(fontSize: 20),
        ),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  DataColumn buildNameDataColumn(double width) {
    return DataColumn(
      label: SizedBox(
        width: width * .1,
        child: const Text(
          'İsim',
          style: TextStyle(fontSize: 20),
        ),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  DataColumn buildCostPriceDataColumn(double width) {
    return DataColumn(
      label: SizedBox(
        width: width * .11,
        child: const Text(
          'Maliyet Fiyat',
          style: TextStyle(fontSize: 20),
        ),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  DataColumn buildSoldPriceDataColumn(double width) {
    return DataColumn(
      label: SizedBox(
        width: width * .1,
        child: const Text(
          'Satılan Fiyat',
          style: TextStyle(fontSize: 20),
        ),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  DataColumn buildEarnedProfitDataColumn(double width) {
    return DataColumn(
      label: SizedBox(
        width: width * .05,
        child: const Text(
          'Kar',
          style: TextStyle(fontSize: 20),
        ),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
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

  Iterable<DataRow> buildRowList() {
    return products
        .where(
          (e) => e.isSold == 1,
    )
        .map(
          (e) => DataRow(
        color: DataTableStyles.buildDataRowColor(),
        cells: buildDataCells(e),
        onSelectChanged: (selected) {},
      ),
    );
  }

  List<DataCell> buildDataCells(GoldProduct e) {
    return [
      buildSoldDateDataCell(e),
      buildNameDataCell(e),
      buildCostPriceDataCell(e),
      buildSoldPriceDataCell(e),
      buildEarnedProfitDataCell(e),
    ];
  }

  DataCell buildSoldDateDataCell(GoldProduct e) {
    return DataCell(Text(
      '${DateFormat.yMd('tr-Tr').format(e.soldDate!)}  ${DateFormat.Hm().format(e.soldDate!)}',
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildNameDataCell(GoldProduct e) {
    return DataCell(Text(
      e.name,
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildCostPriceDataCell(GoldProduct e) {
    return DataCell(Text(
      NumberFormat('#,##0.0', 'tr_TR')
          .format(e.costPrice), //e.costPrice.toStringAsFixed(0),
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildSoldPriceDataCell(GoldProduct e) {
    return DataCell(Text(
      NumberFormat('#,##0.0', 'tr_TR').format(e.soldPrice),
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildEarnedProfitDataCell(GoldProduct e) {
    return DataCell(Text(
      NumberFormat('#,##0.0', 'tr_TR').format(e.earnedProfit),
      style: const TextStyle(fontSize: 20),
    ));
  }

  void _sortData(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      if (columnIndex == 0) {
        if (ascending) {
          products.sort((a, b) => a.soldDate!.compareTo(b.soldDate!));
        } else {
          products.sort((a, b) => b.soldDate!.compareTo(a.soldDate!));
        }
      } else if (columnIndex == 1) {
        if (ascending) {
          products.sort((a, b) => a.name.compareTo(b.name));
        } else {
          products.sort((a, b) => b.name.compareTo(a.name));
        }
      } else if (columnIndex == 2) {
        if (ascending) {
          products.sort((a, b) => a.costPrice.compareTo(b.costPrice));
        } else {
          products.sort((a, b) => b.costPrice.compareTo(a.costPrice));
        }
      } else if (columnIndex == 3) {
        if (ascending) {
          products.sort((a, b) => a.soldPrice.compareTo(b.soldPrice));
        } else {
          products.sort((a, b) => b.soldPrice.compareTo(a.soldPrice));
        }
      } else if (columnIndex == 4) {
        if (ascending) {
          products.sort((a, b) => a.earnedProfit.compareTo(b.earnedProfit));
        } else {
          products.sort((a, b) => b.earnedProfit.compareTo(a.earnedProfit));
        }
      }
    });
  }
}
