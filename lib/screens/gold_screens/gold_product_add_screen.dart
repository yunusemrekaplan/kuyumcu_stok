import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kuyumcu_stok/calculator.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/data/product_entry_db_helper.dart';
import 'package:kuyumcu_stok/enum/carat.dart';
import 'package:kuyumcu_stok/enum/extension/carat_extension.dart';
import 'package:kuyumcu_stok/localization/input_formatters.dart';
import 'package:kuyumcu_stok/localization/output_formatters.dart';
import 'package:kuyumcu_stok/model/gold_product.dart';
import 'package:kuyumcu_stok/model/product_entry.dart';
import 'package:kuyumcu_stok/services/barcode_service.dart';
import 'package:kuyumcu_stok/styles/button_styles.dart';
import 'package:kuyumcu_stok/styles/data_table_styles.dart';
import 'package:kuyumcu_stok/styles/decoration_styles.dart';
import 'package:kuyumcu_stok/styles/text_styles.dart';
import 'package:kuyumcu_stok/theme/theme.dart';
import 'package:kuyumcu_stok/validations/number_validator.dart';
import 'package:kuyumcu_stok/widgets/app_bar.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';

class GoldProductAddScreen extends StatefulWidget {
  const GoldProductAddScreen({super.key});

  @override
  State<GoldProductAddScreen> createState() => _GoldProductAddScreenState();
}

class _GoldProductAddScreenState extends State<GoldProductAddScreen> {
  late String barcodeNo;
  late Carat dropdownValue;
  late TextEditingController pieceController;
  late TextEditingController nameController;
  late TextEditingController purityRateController;
  late TextEditingController laborCostController;
  late TextEditingController gramController;
  late TextEditingController salesGramsController;
  late TextEditingController costController;

  late ButtonStyles buttonStyles;
  Color cursorColor = Colors.white;

  _GoldProductAddScreenState() {
    initializeDateFormatting('tr_TR', null);
    buttonStyles = ButtonStyles();
    dropdownValue = Carat.twentyFour;
    barcodeNo = '0000000000000';
    pieceController = TextEditingController();
    nameController = TextEditingController();
    purityRateController = TextEditingController();
    laborCostController = TextEditingController();
    gramController = TextEditingController();
    salesGramsController = TextEditingController();
    costController = TextEditingController();
    purityRateController.text = OutputFormatters.buildNumberFormat1f(
        dropdownValue.purityRateDefinition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: const MyDrawer(),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(25),
          ),
          width: MediaQuery.of(context).size.width - 300,
          height: MediaQuery.of(context).size.height - 120,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: DataTable(
                //headingRowColor: DataTableStyles.buildHeadingRowColor(),
                columnSpacing: 30,
                horizontalMargin: 50,
                showCheckboxColumn: false,
                border: DataTableStyles.buildTableBorder(),
                columns: [
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Barkod No:',
                        textAlign: TextAlign.center,
                        style: buildTextStyle(),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      barcodeNo,
                      textAlign: TextAlign.center,
                      style: buildTextStyle(),
                    ),
                  ),
                  DataColumn(
                    label: buildBarcodeGeneratorButton(),
                  ),
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(
                        SizedBox(
                          width: 250,
                          child: Text(
                            '       Adet:',
                            textAlign: TextAlign.start,
                            style: buildTextStyle(),
                          ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: TextFormField(
                            controller: pieceController,
                            style: buildTextFormFieldTextStyle(),
                            decoration: buildFormDecor(),
                            cursorColor: cursorColor,
                            inputFormatters: <TextInputFormatter>[
                              inputFormatOnlyDigits,
                            ],
                            onChanged: (value) {
                              setState(() {
                                pieceController;
                                buttonStyles;
                              });
                            },
                          ),
                        ),
                      ),
                      const DataCell(Text('')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        SizedBox(
                          width: 250,
                          child: Text(
                            '       İsim:',
                            textAlign: TextAlign.start,
                            style: buildTextStyle(),
                          ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: TextFormField(
                            controller: nameController,
                            style: buildTextFormFieldTextStyle(),
                            decoration: buildFormDecor(),
                            cursorColor: cursorColor,
                            onChanged: (value) {
                              setState(() {
                                nameController;
                                buttonStyles;
                              });
                            },
                          ),
                        ),
                      ),
                      const DataCell(Text('')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        SizedBox(
                          width: 250,
                          child: Text(
                            '       Ayar:',
                            textAlign: TextAlign.start,
                            style: buildTextStyle(),
                          ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: DropdownButtonFormField(
                            alignment: Alignment.centerLeft,
                            value: dropdownValue,
                            icon: Icon(
                              Icons.arrow_downward,
                              color: cursorColor,
                            ),
                            dropdownColor: backgroundColor,
                            decoration: DecorationStyles
                                .buildDropdownButtonInputDecoration(),
                            style: buildTextFormFieldTextStyle(),
                            items: buildDropdownMenuItemList(),
                            onChanged: (Carat? newValue) {
                              dropdownValue = newValue!;
                              purityRateController.text =
                                  OutputFormatters.buildNumberFormat1f(
                                      dropdownValue.purityRateDefinition);
                              setState(() {
                                purityRateController;
                                buttonStyles;
                              });
                              buildCalculate();
                            },
                          ),
                        ),
                      ),
                      const DataCell(Text('')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        SizedBox(
                          width: 250,
                          child: Text(
                            '       Saflık Oranı:',
                            textAlign: TextAlign.start,
                            style: buildTextStyle(),
                          ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: TextFormField(
                            validator: NumberValidator.validate,
                            controller: purityRateController,
                            style: buildTextFormFieldTextStyle(),
                            decoration: buildFormDecor(),
                            cursorColor: cursorColor,
                            inputFormatters: <TextInputFormatter>[
                              inputFormatDouble,
                            ],
                            onChanged: (value) {
                              setState(() {
                                purityRateController;
                                buttonStyles;
                              });
                              buildCalculate();
                            },
                          ),
                        ),
                      ),
                      const DataCell(Text('')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        SizedBox(
                          width: 250,
                          child: Text(
                            '       İşçilik:',
                            textAlign: TextAlign.start,
                            style: buildTextStyle(),
                          ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: TextFormField(
                            validator: NumberValidator.validate,
                            controller: laborCostController,
                            style: buildTextFormFieldTextStyle(),
                            decoration: buildFormDecor(),
                            cursorColor: cursorColor,
                            inputFormatters: <TextInputFormatter>[
                              inputFormatDouble,
                            ],
                            onChanged: (value) {
                              setState(() {
                                laborCostController;
                                buttonStyles;
                              });
                              buildCalculate();
                            },
                          ),
                        ),
                      ),
                      const DataCell(Text('')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        SizedBox(
                          width: 250,
                          child: Text(
                            '       Gram:',
                            textAlign: TextAlign.start,
                            style: buildTextStyle(),
                          ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: TextFormField(
                            validator: NumberValidator.validate,
                            controller: gramController,
                            style: buildTextFormFieldTextStyle(),
                            decoration: buildFormDecor(),
                            cursorColor: cursorColor,
                            inputFormatters: <TextInputFormatter>[
                              inputFormatDouble,
                            ],
                            onChanged: (value) {
                              setState(() {
                                gramController;
                                buttonStyles;
                              });
                            },
                          ),
                        ),
                      ),
                      const DataCell(Text('')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        SizedBox(
                          width: 250,
                          child: Text(
                            '       Satış Gramı:',
                            textAlign: TextAlign.start,
                            style: buildTextStyle(),
                          ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: TextFormField(
                            validator: NumberValidator.validate,
                            controller: salesGramsController,
                            style: buildTextFormFieldTextStyle(),
                            decoration: buildFormDecor(),
                            cursorColor: cursorColor,
                            inputFormatters: <TextInputFormatter>[
                              inputFormatDouble,
                            ],
                            onChanged: (value) {
                              setState(() {
                                salesGramsController;
                                buttonStyles;
                              });
                              buildCalculate();
                            },
                          ),
                        ),
                      ),
                      const DataCell(Text('')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        SizedBox(
                          width: 250,
                          child: Text(
                            '       Maliyet:',
                            textAlign: TextAlign.start,
                            style: buildTextStyle(),
                          ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: TextFormField(
                            validator: NumberValidator.validate,
                            controller: costController,
                            style: buildTextFormFieldTextStyle(),
                            decoration: buildFormDecor(),
                            cursorColor: cursorColor,
                            inputFormatters: <TextInputFormatter>[
                              inputFormatDouble,
                            ],
                            onChanged: (value) {
                              setState(() {
                                costController;
                                buttonStyles;
                              });
                            },
                          ),
                        ),
                      ),
                      const DataCell(Text('')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        Row(
                          children: [
                            SizedBox(
                              width: 53,
                            ),
                            ElevatedButton(
                              style: buttonStyles.buildSaveButtonStyle(
                                  (isVariablesEmpty() ||
                                      isCorrectFormat() ||
                                      barcodeNo == '0000000000000')),
                              onPressed: onSaved,
                              child: Text(
                                'Kaydet',
                                style: TextStyles.buildButtonTextStyle(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Text(''),
                      ),
                      DataCell(
                        ElevatedButton(
                          style: buttonStyles.buildBasicButtonStyle(),
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/gold-products-inventory-screen',
                                (route) => false);
                          },
                          child: Text(
                            'Geri Dön',
                            style: TextStyles.buildButtonTextStyle(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle buildTextFormFieldTextStyle() {
    return const TextStyle(
      fontSize: 24,
      height: 0.9,
      color: Colors.white,
    );
  }

  InputDecoration buildFormDecor() =>
      DecorationStyles.buildInputDecoration(const Size(200, 38));

  TextStyle buildTextStyle() {
    return const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }

  ElevatedButton buildBarcodeGeneratorButton() {
    return ElevatedButton(
      style: buttonStyles.buildBasicButtonStyle(),
      onPressed: () {
        barcodeNo = BarcodeService.generateCode();
        setState(() {
          barcodeNo;
        });
      },
      child: Text(
        'Barkod Oluştur',
        style: buildTextStyle(),
      ),
    );
  }

  Padding buildSalesGramsRow() {
    return Padding(
      padding: buildEdgeInsets(),
      child: Row(
        children: [
          Text(
            'Satış Gramı: ',
            style: TextStyles.buildTextStyle(),
          ),
          TextFormField(
            validator: NumberValidator.validate,
            controller: salesGramsController,
            style: TextStyles.buildTextFormFieldTextStyle(),
            decoration:
                DecorationStyles.buildInputDecoration(const Size(125, 38)),
            inputFormatters: <TextInputFormatter>[
              inputFormatDouble,
            ],
            onChanged: (value) {
              setState(() {
                salesGramsController;
                buttonStyles;
              });
              buildCalculate();
            },
          ),
        ],
      ),
    );
  }

  Padding buildCostRow() {
    return Padding(
      padding: buildEdgeInsets(),
      child: Row(
        children: [
          Text(
            'Maliyet: ',
            style: TextStyles.buildTextStyle(),
          ),
          TextFormField(
            validator: NumberValidator.validate,
            controller: costController,
            style: TextStyles.buildTextFormFieldTextStyle(),
            decoration:
                DecorationStyles.buildInputDecoration(const Size(125, 38)),
            inputFormatters: <TextInputFormatter>[
              inputFormatDouble,
            ],
            onChanged: (value) {
              setState(() {
                costController;
                buttonStyles;
              });
            },
          ),
        ],
      ),
    );
  }

  Padding buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, top: 16, bottom: 0),
      child: Row(
        children: [
          ElevatedButton(
            style: buttonStyles.buildSaveButtonStyle((isVariablesEmpty() ||
                isCorrectFormat() ||
                barcodeNo == '0000000000000')),
            onPressed: onSaved,
            child: Text(
              'Kaydet',
              style: TextStyles.buildButtonTextStyle(),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildBackButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, top: 16, bottom: 16),
      child: Row(
        children: [
          ElevatedButton(
            style: buttonStyles.buildBasicButtonStyle(),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/gold-products-inventory-screen', (route) => false);
            },
            child: Text(
              'Geri Dön',
              style: TextStyles.buildButtonTextStyle(),
            ),
          ),
        ],
      ),
    );
  }

  void onSaved() async {
    if (barcodeNo == '0000000000000') {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Barkod oluşturun!'),
          actions: [
            TextButton(
              child: const Text('Tamam'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } else if (isVariablesEmpty()) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Boş alanları doldurun!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    } else if (isCorrectFormat()) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Doğru formatta veri girin!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    } else {
      /*showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });*/

      Map<String, dynamic> goldProductJson = GoldProduct(
        barcodeText: barcodeNo,
        piece: int.parse(pieceController.text),
        name: nameController.text,
        carat: dropdownValue,
        gram: double.parse(gramController.text.replaceAll(',', '.')),
        purityRate:
            double.parse(purityRateController.text.replaceAll(",", ".")),
        laborCost: double.parse(laborCostController.text.replaceAll(',', '.')),
        cost: double.parse(costController.text.replaceAll(',', '.')),
        salesGrams:
            double.parse(salesGramsController.text.replaceAll(',', '.')),
      ).toJson();

      Map<String, dynamic> productEntryJson;

      try {
        GoldProductDbHelper().insert(goldProductJson).then(
              (value) => {
                GoldProductDbHelper().products.add(
                      GoldProduct.fromJson(goldProductJson, value),
                    ),
                productEntryJson = ProductEntry(
                  productId: value,
                  enteredDate: DateTime.now(),
                  piece: int.parse(pieceController.text),
                ).toJson(),
                ProductEntryDbHelper()
                    .insert(productEntryJson)
                    .then((value) => {
                          ProductEntryDbHelper().entries.add(
                              ProductEntry.fromJson(productEntryJson, value)),
                          onRefresh(),
                          //Navigator.of(context).pop(),
                        }),
              },
            );
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, '/gold-product-add-screen', (route) => false),
                child: const Text('Tamam'),
              ),
            ],
          ),
        );
      }
    }
  }

  void onRefresh() {
    return setState(
      () {
        barcodeNo = '0000000000000';
        pieceController.text = '';
        nameController.text = '';
        dropdownValue = Carat.twentyFour;
        purityRateController.text =
            dropdownValue.purityRateDefinition.toString();
        laborCostController.text = '';
        gramController.text = '';
        costController.text = '';
        salesGramsController.text = '';
      },
    );
  }

  bool isVariablesEmpty() {
    return pieceController.text.isEmpty ||
        nameController.text.isEmpty ||
        purityRateController.text.isEmpty ||
        laborCostController.text.isEmpty ||
        gramController.text.isEmpty ||
        salesGramsController.text.isEmpty ||
        costController.text.isEmpty;
  }

  bool isCorrectFormat() {
    return double.tryParse(purityRateController.text.replaceAll(",", ".")) ==
            null ||
        int.tryParse(pieceController.text) == null ||
        double.tryParse(laborCostController.text.replaceAll(",", ".")) ==
            null ||
        double.tryParse(gramController.text.replaceAll(",", ".")) == null ||
        double.tryParse(costController.text.replaceAll(",", ".")) == null ||
        double.tryParse(salesGramsController.text.replaceAll(",", ".")) == null;
  }

  void buildCalculate() {
    if (purityRateController.text.isNotEmpty &&
        salesGramsController.text.isNotEmpty &&
        laborCostController.text.isNotEmpty) {
      setState(() {
        double cost = Calculator.calculateCostPrice(
              double.parse(purityRateController.text.replaceAll(",", ".")),
              // salesGran vs gram
              double.parse(salesGramsController.text.replaceAll(",", ".")),
              double.parse(laborCostController.text.replaceAll(",", ".")),
            ) /
            1000;
        costController.text = OutputFormatters.buildNumberFormat3f(cost);
      });
    }
  }

  List<DropdownMenuItem<Carat>> buildDropdownMenuItemList() {
    return Carat.values.map<DropdownMenuItem<Carat>>((Carat value) {
      return DropdownMenuItem<Carat>(
        alignment: AlignmentDirectional.center,
        value: value,
        child: Text(
          value.intDefinition.toString(),
          style: TextStyles.buildTextFormFieldTextStyle(),
          textAlign: TextAlign.right,
        ),
      );
    }).toList();
  }

  EdgeInsets buildEdgeInsets() =>
      const EdgeInsets.only(left: 32.0, top: 12, bottom: 12);
}
