import 'package:flutter/material.dart';
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
                                width: width * .1,
                                child: const Text(
                                  'Satıldığı Tarih',
                                  style: TextStyle(fontSize: 22),
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
                                  style: TextStyle(fontSize: 22),
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
                                  style: TextStyle(fontSize: 22),
                                ),
                              ),
                              onSort: (columnIndex, ascending) =>
                                  _sortData(columnIndex, ascending),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: width * .1,
                                child: const Text(
                                  'Kar',
                                  style: TextStyle(fontSize: 22),
                                ),
                              ),
                              onSort: (columnIndex, ascending) =>
                                  _sortData(columnIndex, ascending),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: width * .1,
                                child: const Text(
                                  'İşçilik',
                                  style: TextStyle(fontSize: 22),
                                ),
                              ),
                              onSort: (columnIndex, ascending) =>
                                  _sortData(columnIndex, ascending),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: width * .1,
                                child: const Text(
                                  'Karat',
                                  style: TextStyle(fontSize: 22),
                                ),
                              ),
                              onSort: (columnIndex, ascending) =>
                                  _sortData(columnIndex, ascending),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: width * .1,
                                child: const Text(
                                  'Gram',
                                  style: TextStyle(fontSize: 22),
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
                                      e.soldDate!.toIso8601String(),
                                      style: const TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      e.name,
                                      style: const TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      e.cost,
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
                                      e.cost.toString(),
                                      style: const TextStyle(fontSize: 20),
                                    )),
                                    DataCell(
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              setState(
                                                () {
                                                  GoldProductDbHelper()
                                                      .products
                                                      .remove(e);
                                                  GoldProductDbHelper()
                                                      .delete(e.id);
                                                },
                                              );
                                            },
                                            icon: const Icon(Icons.delete),
                                            color: Colors.red[800],
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        GoldProductEditScreen(
                                                            product: e),
                                                  ),
                                                  (route) => false);
                                            },
                                            icon: const Icon(Icons.edit),
                                          ),
                                        ],
                                      ),
                                    ),
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
            Container(
              color: Colors.white,
              child: Row(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25.0, bottom: 15, top: 15),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.green;
                            }
                            return Colors.grey[600];
                          },
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context,
                            '/gold-product-add-screen', (route) => false);
                      },
                      child: const Text(
                        'Ürün Ekle',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
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
}
