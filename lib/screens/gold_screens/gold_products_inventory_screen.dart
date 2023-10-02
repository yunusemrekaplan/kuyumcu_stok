import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/enum/extension/carat_extension.dart';
import 'package:kuyumcu_stok/localization/output_formatters.dart';
import 'package:kuyumcu_stok/model/gold_product.dart';
import 'package:kuyumcu_stok/screens/gold_screens/gold_product_edit_screen.dart';
import 'package:kuyumcu_stok/styles/button_styles.dart';
import 'package:kuyumcu_stok/styles/data_table_styles.dart';
import 'package:kuyumcu_stok/styles/decoration_styles.dart';
import 'package:kuyumcu_stok/theme/theme.dart';
import 'package:kuyumcu_stok/widgets/app_bar.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';
import 'package:barcode/barcode.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
  late Size size;

  String barcodeFileName = 'barcode.pdf';

  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  bool isStock = false;

  Barcode bc = Barcode.isbn();
  var pdf = pw.Document();
  final pageFormat = const PdfPageFormat(270, 36);

  _GoldProductsInventoryScreenState() {
    products = GoldProductDbHelper().products;
    buttonStyles = ButtonStyles();
    searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar,
      drawer: const MyDrawer(),
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.03,
          ),
          SizedBox(
            width: double.infinity,
            height: size.height * 0.785,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15.0,
                      right: 15.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: secondColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: ScrollbarTheme(
                        data: ScrollbarThemeData(
                          thumbColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
                          trackColor: MaterialStateProperty.all<Color>(Colors.green),
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
      buildDataColumn(label: 'Barkod', numeric: false),
      buildDataColumn(label: 'Adet', numeric: true),
      buildDataColumn(label: 'İsim', numeric: false),
      buildDataColumn(label: 'Ayar', numeric: true),
      buildDataColumn(label: 'İşçilik', numeric: true),
      buildDataColumn(label: 'Gram', numeric: true),
      buildDataColumn(label: 'S. Gramı', numeric: true),
      buildDataColumn(label: 'Maliyet', numeric: true),
      buildActionsDataColumn(),
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

  DataColumn buildActionsDataColumn() {
    return DataColumn(
      label: Container(
        color: secondColor,
        child: TextFormField(
          controller: searchController,
          style: const TextStyle(
            fontSize: 22,
            height: 1.2,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
            constraints:
                DecorationStyles.buildBoxConstraints(const Size(210, 35)),
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
    String tripleDot = (len > 10 ? '...' : '');
    String name = e.name.substring(0, (len > 10 ? 10 : len)) + tripleDot;
    return [
      buildBarcodeDataCell(e.barcodeText),
      buildDataCell(e.piece.toString()),
      buildDataCell(name),
      buildDataCell(e.carat.intDefinition.toString()),
      buildDataCell(OutputFormatters.buildNumberFormat3f(e.laborCost)),
      buildDataCell(OutputFormatters.buildNumberFormat2f(e.gram)),
      buildDataCell(OutputFormatters.buildNumberFormat2f(e.salesGrams)),
      buildDataCell(OutputFormatters.buildNumberFormat3f(e.cost)),
      buildActionsDataCell(context, e),
    ];
  }

  DataCell buildBarcodeDataCell(String cell) {
    return DataCell(
      Text(
        cell,
        style: buildDataCellTextStyle(),
      ),
      onTap: () {
        Clipboard.setData(ClipboardData(text: cell));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Barkod kopyalandı!'),
            duration: Duration(milliseconds: 500),
          ),
        );
      },
    );
  }

  DataCell buildDataCell(String cell) {
    return DataCell(
      Text(
        cell,
        style: buildDataCellTextStyle(),
      ),
    );
  }

  DataCell buildActionsDataCell(BuildContext context, GoldProduct e) {
    return DataCell(
      Row(
        children: [
          buildDeleteButton(context, e),
          buildEditButton(context, e),
          buildPrinterButton(e),
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
      color: Colors.red,
      iconSize: size.height * 0.038,
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
      color: Colors.blue,
      iconSize: size.height * 0.038,
    );
  }

  IconButton buildPrinterButton(GoldProduct e) {
    return IconButton(
      onPressed: () async{
        try {
          await buildBarcode(e);
          await printBarcode();
        } on Exception catch (e) {
          print(e.toString());
        }
      },
      icon: const Icon(Icons.print),
      color: Colors.white70,
      iconSize: size.height * 0.038,
    );
  }

  IconButton buildAddButton() {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.add_box_outlined),
      // color: Colors.green,
      iconSize: size.height * 0.038,
    );
  }

  IconButton buildRemoveButton() {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.remove_circle_outline),
      // color: Colors.red[600],
      iconSize: size.height * 0.038,
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
          style: buildButtonTextStyle(),
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
          style: buildButtonTextStyle(),
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
          style: buildButtonTextStyle(),
        ),
      ),
    );
  }

  TextStyle buildDataColumnTextStyle() {
    return TextStyle(
      fontSize: size.height * 0.033,
      color: Colors.white,
    );
  }

  TextStyle buildDataCellTextStyle() {
    return TextStyle(
      fontSize: size.height * 0.03,
      color: Colors.white,
    );
  }

  TextStyle buildButtonTextStyle() {
    return TextStyle(
      fontSize: size.height * 0.03,
      color: Colors.white,
    );
  }

  Future<void> buildBarcode(GoldProduct product) async {
    String data = product.barcodeText;

    final svg = bc.toSvg(
      data,
      width: 60, // 75
      height: 30, // 30
      fontHeight: 6,
    );

    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        build: (pw.Context context) => pw.Row(
          children: [
            pw.SizedBox(
              width: 56,
              height: 30,
              child: pw.SvgImage(svg: svg),
            ),
            pw.SizedBox(width: 15),
            pw.Column(
              children: [
                pw.SizedBox(height: 10),
                pw.Text(
                  '${product.gram} GR',
                  style: const pw.TextStyle(
                    fontSize: 6,
                  ),
                ),
                pw.Text(
                  '${product.salesGrams} SGR',
                  style: const pw.TextStyle(
                    fontSize: 6,
                  ),
                ),
              ],
            ),
            pw.SizedBox(width: 10),
            pw.Column(
              children: [
                pw.SizedBox(height: 10),
                pw.Text(
                  '${product.cost}',
                  style: const pw.TextStyle(
                    fontSize: 6,
                  ),
                ),
                pw.Text(
                  '${product.carat.intDefinition}K',
                  style: const pw.TextStyle(
                    fontSize: 6,
                  ),
                ),
              ]
            ),
          ],
        ),
      ),
    );

    /*final file = File(barcodeFileName);
    await file.writeAsBytes(await pdf.save());*/
  }

  Future<void> printBarcode() async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => await pdf.save(),// pdf.document.documentID,
      name: barcodeFileName,
    );
    pdf = pw.Document();
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
