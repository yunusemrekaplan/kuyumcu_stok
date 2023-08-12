import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/enum_carat.dart';
import 'package:kuyumcu_stok/models/gold_product.dart';
import 'package:kuyumcu_stok/screens/gold_product_screen.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';

class GoldProductsScreen extends StatefulWidget {
  const GoldProductsScreen({super.key});

  @override
  State<GoldProductsScreen> createState() => _GoldProductsScreenState();
}

class _GoldProductsScreenState extends State<GoldProductsScreen> {
  late List<DataRow> _rows;
  late List<GoldProduct> products;

  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  _GoldProductsScreenState() {
    products = GoldProductDbHelper().products;

    _rows = products
        .map(
          (e) => DataRow(
            //key: ValueKey(e.id),
            //selected: selects[e.id]!,
            cells: [
              DataCell(Text(
                e.name!,
                style: const TextStyle(fontSize: 20),
              )),
              DataCell(Text(
                e.gram.toString(),
                style: const TextStyle(fontSize: 20),
              )),
              DataCell(Text(
                e.carat.intDefinition.toString(),
                style: const TextStyle(fontSize: 20),
              )),
              DataCell(Text(
                e.purityRate.toString(),
                style: const TextStyle(fontSize: 20),
              )),
              DataCell(Text(
                e.laborCost.toString(),
                style: const TextStyle(fontSize: 20),
              )),
              DataCell(Text(
                e.costPrice.toString(),
                style: const TextStyle(fontSize: 20),
              )),
              DataCell(Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        GoldProductDbHelper().products.remove(e);
                        GoldProductDbHelper().delete(e.id);
                      });
                    },
                    icon: const Icon(Icons.delete),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        GoldProductDbHelper().products.remove(e);
                        GoldProductDbHelper().delete(e.id);
                      });
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              )),
            ],
            onSelectChanged: (selected) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          GoldProductScreen(product: e)),
                  (route) => false);
            },
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height - 145,
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
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      columns: [
                        DataColumn(
                          label: SizedBox(
                            width: width * .1,
                            child: const Text(
                              'İsim',
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                          onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending, String),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: width * .1,
                            child: const Text(
                              'Gram',
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                          onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending, double),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: width * .1,
                            child: const Text(
                              'Karat',
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                          onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending, double),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: width * .1,
                            child: const Text(
                              'Saflık Oranı',
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                          onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending, double),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: width * .1,
                            child: const Text(
                              'İşçilik',
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                          onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending, double),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: width * .1,
                            child: const Text(
                              'Maliyet',
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                          onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending, double),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: width * .1,
                            child: const Text(''),
                          ),
                        ),
                      ],
                      rows: _rows,
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            //width: 1050,
            height: 70,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context,
                          '/gold-product-add-screen', (route) => false);
                    },
                    child: const Text(
                      'Ürün Ekle',
                      style: TextStyle(
                        fontSize: 22,
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

  void _sortData(int columnIndex, bool ascending, dynamic) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      if (dynamic == String) {
        if (ascending) {
          _rows.sort((a, b) => a.cells[columnIndex].child
              .toString()
              .compareTo(b.cells[columnIndex].child.toString()));
        } else {
          _rows.sort((a, b) => b.cells[columnIndex].child
              .toString()
              .compareTo(a.cells[columnIndex].child.toString()));
        }
      }
      else {
        if (ascending) {
          _rows.sort((a, b) => double.parse(a.cells[columnIndex].child
              .toString())
              .compareTo(double.parse(b.cells[columnIndex].child.toString())));
        } else {
          _rows.sort((a, b) => double.parse(b.cells[columnIndex].child
              .toString())
              .compareTo(double.parse(a.cells[columnIndex].child.toString())));
        }
      }
    });
  }
}
