import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/enum/extension/carat_extension.dart';
import 'package:kuyumcu_stok/localization/output_formatters.dart';
import 'package:kuyumcu_stok/model/gold_product.dart';
import 'package:kuyumcu_stok/screens/gold_screens/gold_product_edit_screen.dart';
import 'package:kuyumcu_stok/styles/button_styles.dart';
import 'package:kuyumcu_stok/styles/data_table_styles.dart';
import 'package:kuyumcu_stok/styles/decoration_styles.dart';
import 'package:kuyumcu_stok/styles/text_styles.dart';
import 'package:kuyumcu_stok/theme/theme.dart';
import 'package:kuyumcu_stok/widgets/app_bar.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';

class GoldProductsInventoryScreen extends StatefulWidget {
  const GoldProductsInventoryScreen({super.key});

  @override
  State<GoldProductsInventoryScreen> createState() =>
      _GoldProductsInventoryScreenState();
}

class _GoldProductsInventoryScreenState
    extends State<GoldProductsInventoryScreen> {
  late List<GoldProduct> products;
  late TextEditingController searchController;

  late ButtonStyles buttonStyles;

  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  bool isStock = true;

  _GoldProductsInventoryScreenState() {
    products = GoldProductDbHelper().products;
    buttonStyles = ButtonStyles();
    searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: const MyDrawer(),
      backgroundColor: Colors.blue[700],
      body: Column(
        children: [
          buildTableHeightPaddingBox(),
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height - 170,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: buildDataTable(context),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //buildTableHeightPaddingBox(),
          Expanded(
            child: Row(
              children: [
                buildStockAddButton(context),
                buildViewOutOfStockButton(context),
                buildViewInStockButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataTable buildDataTable(BuildContext context) {
    return DataTable(
      //headingTextStyle: TextStyle(),
      headingRowColor: DataTableStyles.buildHeadingRowColor(),
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      columnSpacing: 30,
      horizontalMargin: 20,
      showCheckboxColumn: false,
      border: DataTableStyles.buildTableBorder(),
      columns: buildDataColumns(),
      rows: buildRowList(context),
    );
  }

  List<DataColumn> buildDataColumns() {
    return [
      buildBarcodeDataColumn(),
      buildPieceDataColumn(),
      buildNameDataColumn(),
      //buildPurityRateDataColumn(),
      buildCaratDataColumn(),
      buildLaborCostDataColumn(),
      buildGramDataColumn(),
      buildSalesGramDataColumn(),
      buildCostDataColumn(),
      buildActionsDataColumn(),
    ];
  }

  DataColumn buildBarcodeDataColumn() {
    return DataColumn(
      label: Text(
        'Barkod',
        style: buildDataColumnTextStyle(),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  DataColumn buildPieceDataColumn() {
    return DataColumn(
      label: Text(
        'Adet',
        style: buildDataColumnTextStyle(),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  DataColumn buildNameDataColumn() {
    return DataColumn(
      label: Text(
        'İsim',
        style: buildDataColumnTextStyle(),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  DataColumn buildCaratDataColumn() {
    return DataColumn(
      label: Text(
        'Ayar',
        style: buildDataColumnTextStyle(),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  /*DataColumn buildPurityRateDataColumn(double width) {
    return DataColumn(
      label: const SizedBox(
        //width: width * .13,
        child: Text(
          'Saflık',
        style: TextStyle(
          fontSize: 22,
          color: Colors.white,
        ),
        ),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }*/

  DataColumn buildLaborCostDataColumn() {
    return DataColumn(
      label: Text(
        'İşçilik',
        style: buildDataColumnTextStyle(),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  DataColumn buildGramDataColumn() {
    return DataColumn(
      label: Text(
        'Gram',
        style: buildDataColumnTextStyle(),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  DataColumn buildSalesGramDataColumn() {
    return DataColumn(
      label: Text(
        'S. Gramı',
        style: buildDataColumnTextStyle(),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  DataColumn buildCostDataColumn() {
    return DataColumn(
      label: Text(
        'Maliyet',
        style: buildDataColumnTextStyle(),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  TextStyle buildDataColumnTextStyle() {
    return const TextStyle(
      fontSize: 22,
      color: Colors.white,
    );
  }

  DataColumn buildActionsDataColumn() {
    return DataColumn(
      label: Container(
        color: Colors.white,
        child: TextFormField(
          controller: searchController,
          style: const TextStyle(
            fontSize: 20,
            height: 1,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: '9784753492558',
            hintStyle: const TextStyle(
              fontSize: 20,
            ),
            contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
            constraints:
                DecorationStyles.buildBoxConstraints(const Size(180, 35)),
          ),
          onChanged: onSearch,
        ),
      ),
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

  List<DataRow> buildRowList(BuildContext context) {
    List<DataRow> res = products
        .where(
          (e) {
            return isStock ? e.piece == 0 : e.piece > 0;
          },
        )
        .map(
          (e) => DataRow(
            color: DataTableStyles.buildDataRowColor(),
            cells: buildDataCells(e, context),
            onSelectChanged: (selected) {},
          ),
        )
        .toList();
    return res;
  }

  List<DataCell> buildDataCells(GoldProduct e, BuildContext context) {
    return [
      buildBarkodDataCell(e),
      buildPieceDataCell(e),
      buildNameDataCell(e),
      buildCaratDataCell(e),
      //buildPurityRateDataCell(e),
      buildLaborCostDataCell(e),
      buildGramDataCell(e),
      buildSalesGramsDataCell(e),
      buildCostDataCell(e),
      buildActionsDataCell(context, e),
    ];
  }

  DataCell buildBarkodDataCell(GoldProduct e) {
    return DataCell(Text(
      e.barcodeText,
      style: const TextStyle(
        fontSize: 20,
        color: Colors.white,
      ),
    ));
  }

  DataCell buildPieceDataCell(GoldProduct e) {
    return DataCell(
      Text(
        e.piece.toString(),
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  DataCell buildNameDataCell(GoldProduct e) {
    int len = e.name.length;
    String name =
        e.name.substring(0, (len > 11 ? 11 : len)) + (len > 11 ? '...' : '');
    return DataCell(Text(
      name,
      style: const TextStyle(
        fontSize: 20,
        color: Colors.white,
      ),
    ));
  }

  DataCell buildCaratDataCell(GoldProduct e) {
    return DataCell(Text(
      e.carat.intDefinition.toString(),
      style: const TextStyle(
        fontSize: 20,
        color: Colors.white,
      ),
    ));
  }

  /*DataCell buildPurityRateDataCell(GoldProduct e) {
    return DataCell(Text(
      e.purityRate.toString().replaceAll('.', ','),//NumberFormat('#,##0.0', 'tr_TR').format(e.purityRate),
      style: const TextStyle(
        fontSize: 20,
        color: Colors.white,
      ),
    ));
  }*/

  DataCell buildLaborCostDataCell(GoldProduct e) {
    return DataCell(Text(
      OutputFormatters.buildNumberFormat1f(e.laborCost),
      style: const TextStyle(
        fontSize: 20,
        color: Colors.white,
      ),
    ));
  }

  DataCell buildGramDataCell(GoldProduct e) {
    return DataCell(Text(
      OutputFormatters.buildNumberFormat3f(e.gram),
      style: const TextStyle(
        fontSize: 20,
        color: Colors.white,
      ),
    ));
  }

  DataCell buildSalesGramsDataCell(GoldProduct e) {
    return DataCell(Text(
      OutputFormatters.buildNumberFormat3f(e.salesGrams),
      style: const TextStyle(
        fontSize: 20,
        color: Colors.white,
      ),
    ));
  }

  DataCell buildCostDataCell(GoldProduct e) {
    return DataCell(Text(
      OutputFormatters.buildNumberFormat3f(e.cost),
      style: const TextStyle(
        fontSize: 20,
        color: Colors.white,
      ),
    ));
  }

  DataCell buildActionsDataCell(BuildContext context, GoldProduct e) {
    return DataCell(
      Row(
        children: [
          buildDeleteButton(context, e),
          buildEditButton(context, e),
          buildPrinterButton(),
          buildAddButton(),
          buildRemoveButton(),
        ],
      ),
    );
  }

  IconButton buildDeleteButton(BuildContext context, GoldProduct e) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Ürünü silmek istediğinize emin misiniz?'),
            actions: [
              TextButton(
                child: const Text(
                  style: TextStyle(fontSize: 20),
                  'Evet',
                ),
                onPressed: () {
                  setState(
                    () {
                      GoldProductDbHelper().products.remove(e);
                      GoldProductDbHelper().delete(e.id);
                    },
                  );
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  'Hayır',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
      icon: const Icon(Icons.delete),
      color: Colors.red[600],
      iconSize: 26,
    );
  }

  IconButton buildEditButton(BuildContext context, GoldProduct e) {
    return IconButton(
      onPressed: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  GoldProductEditScreen(product: e),
            ),
            (route) => false);
      },
      icon: const Icon(Icons.edit),
      iconSize: 26,
    );
  }

  IconButton buildPrinterButton() {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.print),
      iconSize: 26,
    );
  }

  IconButton buildAddButton() {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.add_box_outlined),
      iconSize: 26,
    );
  }

  IconButton buildRemoveButton() {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.remove_circle_outline),
      iconSize: 26,
    );
  }

  Row buildStockAddButton(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25.0, bottom: 10),
          child: ElevatedButton(
            style: buttonStyles.buildBasicButtonStyle(),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/gold-product-add-screen', (route) => false);
            },
            child: Text(
              'Stok Ekle',
              style: TextStyles.buildButtonTextStyle(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildViewOutOfStockButton(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25.0, bottom: 10),
          child: ElevatedButton(
            style: buttonStyles.buildBasicButtonStyle(),
            onPressed: () {
              isStock = true;
              setState(() {
                products;
              });
            },
            child: Text(
              'Stok Dışı',
              style: TextStyles.buildButtonTextStyle(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildViewInStockButton(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25.0, bottom: 10),
          child: ElevatedButton(
            style: buttonStyles.buildBasicButtonStyle(),
            onPressed: () {
              isStock = false;
              setState(() {
                products;
              });
            },
            child: Text(
              'Stokta',
              style: TextStyles.buildButtonTextStyle(),
            ),
          ),
        ),
      ],
    );
  }

  void _sortData(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      if (columnIndex == 0) {
        if (ascending) {
          products.sort((a, b) => a.barcodeText.compareTo(b.barcodeText));
        } else {
          products.sort((a, b) => b.barcodeText.compareTo(a.barcodeText));
        }
      } else if (columnIndex == 1) {
        if (ascending) {
          products.sort((a, b) => a.piece.compareTo(b.piece));
        } else {
          products.sort((a, b) => b.piece.compareTo(a.piece));
        }
      } else if (columnIndex == 2) {
        if (ascending) {
          products.sort((a, b) => a.name.compareTo(b.name));
        } else {
          products.sort((a, b) => b.name.compareTo(a.name));
        }
      } else if (columnIndex == 3) {
        if (ascending) {
          products.sort(
              (a, b) => a.carat.intDefinition.compareTo(b.carat.intDefinition));
        } else {
          products.sort(
              (a, b) => b.carat.intDefinition.compareTo(a.carat.intDefinition));
        }
      } else if (columnIndex == 4) {
        if (ascending) {
          products.sort((a, b) => a.laborCost.compareTo(b.laborCost));
        } else {
          products.sort((a, b) => b.laborCost.compareTo(a.laborCost));
        }
      } else if (columnIndex == 5) {
        if (ascending) {
          products.sort((a, b) => a.gram.compareTo(b.gram));
        } else {
          products.sort((a, b) => b.gram.compareTo(a.gram));
        }
      } else if (columnIndex == 6) {
        if (ascending) {
          products.sort((a, b) => a.salesGrams.compareTo(b.salesGrams));
        } else {
          products.sort((a, b) => b.salesGrams.compareTo(a.salesGrams));
        }
      } else if (columnIndex == 7) {
        if (ascending) {
          products.sort((a, b) => a.cost.compareTo(b.cost));
        } else {
          products.sort((a, b) => b.cost.compareTo(a.cost));
        }
      }
    });
  }

  void onSearch(value) {
    if (value.isEmpty) {
      setState(() {
        products = GoldProductDbHelper()
            .products
            .where(
              (e) => e.piece > 0,
            )
            .toList();
      });
    }
    setState(() {
      products = GoldProductDbHelper()
          .products
          .where(
            (e) => e.piece > 0,
          )
          .toList();
      //print(value);
      products = products
          .where(
            (e) => e.barcodeText.contains(value),
          )
          .toList();
    });
  }
}
