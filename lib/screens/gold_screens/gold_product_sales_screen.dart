import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/data/product_sale_db_helper.dart';
import 'package:kuyumcu_stok/localization/converters.dart';
import 'package:kuyumcu_stok/localization/output_formatters.dart';
import 'package:kuyumcu_stok/model/gold_product.dart';
import 'package:kuyumcu_stok/model/product_sale.dart';
import 'package:kuyumcu_stok/styles/data_table_styles.dart';
import 'package:kuyumcu_stok/widgets/app_bar.dart';
import 'package:kuyumcu_stok/widgets/date_picker_row.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';
import 'package:intl/date_symbol_data_local.dart';

class GoldProductSalesScreen extends StatefulWidget {
  const GoldProductSalesScreen({super.key});

  @override
  State<GoldProductSalesScreen> createState() => _GoldProductSalesScreenState();
}

class _GoldProductSalesScreenState extends State<GoldProductSalesScreen> {
  late List<ProductSale> sales;
  late List<GoldProduct> products;

  DateTime timeRange = DateTime(DateTime.now().year, DateTime.now().month - 3);
  DateTime endTime = DateTime.now();
  late DateTime startTime;

  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  late DatePickerRow startDatePickerRow;
  late DatePickerRow endDatePickerRow;

  _GoldProductSalesScreenState() {
    sales = ProductSaleDbHelper().sales;
    products = GoldProductDbHelper().products;
    print(sales.length);
    initializeDateFormatting('tr_TR', null);
    startTime = timeRange;
    startDatePickerRow = DatePickerRow(
      label: 'Başlangıç Tarihi:',
      startTime: startTime,
      endTime: endTime,
      initialTime: startTime,
    );
    endDatePickerRow = DatePickerRow(
      label: 'Bitiş Tarihi:',
      startTime: startTime,
      endTime: endTime,
      initialTime: endTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    final verticalScrollController = ScrollController();

    return Scaffold(
      appBar: appBar,
      drawer: const MyDrawer(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        //color: Colors.white,
        child: Column(
          children: [
            buildTableHeightPaddingBox(),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: startDatePickerRow,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: endDatePickerRow,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: ElevatedButton(
                    child: const Text('Tarihi Onayla'),
                    onPressed: () {
                      setState(() {
                        startTime = startDatePickerRow.initialTime;
                        endTime = endDatePickerRow.initialTime;
                        sales;
                      });
                    },
                  ),
                ),
              ],
            ),
            buildTableHeightPaddingBox(),
            Container(
              //color: Colors.white,
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
                          //headingRowColor: DataTableStyles.buildHeadingRowColor(),
                          sortColumnIndex: _sortColumnIndex,
                          sortAscending: _sortAscending,
                          columnSpacing: 35,
                          horizontalMargin: 10,
                          showCheckboxColumn: false,
                          border: DataTableStyles.buildTableBorder(),
                          columns: buildDataColumns(),
                          rows: buildRowList().toList(),
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
    );
  }

  List<DataColumn> buildDataColumns() {
    return [
      buildSoldDateDataColumn(),
      buildNameDataColumn(),
      buildPieceDataColumn(),
      buildCostPriceDataColumn(),
      buildSoldPriceDataColumn(),
      buildSoldGramDataColumn(),
      buildEarnedProfitTLDataColumn(),
      buildEarnedProfitGramDataColumn(),
    ];
  }

  DataColumn buildSoldDateDataColumn() {
    return DataColumn(
      label: const Text(
        'Satış Tarihi',
        style: TextStyle(fontSize: 20),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  DataColumn buildNameDataColumn() {
    return DataColumn(
      label: const Text(
        'İsim',
        style: TextStyle(fontSize: 20),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  DataColumn buildPieceDataColumn() {
    return DataColumn(
      label: const Text(
        'Satılan Adet',
        style: TextStyle(fontSize: 20),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  DataColumn buildCostPriceDataColumn() {
    return DataColumn(
      label: const Text(
        'Maliyet Fiyat',
        style: TextStyle(fontSize: 20),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  DataColumn buildSoldPriceDataColumn() {
    return DataColumn(
      label: const Text(
        'Satılan Fiyat',
        style: TextStyle(fontSize: 20),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  DataColumn buildSoldGramDataColumn() {
    return DataColumn(
      label: const Text(
        'Satılan Gram',
        style: TextStyle(fontSize: 20),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  DataColumn buildEarnedProfitTLDataColumn() {
    return DataColumn(
      label: const Text(
        'Edilen Kar(TL)',
        style: TextStyle(fontSize: 20),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  DataColumn buildEarnedProfitGramDataColumn() {
    return DataColumn(
      label: const Text(
        'Edilen Kar(Gram)',
        style: TextStyle(fontSize: 20),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  Iterable<DataRow> buildRowList() {
    return sales
        .where((element) =>
    (element.soldDate.compareTo(startTime) >= 0) &&
        (element.soldDate.compareTo(endTime) <= 0))
        .map(
          (e) => DataRow(
        color: DataTableStyles.buildDataRowColor(),
        cells: buildDataCells(e),
        onSelectChanged: (selected) {},
      ),
    ).toList();
  }

  List<DataCell> buildDataCells(ProductSale e) {
    return [
      buildSoldDateDataCell(e),
      buildNameDataCell(e),
      buildPieceDataCell(e),
      buildCostPriceDataCell(e),
      buildSoldPriceDataCell(e),
      buildSoldGramDataCell(e),
      buildEarnedProfitTLDataCell(e),
      buildEarnedProfitGramDataCell(e),
    ];
  }

  DataCell buildSoldDateDataCell(ProductSale e) {
    return DataCell(Text(
      Converters.dateToTr(e.soldDate),
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildNameDataCell(ProductSale e) {
    return DataCell(Text(
      e.product['name'],
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildPieceDataCell(ProductSale e) {
    return DataCell(Text(
      e.piece.toString(),
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildCostPriceDataCell(ProductSale e) {
    return DataCell(Text(
      OutputFormatters.buildNumberFormat0f(e.costPrice),
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildSoldPriceDataCell(ProductSale e) {
    return DataCell(Text(
      OutputFormatters.buildNumberFormat0f(e.soldPrice),
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildSoldGramDataCell(ProductSale e) {
    return DataCell(Text(
      OutputFormatters.buildNumberFormat3f(e.soldGram),
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildEarnedProfitTLDataCell(ProductSale e) {
    return DataCell(Text(
      OutputFormatters.buildNumberFormat0f(e.earnedProfitTL),
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildEarnedProfitGramDataCell(ProductSale e) {
    return DataCell(Text(
      OutputFormatters.buildNumberFormat3f(e.earnedProfitGram),
      style: const TextStyle(fontSize: 20),
    ));
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

  void _sortData(int columnIndex, bool ascending) {
    /*setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      if (columnIndex == 0) {
        if (ascending) {
          sales.sort((a, b) => a.soldDate.compareTo(b.soldDate));
        } else {
          sales.sort((a, b) => b.soldDate.compareTo(a.soldDate));
        }
      } else if (columnIndex == 1) {
        if (ascending) {
          sales.sort((a, b) => a.name.compareTo(b.name));
        } else {
          sales.sort((a, b) => b.name.compareTo(a.name));
        }
      } else if (columnIndex == 2) {
        if (ascending) {
          sales.sort((a, b) => a.costPrice.compareTo(b.costPrice));
        } else {
          sales.sort((a, b) => b.costPrice.compareTo(a.costPrice));
        }
      } else if (columnIndex == 3) {
        if (ascending) {
          sales.sort((a, b) => a.soldPrice.compareTo(b.soldPrice));
        } else {
          sales.sort((a, b) => b.soldPrice.compareTo(a.soldPrice));
        }
      } else if (columnIndex == 4) {
        if (ascending) {
          sales.sort((a, b) => a.earnedProfit.compareTo(b.earnedProfit));
        } else {
          sales.sort((a, b) => b.earnedProfit.compareTo(a.earnedProfit));
        }
      }
    });*/
  }
}
