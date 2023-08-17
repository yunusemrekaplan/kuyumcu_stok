import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/models/gold_product.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';

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
                                width: width * .09,
                                child: const Text(
                                  'Satış Tarihi',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              onSort: (columnIndex, ascending) =>
                                  _sortData(columnIndex, ascending),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: width * .1,
                                child: const Text(
                                  'İsim',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              onSort: (columnIndex, ascending) =>
                                  _sortData(columnIndex, ascending),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: width * .11,
                                child: const Text(
                                  'Maliyet Fiyat',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              onSort: (columnIndex, ascending) =>
                                  _sortData(columnIndex, ascending),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: width * .1,
                                child: const Text(
                                  'Satılan Fiyat',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              onSort: (columnIndex, ascending) =>
                                  _sortData(columnIndex, ascending),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: width * .05,
                                child: const Text(
                                  'Kar',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              onSort: (columnIndex, ascending) =>
                                  _sortData(columnIndex, ascending),
                            ),
                          ],
                          rows: products
                              .where(
                                (e) => e.isSold == 1,
                              )
                              .map(
                                (e) => DataRow(
                                  color:
                                      MaterialStateProperty.resolveWith<Color?>(
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
                                      '${DateFormat.yMd().format(e.soldDate!)}  ${DateFormat.Hm().format(e.soldDate!)}' ,
                                      style: const TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      e.name,
                                      style: const TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                        NumberFormat('#,##0.00', 'tr_TR').format(e.costPrice),//e.costPrice.toStringAsFixed(0),
                                      style: const TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      NumberFormat('#,##0.00', 'tr_TR').format(e.soldPrice),
                                      style: const TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      NumberFormat('#,##0.00', 'tr_TR').format(e.earnedProfit),
                                      style: const TextStyle(fontSize: 20),
                                    )),
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
          ],
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
