import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/data/product_entry_db_helper.dart';
import 'package:kuyumcu_stok/localization/converters.dart';
import 'package:kuyumcu_stok/model/gold_product.dart';
import 'package:kuyumcu_stok/model/product_entry.dart';
import 'package:kuyumcu_stok/styles/button_styles.dart';
import 'package:kuyumcu_stok/styles/data_table_styles.dart';
import 'package:kuyumcu_stok/theme/theme.dart';
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

  late ButtonStyles buttonStyles;

  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  late DatePickerRow startDatePickerRow;
  late DatePickerRow endDatePickerRow;

  _GoldProductEntriesScreenState() {
    initializeDateFormatting('tr_TR', null);
    entries = ProductEntryDbHelper().entries;
    products = GoldProductDbHelper().products;
    buttonStyles = ButtonStyles();
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
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          buildDateRow(),
          const SizedBox(
            height: 35,
          ),
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height - 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20.0,),
                    child: Container(
                      decoration: BoxDecoration(
                        color: secondColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: SingleChildScrollView(
                        controller: verticalScrollController,
                        scrollDirection: Axis.vertical,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: DataTable(
                            headingRowColor:
                                DataTableStyles.buildHeadingRowColor(),
                            sortColumnIndex: _sortColumnIndex,
                            sortAscending: _sortAscending,
                            columnSpacing: 30,
                            horizontalMargin: 10,
                            showCheckboxColumn: false,
                            border: DataTableStyles.buildTableBorder(),
                            columns: buildDataColumns(),
                            rows: buildRowList(),
                          ),
                        ),
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

  Row buildDateRow() {
    return Row(
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
            style: buttonStyles.buildBasicButtonStyle(),
            child: const Text(
              'Tarihi Onayla',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
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
    );
  }

  List<DataColumn> buildDataColumns() {
    return [
      buildDataColumn(label: 'Giriş Tarihi', numeric: false),
      buildDataColumn(label: 'İsim', numeric: false),
      buildDataColumn(label: 'Girilen Adet', numeric: true),
    ];
  }

  DataColumn buildDataColumn({required String label, required bool numeric}) {
    return DataColumn(
      numeric: numeric,
      label: Text(
        label,
        style: buildDataColumnTextStyle(),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
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
      buildDataCell(cell: Converters.dateToTr(e.enteredDate)),
      buildDataCell(cell: e.product['name']),
      buildDataCell(cell: e.piece.toString()),
    ];
  }

  DataCell buildDataCell({required String cell}) {
    return DataCell(Text(
      cell,
      style: buildDataCellTextStyle(),
    ));
  }

  TextStyle buildDataCellTextStyle() {
    return const TextStyle(
      fontSize: 22,
      color: Colors.white,
    );
  }

  TextStyle buildDataColumnTextStyle() {
    return const TextStyle(
      fontSize: 24,
      color: Colors.white,
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
          entries.sort((a, b) => a.product['name'].compareTo(b.product['name']));
        } else {
          entries.sort((a, b) => b.product['name'].compareTo(a.product['name']));
        }
      } else if (columnIndex == 2) {
        if (ascending) {
          entries.sort((a, b) => a.piece.compareTo(b.piece));
        } else {
          entries.sort((a, b) => b.piece.compareTo(a.piece));
        }
      }
    });
  }
}
