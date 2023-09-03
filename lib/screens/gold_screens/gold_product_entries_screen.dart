import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/data/product_entry_db_helper.dart';
import 'package:kuyumcu_stok/localization/converters.dart';
import 'package:kuyumcu_stok/model/gold_product.dart';
import 'package:kuyumcu_stok/model/product_entry.dart';
import 'package:kuyumcu_stok/styles/data_table_styles.dart';
import 'package:kuyumcu_stok/widgets/app_bar.dart';
import 'package:kuyumcu_stok/widgets/date_picker_row.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';

class GoldProductEntriesScreen extends StatefulWidget {
  const GoldProductEntriesScreen({super.key});

  @override
  State<GoldProductEntriesScreen> createState() =>
      _GoldProductEntriesScreenState();
}

class _GoldProductEntriesScreenState extends State<GoldProductEntriesScreen> {
  late List<ProductEntry> entries;
  late List<GoldProduct> products;

  DateTime timeRange = DateTime(DateTime.now().year, DateTime.now().month - 3);
  DateTime endTime = DateTime.now();
  late DateTime startTime;

  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  late DatePickerRow startDatePickerRow;
  late DatePickerRow endDatePickerRow;

  _GoldProductEntriesScreenState() {
    entries = ProductEntryDbHelper().entries;
    products = GoldProductDbHelper().products;
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
        color: Colors.white,
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
                        entries;
                      });
                    },
                  ),
                ),
              ],
            ),
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
                          columns: buildDataColumns(),
                          rows: buildRowList(),
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
      buildEntryDateDataColumn(),
      buildNameDataColumn(),
      buildPieceDataColumn(),
    ];
  }

  List<DataRow> buildRowList() {
    return entries
        .where((element) =>
            (element.enteredDate.compareTo(startTime) >= 0) &&
            (element.enteredDate.compareTo(endTime) <= 0))
        .map(
          (e) => DataRow(
            color: DataTableStyles.buildDataRowColor(),
            cells: buildDataCells(e),
            onSelectChanged: (selected) {},
          ),
        )
        .toList();
  }

  List<DataCell> buildDataCells(ProductEntry e) {
    return [
      buildEntryDateDataCell(e),
      buildNameDataCell(e),
      buildPieceDataCell(e),
    ];
  }

  DataColumn buildEntryDateDataColumn() {
    return DataColumn(
      label: const Text(
        'Giriş Tarihi',
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
        'Girilen Adet',
        style: TextStyle(fontSize: 20),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  DataCell buildEntryDateDataCell(ProductEntry e) {
    return DataCell(Text(
      Converters.dateToTr(e.enteredDate),
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildNameDataCell(ProductEntry e) {
    String name = '';
    products.where((element) => element.id == e.productId).forEach((element) {
      name = element.name;
    });
    return DataCell(Text(
      name,
      style: const TextStyle(fontSize: 20),
    ));
  }

  DataCell buildPieceDataCell(ProductEntry e) {
    return DataCell(Text(
      e.piece.toString(),
      style: const TextStyle(fontSize: 20),
    ));
  }

  SizedBox buildTableHeightPaddingBox() {
    return const SizedBox(
      height: 20,
    );
  }

  void _sortData(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      if (columnIndex == 0) {
        if (ascending) {
          entries.sort((a, b) => a.enteredDate.compareTo(b.enteredDate));
        } else {
          entries.sort((a, b) => b.enteredDate.compareTo(a.enteredDate));
        }
      }
      else if (columnIndex == 1) {
        if (ascending) {
          //a.name.compareTo(b.name)
          entries.sort((a, b) => products
              .where((element) => element.id == a.productId)
              .map((e) => e.name)
              .toString()
              .compareTo(products
                  .where((element) => element.id == b.productId)
                  .map((e) => e.name)
                  .toString()));
        }
        else {
          entries.sort((a, b) => products
              .where((element) => element.id == b.productId)
              .map((e) => e.name)
              .toString()
              .compareTo(products
                  .where((element) => element.id == a.productId)
                  .map((e) => e.name)
                  .toString()));
        }
      }
      else if (columnIndex == 2) {
        if (ascending) {
          entries.sort((a, b) => a.piece.compareTo(b.piece));
        } else {
          entries.sort((a, b) => b.piece.compareTo(a.piece));
        }
      }
    });
  }
}
