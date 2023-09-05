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
import 'package:kuyumcu_stok/styles/decoration_styles.dart';
import 'package:kuyumcu_stok/styles/text_styles.dart';
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
      body: Column(
        children: [
          buildBarcodeRow(),
          buildPieceRow(),
          buildNameRow(),
          buildCaratRow(),
          buildPurityRateRow(),
          buildLaborCostRow(),
          buildGramRow(),
          buildSalesGramsRow(),
          buildCostRow(),
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
      style: buttonStyles.buildBasicButtonStyle(),
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
              inputFormatOnlyDigits,
            ],
            onChanged: (value) {
              setState(() {
                pieceController;
                buttonStyles;
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
                buttonStyles;
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
              inputFormatDouble,
            ],
            onChanged: (value) {
              setState(() {
                gramController;
                buttonStyles;
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
