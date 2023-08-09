// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/calculate.dart';
import 'package:kuyumcu_stok/data/product_gold_db_helper.dart';
import 'package:kuyumcu_stok/enum_carat.dart';
import 'package:kuyumcu_stok/models/product_gold.dart';
import 'package:kuyumcu_stok/validations/number_validator.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';

class ProductGoldScreen extends StatefulWidget {
  late ProductGold product;
  ProductGoldScreen({super.key, required this.product});

  @override
  State<ProductGoldScreen> createState() => _ProductGoldScreenState(product: product);
}

class _ProductGoldScreenState extends State<ProductGoldScreen> {
  late ProductGold product;
  late TextEditingController nameController;
  late TextEditingController caratController;
  late TextEditingController gramController;
  late TextEditingController costGramController;
  late TextEditingController purityRateController;
  late TextEditingController costPriceController;
  late TextEditingController laborCostController;

  late Carat dropdownValue;

  _ProductGoldScreenState({required this.product}) {
    dropdownValue = product.carat;
    nameController = TextEditingController();
    gramController = TextEditingController();
    purityRateController = TextEditingController();
    costPriceController = TextEditingController();
    laborCostController = TextEditingController();
    nameController.text = product.name.toString();
    gramController.text = product.gram.toString();
    purityRateController.text = dropdownValue.purityRateDefinition.toString();
    costPriceController.text = product.costPrice.toString();
    laborCostController.text = product.laborCost.toString();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
          const SizedBox(
            height: 70,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32.0, top: 16, bottom: 16),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/products-screen', (route) => false);
                  },
                  child: const Text(
                    'Geri Dön',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
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
            onPressed: onUpdateFun,
            child: const Text(
              'Güncelle',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onUpdateFun() {
    if (NumberValidator.validate(gramController.text) != null ||
        NumberValidator.validate(purityRateController.text) != null ||
        NumberValidator.validate(laborCostController.text) != null ||
        NumberValidator.validate(costPriceController.text) != null) {
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
    }
    product.name = nameController.text;
    product.carat = dropdownValue;
    product.gram = double.parse(gramController.text);
    product.laborCost = double.parse(laborCostController.text);
    product.costPrice = double.parse(costPriceController.text);
    product.purityRate = double.parse(purityRateController.text);


    for(int i=0; i<ProductGoldDbHelper().products.length; i++) {
      if (ProductGoldDbHelper().products[i].id == product.id) {
        ProductGoldDbHelper().products[i] = product;
        print(product.name);
        break;
      }
    }
    ProductGoldDbHelper().update(product.toJson(), product.id).then((value) => {
      ProductGoldDbHelper().getProductById(product.id).then((value) => print(value)),
      Navigator.pushNamedAndRemoveUntil(
          context, '/products-screen', (route) => false),
    });
  }

  Padding buildNameRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, top: 16, bottom: 16),
      child: Row(
        children: [
          const Text(
            'İsim: ',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          // ToDo validatörleri unutma!!!
          TextFormField(
            controller: nameController,
            style: const TextStyle(
              fontSize: 18,
              height: 1,
            ),
            decoration: buildInputDecoration(const Size(150, 35)),
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
            const Text(
              'Karat: ',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            DropdownButtonFormField(
              alignment: Alignment.centerLeft,
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                constraints: buildBoxConstraints(const Size(100, 120)),
              ),
              items: Carat.values.map<DropdownMenuItem<Carat>>((Carat value) {
                return DropdownMenuItem<Carat>(
                  alignment: AlignmentDirectional.center,
                  value: value,
                  child: Text(
                    value.intDefinition.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.right,
                  ),
                );
              }).toList(),
              onChanged: (Carat? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                  purityRateController.text =
                      dropdownValue.purityRateDefinition.toString();
                });
                if (purityRateController.text.isNotEmpty &&
                    gramController.text.isNotEmpty &&
                    laborCostController.text.isNotEmpty) {
                  //print('girdi');
                  setState(() {
                    costPriceController.text = Calculate.calculateCostPrice(
                            double.parse(purityRateController.text),
                            double.parse(gramController.text),
                            double.parse(laborCostController.text))
                        .toStringAsFixed(0);
                  });
                }
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
          const Text(
            'Saflık Oranı: ',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          // ToDo validatörleri unutma!!!
          TextFormField(
            validator: NumberValidator.validate,
            controller: purityRateController,
            style: const TextStyle(
              fontSize: 18,
              height: 1,
            ),
            decoration: buildInputDecoration(const Size(100, 35)),
            onChanged: (value) {
              if (purityRateController.text.isNotEmpty &&
                  gramController.text.isNotEmpty &&
                  laborCostController.text.isNotEmpty) {
                //print('girdi');
                setState(() {
                  costPriceController.text = Calculate.calculateCostPrice(
                          double.parse(purityRateController.text),
                          double.parse(gramController.text),
                          double.parse(laborCostController.text))
                      .toStringAsFixed(0);
                });
              }
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
          const Text(
            'İşçilik: ',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          // ToDo validatörleri unutma!!!
          TextFormField(
            validator: NumberValidator.validate,
            controller: laborCostController,
            style: const TextStyle(
              fontSize: 18,
              height: 1,
            ),
            decoration: buildInputDecoration(const Size(100, 35)),
            onChanged: (value) {
              if (purityRateController.text.isNotEmpty &&
                  gramController.text.isNotEmpty &&
                  laborCostController.text.isNotEmpty) {
                //print('girdi');
                setState(() {
                  costPriceController.text = Calculate.calculateCostPrice(
                          double.parse(purityRateController.text),
                          double.parse(gramController.text),
                          double.parse(laborCostController.text))
                      .toStringAsFixed(0);
                });
              }
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
          const Text(
            'Gram: ',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          // ToDo validatörleri unutma!!!
          TextFormField(
            validator: NumberValidator.validate,
            controller: gramController,
            style: const TextStyle(
              fontSize: 18,
              height: 1,
            ),
            decoration: buildInputDecoration(const Size(100, 35)),
            onChanged: (value) {
              if (purityRateController.text.isNotEmpty &&
                  gramController.text.isNotEmpty &&
                  laborCostController.text.isNotEmpty) {
                //print('girdi');
                setState(() {
                  costPriceController.text = Calculate.calculateCostPrice(
                          double.parse(purityRateController.text),
                          double.parse(gramController.text),
                          double.parse(laborCostController.text))
                      .toStringAsFixed(0);
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Padding buildCostGramRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, top: 16, bottom: 16),
      child: Row(
        children: [
          const Text(
            'Gram Maliyeti: ',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          // ToDo validatörleri unutma!!!
          TextFormField(
            validator: NumberValidator.validate,
            controller: costGramController,
            style: const TextStyle(
              fontSize: 18,
              height: 1,
            ),
            decoration: buildInputDecoration(const Size(100, 35)),
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
          const Text(
            'Maliyet Fiyatı: ',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          // ToDo validatörleri unutma!!!
          TextFormField(
            validator: NumberValidator.validate,
            controller: costPriceController,
            style: const TextStyle(
              fontSize: 18,
              height: 1,
            ),
            decoration: buildInputDecoration(const Size(125, 35)),
          ),
        ],
      ),
    );
  }

  BoxConstraints buildBoxConstraints(Size size) => BoxConstraints.tight(size);

  InputDecoration buildInputDecoration(Size size) {
    return InputDecoration(
      contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 20),
      border: const OutlineInputBorder(),
      constraints: buildBoxConstraints(size),
      //hintText: '9789756249840',
    );
  }
}
