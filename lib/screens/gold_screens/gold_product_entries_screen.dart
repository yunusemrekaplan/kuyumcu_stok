import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/data/product_entry_db_helper.dart';
import 'package:kuyumcu_stok/models/gold_product.dart';
import 'package:kuyumcu_stok/models/product_entry.dart';
import 'package:kuyumcu_stok/styles/data_table_styles.dart';
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

  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  _GoldProductEntriesScreenState() {
    entries = ProductEntryDbHelper().entries;
    products = GoldProductDbHelper().products;
    initializeDateFormatting('tr_TR', null);
  }

  @override
  Widget build(BuildContext context) {
    entries = ProductEntryDbHelper().entries;
    products = GoldProductDbHelper().products;
    final double width = MediaQuery.of(context).size.width - 60;
    final verticalScrollController = ScrollController();

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
            )
          ],
        ),
      ),
    );
  }

  List<DataColumn> buildDataColumns(double width) {
    return [
      buildEntryDateDataColumn(width),
      buildNameDataColumn(width),
      //buildPieceDataColumn(width),
    ];
  }

  DataColumn buildEntryDateDataColumn(double width) {
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

  List<DataRow> buildRowList(BuildContext context) {
    return entries
        .map(
          (e) => DataRow(
            color: DataTableStyles.buildDataRowColor(),
            cells: buildDataCells(e, context),
            onSelectChanged: (selected) {},
          ),
        )
        .toList();
  }

  List<DataCell> buildDataCells(ProductEntry e, BuildContext context) {
    return [
      buildEntryDateDataCell(e),
      buildNameDataCell(e),
    ];
  }

  DataCell buildEntryDateDataCell(ProductEntry e) {
    return DataCell(Text(
      '${DateFormat.yMd('tr-Tr').format(e.enteredDate)}  ${DateFormat.Hm().format(e.enteredDate)}',
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

  SizedBox buildTableHeightPaddingBox() {
    return const SizedBox(
      height: 30,
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
      } else if (columnIndex == 1) {
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
        } else {
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
    });
  }
}
