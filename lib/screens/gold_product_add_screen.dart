import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kuyumcu_stok/calculate.dart';
import 'package:kuyumcu_stok/data/barcode_db_helper.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/enum_carat.dart';
import 'package:kuyumcu_stok/models/barcode.dart';
import 'package:kuyumcu_stok/models/gold_product.dart';
import 'package:kuyumcu_stok/services/barcode_service.dart';
import 'package:kuyumcu_stok/validations/number_validator.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';
import 'package:kuyumcu_stok/widgets/styles/button_styles.dart';
import 'package:kuyumcu_stok/widgets/styles/decoration_styles.dart';

class GoldProductAddScreen extends StatefulWidget {
  const GoldProductAddScreen({super.key});

  @override
  State<GoldProductAddScreen> createState() => _GoldProductAddScreenState();
}
// ToDo validatörleri unutma!!!

class _GoldProductAddScreenState extends State<GoldProductAddScreen> {
  late String barcodeNo;

  late TextEditingController nameController;
  late TextEditingController gramController;
  late TextEditingController costGramController;
  late TextEditingController purityRateController;
  late TextEditingController costPriceController;
  late TextEditingController laborCostController;

  late Carat dropdownValue;

  _GoldProductAddScreenState() {
    dropdownValue = Carat.twentyFour;
    barcodeNo = '0000000000000';
    nameController = TextEditingController();
    gramController = TextEditingController();
    costGramController = TextEditingController();
    purityRateController = TextEditingController();
    costPriceController = TextEditingController();
    laborCostController = TextEditingController();
    purityRateController.text =
        dropdownValue.purityRateDefinition.toStringAsFixed(0);
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
          buildNameRow(),
          buildCaratRow(),
          buildPurityRateRow(),
          buildLaborCostRow(),
          buildGramRow(),
          buildCostPriceRow(),
          buildSaveButtonRow(),
          const Expanded(
            child: SizedBox(
              height: 10,
            ),
          ),
          buildBackButtonRow(),
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
          buildBarcodeGeneratorButton()
        ],
      ),
    );
  }

  ElevatedButton buildBarcodeGeneratorButton() {
    return ElevatedButton(
      style: ButtonStyleWidgets.buildBackButtonStyle(),
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
            decoration: DecorationStyleWidgets.buildInputDecoration(
                const Size(150, 35)),
            onChanged: (value) {
              setState(() {});
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
                constraints: DecorationStyleWidgets.buildBoxConstraints(
                    const Size(100, 120)),
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
                      dropdownValue.purityRateDefinition.toStringAsFixed(0);
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
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: DecorationStyleWidgets.buildInputDecoration(
                const Size(100, 35)),
            onChanged: (value) {
              setState(() {});
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
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: DecorationStyleWidgets.buildInputDecoration(
                const Size(100, 35)),
            onChanged: (value) {
              setState(() {});
              if (purityRateController.text.isNotEmpty &&
                  gramController.text.isNotEmpty &&
                  laborCostController.text.isNotEmpty) {
                print('girdi');
                setState(() {
                  costPriceController.text = Calculate.calculateCostPrice(
                    double.parse(purityRateController.text),
                    double.parse(gramController.text),
                    double.parse(laborCostController.text),
                  ).toStringAsFixed(0);
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
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: DecorationStyleWidgets.buildInputDecoration(
                const Size(100, 35)),
            onChanged: (value) {
              setState(() {});
              if (purityRateController.text.isNotEmpty &&
                  gramController.text.isNotEmpty &&
                  laborCostController.text.isNotEmpty) {
                print('girdi');
                setState(() {
                  costPriceController.text = Calculate.calculateCostPrice(
                    double.parse(purityRateController.text),
                    double.parse(gramController.text),
                    double.parse(laborCostController.text),
                  ).toStringAsFixed(0);
                });
              }
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
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: DecorationStyleWidgets.buildInputDecoration(
                const Size(125, 35)),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Padding buildBackButtonRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, top: 16, bottom: 16),
      child: Row(
        children: [
          ElevatedButton(
            style: ButtonStyleWidgets.buildBackButtonStyle(),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/gold-products-inventory-screen', (route) => false);
            },
            child: const Text(
              'Geri Dön',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
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
            style: ButtonStyleWidgets.buildSaveButtonStyle(
              barcodeNo,
              nameController.text,
              purityRateController.text,
              laborCostController.text,
              gramController.text,
              costPriceController.text,
            ),
            onPressed: onSavedFun,
            child: const Text(
              'Kaydet',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onSavedFun() async {
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
    } else if (nameController.text.isEmpty ||
        NumberValidator.validate(gramController.text) != null ||
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
    } else {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });

      Map<String, dynamic> json = GoldProduct(
        isSold: 0,
        enteredDate: DateTime.now(),
        barcodeText: barcodeNo,
        name: nameController.text,
        carat: dropdownValue,
        gram: double.parse(gramController.text),
        laborCost: double.parse(laborCostController.text),
        cost: double.parse(costPriceController.text),
        purityRate: double.parse(purityRateController.text),
      ).toJson();
      Barcode barcode;

      try {
        await GoldProductDbHelper().insert(json).then(
              (value) => {
                GoldProductDbHelper().products.add(
                      GoldProduct.fromJson(json, value),
                    ),
                print('id: $value'),
                BarcodeService.generateBarcode(barcodeNo).then(
                  (value) => {
                    barcode = value,
                    BarcodeDbHelper().insert(barcode.toJson()).then(
                          (value) => {
                            print(barcode.toJson()),
                            setState(
                              () {
                                barcodeNo = '0000000000000';
                                nameController.text = '';
                                gramController.text = '';
                                costGramController.text = '';
                                purityRateController.text = dropdownValue
                                    .purityRateDefinition
                                    .toStringAsFixed(0);
                                costPriceController.text = '';
                                laborCostController.text = '';

                                Navigator.of(context).pop();
                              },
                            ),
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
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Tamam'),
              ),
            ],
          ),
        );
      }
    }
  }
}
