import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/data/product_sale_db_helper.dart';
import 'package:kuyumcu_stok/localization/converters.dart';
import 'package:kuyumcu_stok/localization/output_formatters.dart';
import 'package:kuyumcu_stok/model/gold_product.dart';
import 'package:kuyumcu_stok/model/product_sale.dart';
import 'package:kuyumcu_stok/styles/button_styles.dart';
import 'package:kuyumcu_stok/styles/data_table_styles.dart';
import 'package:kuyumcu_stok/theme/theme.dart';
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

  late ButtonStyles buttonStyles;

  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  late DatePickerRow startDatePickerRow;
  late DatePickerRow endDatePickerRow;
  late double totalSaleTl;
  late double totalProfitTl;
  late double totalProfitGram;

  _GoldProductSalesScreenState() {
    initializeDateFormatting('tr_TR', null);
    sales = ProductSaleDbHelper().sales;
    products = GoldProductDbHelper().products;
    buttonStyles = ButtonStyles();
    totalSaleTl = 0;
    totalProfitTl = 0;
    totalProfitGram = 0;
    for (var element in sales) {
      totalSaleTl += (element.soldPrice * element.piece);
    }
    for (var element in sales) {
      totalProfitTl += element.earnedProfitTL * element.piece;
    }
    for (var element in sales) {
      totalProfitGram += element.earnedProfitGram * element.piece;
    }
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
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.10,
            child: buildDateRow(),
          ),
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.70,
            child: buildDataTable(verticalScrollController),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.10,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 10.0, right: 20.0, bottom: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Toplam Satış (TL): ${OutputFormatters.buildNumberFormat0f(totalSaleTl)} TL',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'Toplam Kar (TL): ${OutputFormatters.buildNumberFormat0f(totalProfitTl)} TL',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'Toplam Kar (Gram): ${OutputFormatters.buildNumberFormat2f(totalProfitGram)} Gram',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
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
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            onPressed: () {
              setState(() {
                startTime = startDatePickerRow.initialTime;
                endTime = endDatePickerRow.initialTime;
                sales;
              });
              buildTotals();
            },
          ),
        ),
      ],
    );
  }

  Row buildDataTable(ScrollController verticalScrollController) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20.0,
            ),
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
                    headingRowColor: DataTableStyles.buildHeadingRowColor(),
                    sortColumnIndex: _sortColumnIndex,
                    sortAscending: _sortAscending,
                    columnSpacing: 30,
                    horizontalMargin: 20,
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
    );
  }

  List<DataColumn> buildDataColumns() {
    return [
      buildDataColumn(label: 'Tarihi', numeric: false),
      buildDataColumn(label: 'İsim', numeric: false),
      buildDataColumn(label: 'Satılan Adet', numeric: true),
      buildDataColumn(label: 'Kar (TL)', numeric: true),
      buildDataColumn(label: 'Kar (Gram)', numeric: true),
    ];
  }

  List<DataRow> buildRowList() {
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
        )
        .toList();
  }

  List<DataCell> buildDataCells(ProductSale e) {
    String name = e.product['name'];
    name = name.substring(0, name.length <= 20 ? name.length : 20);
    return [
      buildDataCell(cell: Converters.dateToTr(e.soldDate)),
      buildDataCell(cell: name),
      buildDataCell(cell: e.piece.toString()),
      buildDataCell(
          cell: OutputFormatters.buildNumberFormat0f(e.earnedProfitTL)),
      buildDataCell(
          cell: OutputFormatters.buildNumberFormat3f(e.earnedProfitGram)),
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

  void buildTotals() {
    totalSaleTl = 0;
    totalProfitTl = 0;
    totalProfitGram = 0;
    sales.where((element) =>
            (element.soldDate.compareTo(startTime) >= 0) &&
            (element.soldDate.compareTo(endTime) <= 0)).map((e) {
      totalSaleTl += e.soldPrice * e.piece;
      totalProfitTl += e.earnedProfitTL * e.piece;
      totalProfitGram += e.earnedProfitGram * e.piece;
    }).toList();
    setState(() {
      totalSaleTl;
      totalProfitTl;
      totalProfitGram;
    });
  }

  void _sortData(int columnIndex, bool ascending) {
    setState(() {
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
          sales.sort((a, b) => a.product['name'].compareTo(b.product['name']));
        } else {
          sales.sort((a, b) => b.product['name'].compareTo(a.product['name']));
        }
      } else if (columnIndex == 2) {
        if (ascending) {
          sales.sort((a, b) => a.piece.compareTo(b.piece));
        } else {
          sales.sort((a, b) => b.piece.compareTo(a.piece));
        }
      } else if (columnIndex == 3) {
        if (ascending) {
          sales.sort((a, b) => a.earnedProfitTL.compareTo(b.earnedProfitTL));
        } else {
          sales.sort((a, b) => b.earnedProfitTL.compareTo(a.earnedProfitTL));
        }
      } else if (columnIndex == 4) {
        if (ascending) {
          sales
              .sort((a, b) => a.earnedProfitGram.compareTo(b.earnedProfitGram));
        } else {
          sales
              .sort((a, b) => b.earnedProfitGram.compareTo(a.earnedProfitGram));
        }
      }
    });
  }
}
