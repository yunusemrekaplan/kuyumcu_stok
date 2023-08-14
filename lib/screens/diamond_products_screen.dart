import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/data/diamond_product_db_helper.dart';
import 'package:kuyumcu_stok/models/diamond_product.dart';
import 'package:kuyumcu_stok/screens/diamond_product_screen.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';

class DiamondProductsScreen extends StatefulWidget {
  const DiamondProductsScreen({super.key});

  @override
  State<DiamondProductsScreen> createState() => _DiamondProductsScreenState();
}

class _DiamondProductsScreenState extends State<DiamondProductsScreen> {
  late List<DataRow> _rows;
  late List<DiamondProduct> products;

  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  _DiamondProductsScreenState() {
    products = DiamondProductDbHelper().products;

    _rows = products
        .map((e) => DataRow(
              cells: [
                DataCell(Text(
                  e.name.toString(),
                  style: const TextStyle(fontSize: 20),
                )),
                DataCell(Text(
                  e.gram.toString(),
                  style: const TextStyle(fontSize: 20),
                )),
                DataCell(Text(
                  e.price.toString(),
                  style: const TextStyle(fontSize: 20),
                )),
                DataCell(Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          DiamondProductDbHelper().products.remove(e);
                          DiamondProductDbHelper().delete(e.id);
                        });
                      },
                      icon: const Icon(Icons.delete),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          DiamondProductDbHelper().products.remove(e);
                          DiamondProductDbHelper().delete(e.id);
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
                            DiamondProductScreen(product: e)),
                        (route) => false);
              },
            ))
        .toList();
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
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            SizedBox(
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
                                'Ücret',
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
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context,
                          '/diamond-product-add-screen', (route) => false);
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
          ],
        ),
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
          _rows.sort((a, b) {
            Text aText = a.cells[columnIndex].child as Text;
            Text bText = b.cells[columnIndex].child as Text;
            double aDouble = double.parse(aText.data!.replaceAll(',', '.'));
            double bDouble = double.parse(bText.data!.replaceAll(',', '.'));
            return aDouble.compareTo(bDouble);
          });
        } else {
          _rows.sort((a, b) {
            Text aText = a.cells[columnIndex].child as Text;
            Text bText = b.cells[columnIndex].child as Text;
            double aDouble = double.parse(aText.data!.replaceAll(',', '.'));
            double bDouble = double.parse(bText.data!.replaceAll(',', '.'));
            return bDouble.compareTo(aDouble);
          });
        }
      }
    });
  }
}
