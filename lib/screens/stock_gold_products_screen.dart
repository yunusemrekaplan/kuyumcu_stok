/*
import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/enum_carat.dart';
import 'package:kuyumcu_stok/models/gold_product.dart';
import 'package:kuyumcu_stok/styles/data_table_styles.dart';
import 'package:kuyumcu_stok/styles/text_styles.dart';

class StockGoldProductsScreen extends StatefulWidget {
  const StockGoldProductsScreen({super.key});

  @override
  State<StockGoldProductsScreen> createState() =>
      _StockGoldProductsScreenState();
}

class _StockGoldProductsScreenState extends State<StockGoldProductsScreen> {
  late List<GoldProduct> stockGoldProducts;

  _StockGoldProductsScreenState() {
    //stockGoldProducts = StockGoldProductDbHelper().stockProducts;

    stockGoldProducts = [
      GoldProduct(
          barcodeText: '1111111111111',
          name: 'Test1',
          carat: Carat.twentyFour,
          gram: 7.4,
          purityRate: Carat.twentyFour.purityRateDefinition,
          laborCost: 100,
          cost: 1000),
      GoldProduct(
          barcodeText: '1111111111111',
          name: 'Test2',
          carat: Carat.twentyFour,
          gram: 9.4,
          purityRate: Carat.twentyFour.purityRateDefinition,
          laborCost: 200,
          cost: 2000),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
      ),
      body: DataTable(
        headingRowColor: DataTableStyles.buildHeadingRowColor(),
        //sortColumnIndex: _sortColumnIndex,
        //sortAscending: _sortAscending,
        columnSpacing: 35,
        horizontalMargin: 10,
        showCheckboxColumn: false,
        border: DataTableStyles.buildTableBorder(),
        columns: const [
          DataColumn(
              label: Text(
            'Barkod',
            style: TextStyle(fontSize: 22),
          )),
          DataColumn(
              label: Text(
            'İsim',
            style: TextStyle(fontSize: 22),
          )),
          DataColumn(
              label: Text(
            'Ayar',
            style: TextStyle(fontSize: 22),
          )),
          DataColumn(
              label: Text(
            'Saflık Oranı',
            style: TextStyle(fontSize: 22),
          )),
          DataColumn(
              label: Text(
            'Milyem',
            style: TextStyle(fontSize: 22),
          )),
          DataColumn(
              label: Text(
            'Gram',
            style: TextStyle(fontSize: 22),
          )),
          DataColumn(
              label: Text(
            'Maliyet',
            style: TextStyle(fontSize: 22),
          )),
        ],
        rows: stockGoldProducts
            .map((e) => DataRow(cells: [
                  DataCell(Text(
                    e.barcodeText,
                    style: TextStyles.buildTextFormFieldTextStyle(),
                  )),
                  DataCell(Text(
                    e.name,
                    style: TextStyles.buildTextFormFieldTextStyle(),
                  )),
                  DataCell(Text(
                    e.carat.intDefinition.toString(),
                    style: TextStyles.buildTextFormFieldTextStyle(),
                  )),
                  DataCell(Text(
                    e.purityRate.toString().replaceAll('.', ','),
                    style: TextStyles.buildTextFormFieldTextStyle(),
                  )),
                  DataCell(Text(
                    e.laborCost.toString().replaceAll('.', ','),
                    style: TextStyles.buildTextFormFieldTextStyle(),
                  )),
                  DataCell(Text(
                    e.gram.toString().replaceAll('.', ','),
                    style: TextStyles.buildTextFormFieldTextStyle(),
                  )),
                  DataCell(Text(
                    e.cost.toString().replaceAll('.', ','),
                    style: TextStyles.buildTextFormFieldTextStyle(),
                  )),
                ]))
            .toList(),
      ),
    );
  }
}
*/
