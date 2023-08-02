import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/calculate.dart';
import 'package:kuyumcu_stok/services/isbn_service.dart';
import 'package:kuyumcu_stok/validations/number_validator.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';

import '../enum_carat.dart';

class ProductAddScreen extends StatefulWidget {
  const ProductAddScreen({super.key});

  @override
  State<ProductAddScreen> createState() => _ProductAddScreenState();
}
// ToDo validatörleri unutma!!!

class _ProductAddScreenState extends State<ProductAddScreen> {
  late String barcodeNo;

  late TextEditingController nameController;
  late TextEditingController caratController;
  late TextEditingController gramController;
  late TextEditingController costGramController;
  late TextEditingController purityRateController;
  late TextEditingController costPriceController;
  late TextEditingController laborCostController;

  late Carat dropdownValue;

  _ProductAddScreenState() {
    dropdownValue = Carat.twentyFour;
    barcodeNo = '0000000000000';
    nameController = TextEditingController();
    caratController = TextEditingController();
    gramController = TextEditingController();
    costGramController = TextEditingController();
    purityRateController = TextEditingController();
    costPriceController = TextEditingController();
    laborCostController = TextEditingController();
    purityRateController.text = dropdownValue.purityRateDefinition.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          buildBarcodeRow(),
          buildNameRow(),
          buildCaratRow(),
          buildPurityRateRow(),
          buildLaborCostRow(),
          buildGramRow(),
          //buildCostGramRow(),
          buildCostPriceRow(),
          buildSaveButtonRow(),
        ],
      ),
    );
  }

  Padding buildSaveButtonRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, top: 16, bottom: 16),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              if (barcodeNo == '0000000000000') {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Barkod oluşturun!'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Tamam'),
                      ),
                    ],
                  ),
                );
              }
              else {
                if (NumberValidator.validate(gramController.text) != null || NumberValidator.validate(purityRateController.text) != null || NumberValidator.validate(laborCostController.text) != null || NumberValidator.validate(costPriceController.text) != null) {
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


              }
            },
            child: const Text(
              'Kaydet',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildBarcodeRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, top: 16, bottom: 16),
      child: Row(
        children: [
          const Text(
            'Barkod No: ',
            style: TextStyle(fontSize: 22),
          ),
          SizedBox(
            width: 180,
            child: Text(
              barcodeNo,
              style: const TextStyle(
                fontSize: 22,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              barcodeNo = IsbnService.generateCode();
              setState(() {
                barcodeNo;
              });
            },
            child: const Text(
              'Barkod Oluştur',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          )
        ],
      ),
    );
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
                  print('girdi');
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
                print('girdi');
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
                print('girdi');
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
                print('girdi');
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
