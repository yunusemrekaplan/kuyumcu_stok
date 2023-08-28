import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kuyumcu_stok/calculate.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/data/product_entry_db_helper.dart';
import 'package:kuyumcu_stok/enum_carat.dart';
import 'package:kuyumcu_stok/localizations/input_formatters.dart';
import 'package:kuyumcu_stok/models/gold_product.dart';
import 'package:kuyumcu_stok/models/product_entry.dart';
import 'package:kuyumcu_stok/services/barcode_service.dart';
import 'package:kuyumcu_stok/styles/button_styles.dart';
import 'package:kuyumcu_stok/styles/decoration_styles.dart';
import 'package:kuyumcu_stok/styles/text_styles.dart';
import 'package:kuyumcu_stok/validations/number_validator.dart';
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
  late TextEditingController gramController;
  late TextEditingController costGramController;
  late TextEditingController purityRateController;
  late TextEditingController costController;
  late TextEditingController laborCostController;
  late TextEditingController salesGramsController;

  _GoldProductAddScreenState() {
    initializeDateFormatting('tr_TR', null);
    dropdownValue = Carat.twentyFour;
    barcodeNo = '0000000000000';
    pieceController = TextEditingController();
    nameController = TextEditingController();
    gramController = TextEditingController();
    costGramController = TextEditingController();
    purityRateController = TextEditingController();
    costController = TextEditingController();
    laborCostController = TextEditingController();
    salesGramsController = TextEditingController();
    String text1 = dropdownValue.purityRateDefinition.toString();
    purityRateController.text = text1.replaceAll(".", ",");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          buildBarcodeRow(),
          buildPieceRow(),
          buildNameRow(),
          buildCaratRow(),
          buildPurityRateRow(),
          buildLaborCostRow(),
          buildGramRow(),
          buildCostRow(),
          buildSalesGramsRow(),
          buildSaveButton(),
          const Expanded(
            child: SizedBox(
              height: 10,
            ),
          ),
          buildBackButton(),
        ],
      ),
    );
  }

  Padding buildBarcodeRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, top: 0, bottom: 12),
      child: Row(
        children: [
          Container(
            height: 50,
            alignment: Alignment.center,
            child: Text(
              'Barkod No: ',
              style: TextStyles.buildTextStyle(),
            ),
          ),
          Container(
            width: 180,
            height: 40,
            alignment: Alignment.bottomCenter,
            child: Text(
              barcodeNo,
              style: const TextStyle(
                fontSize: 24,
                //decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          buildBarcodeGeneratorButton(),
        ],
      ),
    );
  }

  ElevatedButton buildBarcodeGeneratorButton() {
    return ElevatedButton(
      style: ButtonStyles.buildBasicButtonStyle(),
      onPressed: () {
        barcodeNo = BarcodeService.generateCode();
        setState(() {
          barcodeNo;
        });
      },
      child: const Text(
        'Barkod Oluştur',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  Padding buildPieceRow() {
    return Padding(
      padding: buildEdgeInsets(),
      child: Row(
        children: [
          Text(
            'Adet: ',
            style: TextStyles.buildTextStyle(),
          ),
          TextFormField(
            controller: pieceController,
            style: TextStyles.buildTextFormFieldTextStyle(),
            decoration:
                DecorationStyles.buildInputDecoration(const Size(150, 38)),
            inputFormatters: <TextInputFormatter>[
              InputFormatters.inputOnlyDigits(),
            ],
            onChanged: (value) {
              setState(() {
                pieceController;
              });
            },
          ),
        ],
      ),
    );
  }

  Padding buildNameRow() {
    return Padding(
      padding: buildEdgeInsets(),
      child: Row(
        children: [
          Text(
            'İsim: ',
            style: TextStyles.buildTextStyle(),
          ),
          TextFormField(
            controller: nameController,
            style: TextStyles.buildTextFormFieldTextStyle(),
            decoration:
                DecorationStyles.buildInputDecoration(const Size(150, 38)),
            onChanged: (value) {
              setState(() {
                nameController;
              });
            },
          ),
        ],
      ),
    );
  }

  Padding buildCaratRow() {
    return Padding(
      padding: buildEdgeInsets(),
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            Text(
              'Karat: ',
              style: TextStyles.buildTextStyle(),
            ),
            DropdownButtonFormField(
              alignment: Alignment.centerLeft,
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              decoration: DecorationStyles.buildDropdownButtonInputDecoration(),
              items: buildDropdownMenuItemList(),
              onChanged: (Carat? newValue) {
                dropdownValue = newValue!;
                String temp = dropdownValue.purityRateDefinition.toString();
                setState(() {
                  purityRateController.text = temp.replaceAll('.', ',');
                });
                buildCalculate();
              },
            ),
          ],
        ),
      ),
    );
  }

  Padding buildPurityRateRow() {
    return Padding(
      padding: buildEdgeInsets(),
      child: Row(
        children: [
          Text(
            'Saflık Oranı: ',
            style: TextStyles.buildTextStyle(),
          ),
          TextFormField(
            validator: NumberValidator.validate,
            controller: purityRateController,
            style: TextStyles.buildTextFormFieldTextStyle(),
            decoration:
                DecorationStyles.buildInputDecoration(const Size(100, 38)),
            inputFormatters: <TextInputFormatter>[
              InputFormatters.inputDouble(),
            ],
            onChanged: (value) {
              setState(() {
                purityRateController;
              });
              buildCalculate();
            },
          ),
        ],
      ),
    );
  }

  Padding buildLaborCostRow() {
    return Padding(
      padding: buildEdgeInsets(),
      child: Row(
        children: [
          Text(
            'Milyem: ',
            style: TextStyles.buildTextStyle(),
          ),
          TextFormField(
            validator: NumberValidator.validate,
            controller: laborCostController,
            style: TextStyles.buildTextFormFieldTextStyle(),
            decoration:
                DecorationStyles.buildInputDecoration(const Size(100, 38)),
            inputFormatters: <TextInputFormatter>[
              InputFormatters.inputDouble(),
            ],
            onChanged: (value) {
              setState(() {
                laborCostController;
              });
              buildCalculate();
            },
          ),
        ],
      ),
    );
  }

  Padding buildGramRow() {
    return Padding(
      padding: buildEdgeInsets(),
      child: Row(
        children: [
          Text(
            'Gram: ',
            style: TextStyles.buildTextStyle(),
          ),
          TextFormField(
            validator: NumberValidator.validate,
            controller: gramController,
            style: TextStyles.buildTextFormFieldTextStyle(),
            decoration:
                DecorationStyles.buildInputDecoration(const Size(100, 38)),
            inputFormatters: <TextInputFormatter>[
              InputFormatters.inputDouble(),
            ],
            onChanged: (value) {
              setState(() {
                gramController;
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
              InputFormatters.inputDouble(),
            ],
            onChanged: (value) {
              setState(() {
                costController;
              });
            },
          ),
        ],
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
              InputFormatters.inputDouble(),
            ],
            onChanged: (value) {
              setState(() {
                costController;
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
            style: ButtonStyles.buildSaveButtonStyle((isVariablesEmpty() ||
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
            style: ButtonStyles.buildBasicButtonStyle(),
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

      /*Barcode barcode;

      try {
        GoldProductDbHelper().insert(json).then(
              (value) => {
                GoldProductDbHelper().products.add(
                      GoldProduct.fromJson(json, value),
                    ),
                print('id: $value'),
                BarcodeService.generateBarcode(barcodeNo).then(
                  (value) => {
                    barcode = value,
                    BarcodeDbHelper().insert(barcode.toJson()),
                    setState(
                      () {
                        barcodeNo = '0000000000000';
                        nameController.text = '';
                        gramController.text = '';
                        costGramController.text = '';
                        purityRateController.text = dropdownValue
                            .purityRateDefinition
                            .toStringAsFixed(0);
                        laborCostController.text = '';

                        Navigator.of(context).pop();
                      },
                    ),
                  },
                ),
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
*/
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
        costController.text.isEmpty ||
        salesGramsController.text.isEmpty;
  }

  bool isCorrectFormat() {
    return double.tryParse(purityRateController.text.replaceAll(",", ".")) ==
            null ||
        double.tryParse(pieceController.text.replaceAll(",", ".")) == null ||
        double.tryParse(laborCostController.text.replaceAll(",", ".")) ==
            null ||
        double.tryParse(gramController.text.replaceAll(",", ".")) == null ||
        double.tryParse(costController.text.replaceAll(",", ".")) == null ||
        double.tryParse(salesGramsController.text.replaceAll(",", ".")) == null;
  }

  void buildCalculate() {
    if (purityRateController.text.isNotEmpty &&
        gramController.text.isNotEmpty &&
        laborCostController.text.isNotEmpty) {
      setState(() {
        costController.text =
            NumberFormat('#,##0', 'tr_TR').format(Calculate.calculateCostPrice(
          double.parse(purityRateController.text.replaceAll(",", ".")),
          double.parse(gramController.text.replaceAll(",", ".")),
          double.parse(laborCostController.text.replaceAll(",", ".")),
        ));
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
