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
  bool isStock = false;

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
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height - 150,
            child: Row(
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
      buildDataColumn('Barkod'),
      buildDataColumn('Adet'),
      buildDataColumn('İsim'),
      buildDataColumn('Ayar'),
      buildDataColumn('İşçilik'),
      buildDataColumn('Gram'),
      buildDataColumn('S. Gramı'),
      buildDataColumn('Maliyet'),
      buildActionsDataColumn(),
    ];
  }

  DataColumn buildDataColumn(String label) {
    return DataColumn(
      label: Text(
        label,
        style: buildDataColumnTextStyle(),
      ),
      onSort: (columnIndex, ascending) => _sortData(columnIndex, ascending),
    );
  }

  DataColumn buildActionsDataColumn() {
    return DataColumn(
      label: Container(
        color: secondColor,
        child: TextFormField(
          controller: searchController,
          style: const TextStyle(
            fontSize: 20,
            height: 1,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
            constraints:
                DecorationStyles.buildBoxConstraints(const Size(200, 35)),
          ),
          cursorColor: Colors.white,
          onChanged: onSearch,
        ),
      ),
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
    int len = e.name.length;
    String tripleDot = (len > 11 ? '...' : '');
    String name = e.name.substring(0, (len > 11 ? 11 : len)) + tripleDot;
    return [
      buildDataCell(e.barcodeText),
      buildDataCell(e.piece.toString()),
      buildDataCell(name),
      buildDataCell(e.carat.intDefinition.toString()),
      buildDataCell(OutputFormatters.buildNumberFormat1f(e.laborCost)),
      buildDataCell(OutputFormatters.buildNumberFormat3f(e.gram)),
      buildDataCell(OutputFormatters.buildNumberFormat3f(e.salesGrams)),
      buildDataCell(OutputFormatters.buildNumberFormat3f(e.cost)),
      buildActionsDataCell(context, e),
    ];
  }

  DataCell buildDataCell(String cell) {
    return DataCell(Text(
      cell,
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

  Padding buildStockAddButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
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
    );
  }

  Padding buildViewOutOfStockButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
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
    );
  }

  Padding buildViewInStockButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
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
    );
  }

  TextStyle buildDataColumnTextStyle() {
    return const TextStyle(
      fontSize: 22,
      color: Colors.white,
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
        products = GoldProductDbHelper().products.toList();
      });
    }
    setState(() {
      products = GoldProductDbHelper().products.toList();
      products = products
          .where(
            (e) =>
                e.barcodeText.contains(value) ||
                e.name
                    .toString()
                    .toLowerCase()
                    .contains(value.toString().toLowerCase()),
          )
          .toList();
    });
  }
}
