// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/calculate.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/enum_carat.dart';
import 'package:kuyumcu_stok/models/gold_product.dart';
import 'package:kuyumcu_stok/validations/number_validator.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';
import 'package:kuyumcu_stok/widgets/styles/button_styles.dart';
import 'package:kuyumcu_stok/widgets/styles/decoration_styles.dart';
import 'package:kuyumcu_stok/widgets/styles/text_styles.dart';

class GoldProductEditScreen extends StatefulWidget {
  late GoldProduct product;
  GoldProductEditScreen({super.key, required this.product});

  @override
  State<GoldProductEditScreen> createState() =>
      _GoldProductEditScreenState(product: product);
}

class _GoldProductEditScreenState extends State<GoldProductEditScreen> {
  late GoldProduct product;
  late TextEditingController nameController;
  late TextEditingController caratController;
  late TextEditingController gramController;
  late TextEditingController purityRateController;
  late TextEditingController costPriceController;
  late TextEditingController laborCostController;

  late Carat dropdownValue;

  _GoldProductEditScreenState({required this.product}) {
    dropdownValue = product.carat;
    nameController = TextEditingController();
    gramController = TextEditingController();
    purityRateController = TextEditingController();
    costPriceController = TextEditingController();
    laborCostController = TextEditingController();
    nameController.text = product.name.toString();
    gramController.text = product.gram.toString();
    purityRateController.text = dropdownValue.purityRateDefinition.toString();
    costPriceController.text = product.cost.toString();
    laborCostController.text = product.laborCost.toString();
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
          buildCostPriceRow(),
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
            decoration: DecorationStyles.buildInputDecoration(
                const Size(150, 38)),
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
              decoration: InputDecoration(
                constraints: DecorationStyles.buildBoxConstraints(
                    const Size(100, 38)),
                contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 3),
              ),
              items: buildDropdownMenuItemList(),
              onChanged: (Carat? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                  purityRateController.text =
                      dropdownValue.purityRateDefinition.toString();
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
          // ToDo validatörleri unutma!!!
          TextFormField(
            validator: NumberValidator.validate,
            controller: purityRateController,
            style: TextStyles.buildTextFormFieldTextStyle(),
            decoration: DecorationStyles.buildInputDecoration(
                const Size(100, 38)),
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
            decoration: DecorationStyles.buildInputDecoration(
                const Size(100, 38)),
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
            decoration: DecorationStyles.buildInputDecoration(
                const Size(100, 38)),
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

  Padding buildCostPriceRow() {
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
            controller: costPriceController,
            style: TextStyles.buildTextFormFieldTextStyle(),
            decoration: DecorationStyles.buildInputDecoration(
                const Size(125, 38)),
            onChanged: (value) {
              setState(() {
                costPriceController;
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
            style: ButtonStyles.buildUpdateButtonStyle(isUpdatetable()),
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

  void buildCalculate() {
    if (purityRateController.text.isNotEmpty &&
        gramController.text.isNotEmpty &&
        laborCostController.text.isNotEmpty) {
      setState(() {
        costPriceController.text = Calculate.calculateCostPrice(
            double.parse(purityRateController.text),
            double.parse(gramController.text),
            double.parse(laborCostController.text))
            .toStringAsFixed(0);
      });
    }
  }

  void onUpdateFun() {
    if (isUpdatetable() == 0) {
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
    } else if (isUpdatetable() == 1) {
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
      product.gram = double.parse(gramController.text);
      product.laborCost = double.parse(laborCostController.text);
      product.cost = double.parse(costPriceController.text);
      product.purityRate = double.parse(purityRateController.text);

      for (int i = 0; i < GoldProductDbHelper().products.length; i++) {
        if (GoldProductDbHelper().products[i].id == product.id) {
          GoldProductDbHelper().products[i] = product;
          print(product.name);
          break;
        }
      }
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

  int isUpdatetable() {
    if (nameController.text.isEmpty ||
        purityRateController.text.isEmpty ||
        laborCostController.text.isEmpty ||
        gramController.text.isEmpty ||
        costPriceController.text.isEmpty) {
      return 0;
    }
    if (double.tryParse(purityRateController.text) == null ||
        double.tryParse(laborCostController.text) == null ||
        double.tryParse(gramController.text) == null ||
        double.tryParse(costPriceController.text) == null) {
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
