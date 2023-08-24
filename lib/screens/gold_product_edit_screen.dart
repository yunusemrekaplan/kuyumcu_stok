// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kuyumcu_stok/calculate.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/enum_carat.dart';
import 'package:kuyumcu_stok/localizations/input_formatters.dart';
import 'package:kuyumcu_stok/models/gold_product.dart';
import 'package:kuyumcu_stok/styles/button_styles.dart';
import 'package:kuyumcu_stok/styles/decoration_styles.dart';
import 'package:kuyumcu_stok/styles/text_styles.dart';
import 'package:kuyumcu_stok/validations/number_validator.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';

class GoldProductEditScreen extends StatefulWidget {
  late GoldProduct product;
  GoldProductEditScreen({super.key, required this.product});

  @override
  State<GoldProductEditScreen> createState() =>
      _GoldProductEditScreenState(product: product);
}

class _GoldProductEditScreenState extends State<GoldProductEditScreen> {
  late GoldProduct product;
  late Carat dropdownValue;
  late TextEditingController nameController;
  late TextEditingController caratController;
  late TextEditingController gramController;
  late TextEditingController purityRateController;
  late TextEditingController costController;
  late TextEditingController laborCostController;

  _GoldProductEditScreenState({required this.product}) {
    dropdownValue = product.carat;
    nameController = TextEditingController();
    gramController = TextEditingController();
    purityRateController = TextEditingController();
    costController = TextEditingController();
    laborCostController = TextEditingController();
    String text1 = dropdownValue.purityRateDefinition.toString();
    String text2 = product.laborCost.toString();
    String text3 = product.gram.toString();
    String text4 = product.cost.toString();
    nameController.text = product.name.toString();
    purityRateController.text = text1.replaceAll(".", ",");
    laborCostController.text = text2.replaceAll(".", ",");
    gramController.text = text3.replaceAll(".", ",");
    costController.text = text4.replaceAll(".", ",");
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
          buildNameRow(),
          buildCaratRow(),
          buildPurityRateRow(),
          buildLaborCostRow(),
          buildGramRow(),
          buildCostRow(),
          buildUpdateButtonRow(),
          const Expanded(
            child: SizedBox(),
          ),
          buildBackButton(),
        ],
      ),
    );
  }

  Padding buildNameRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, top: 16, bottom: 16),
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
      padding: const EdgeInsets.only(left: 32.0, top: 16, bottom: 16),
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
      padding: const EdgeInsets.only(left: 32.0, top: 16, bottom: 16),
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
              InputFormatters.inputOnlyDigits(),
              /*TextInputFormatter.withFunction((oldValue, newValue) {
                if (newValue.text.isEmpty) {
                  return newValue.copyWith(text: '');
                } else {
                  final n = NumberFormat('#,##0.0', 'tr_TR');
                  final number = n.parse(newValue.text);
                  return newValue.copyWith(
                      text: n.format(number), selection: updateCursorPosition(newValue));
                }
              })*/
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

  /*TextSelection updateCursorPosition(TextEditingValue value) {
    final int offset = value.text.length;
    return TextSelection.fromPosition(TextPosition(offset: offset));
  }*/

  Padding buildLaborCostRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, top: 16, bottom: 16),
      child: Row(
        children: [
          Text(
            'İşçilik: ',
            style: TextStyles.buildTextStyle(),
          ),
          TextFormField(
            validator: NumberValidator.validate,
            controller: laborCostController,
            style: TextStyles.buildTextFormFieldTextStyle(),
            decoration:
                DecorationStyles.buildInputDecoration(const Size(100, 38)),
            inputFormatters: <TextInputFormatter>[
              InputFormatters.inputOnlyDigits(),
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
      padding: const EdgeInsets.only(left: 32.0, top: 16, bottom: 16),
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
              InputFormatters.inputOnlyDigits(),
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
      padding: const EdgeInsets.only(left: 32.0, top: 16, bottom: 16),
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
              InputFormatters.inputOnlyDigits(),
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

  Padding buildUpdateButtonRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, top: 16, bottom: 16),
      child: Row(
        children: [
          ElevatedButton(
            style: ButtonStyles.buildUpdateButtonStyle(isUpdatable()),
            onPressed: onUpdateFun,
            child: Text(
              'Güncelle',
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
            style: ButtonStyles.buildBackButtonStyle(),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context,
                  '/gold-products-inventory-screen', (route) => false);
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

  void buildCalculate() {
    if (purityRateController.text.isNotEmpty &&
        gramController.text.isNotEmpty &&
        laborCostController.text.isNotEmpty) {
      setState(() {
        costController.text = Calculate.calculateCostPrice(
          double.parse(purityRateController.text.replaceAll(",", ".")),
          double.parse(gramController.text.replaceAll(",", ".")),
          double.parse(laborCostController.text.replaceAll(",", ".")),
        ).toStringAsFixed(0);
      });
    }
  }

  void onUpdateFun() {
    if (isUpdatable() == 0) {
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
    } else if (isUpdatable() == 1) {
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
      product.name = nameController.text;
      product.carat = dropdownValue;
      product.gram = double.parse(gramController.text.replaceAll(',', '.'));
      product.laborCost =
          double.parse(laborCostController.text.replaceAll(',', '.'));
      product.cost =
          double.parse(costController.text.replaceAll(',', '.'));
      product.purityRate =
          double.parse(purityRateController.text.replaceAll(',', '.'));


      GoldProductDbHelper()
          .update(product.toJson(), product.id)
          .then((value) => {
                GoldProductDbHelper()
                    .getProductById(product.id)
                    .then((value) => print(value)),
                Navigator.pushNamedAndRemoveUntil(context,
                    '/gold-products-inventory-screen', (route) => false),
              });
    }
  }

  int isUpdatable() {
    if (nameController.text.isEmpty ||
        purityRateController.text.isEmpty ||
        laborCostController.text.isEmpty ||
        gramController.text.isEmpty ||
        costController.text.isEmpty) {
      return 0;
    }
    if (double.tryParse(purityRateController.text.replaceAll(",", ".")) ==
            null ||
        double.tryParse(laborCostController.text.replaceAll(",", ".")) ==
            null ||
        double.tryParse(gramController.text.replaceAll(",", ".")) == null ||
        double.tryParse(costController.text.replaceAll(",", ".")) ==
            null) {
      return 1;
    }
    return 2;
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
}
