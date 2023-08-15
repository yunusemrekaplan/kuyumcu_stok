import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kuyumcu_stok/calculate.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/models/gold_product.dart';
import 'package:kuyumcu_stok/services/isbn_service.dart';
import 'package:kuyumcu_stok/validations/number_validator.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';

import '../enum_carat.dart';

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
    purityRateController.text = dropdownValue.purityRateDefinition.toString();
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
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32.0, top: 16, bottom: 16),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/gold-products-screen', (route) => false);
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

  Padding buildSaveButtonRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, top: 16, bottom: 16),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: onSavedFun,
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

  void onSavedFun() {
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
    else if (nameController.text.isEmpty) {
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
    else {
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

      Map<String, dynamic> json = GoldProduct(
        barcodeText: barcodeNo,
        name: nameController.text,
        carat: dropdownValue,
        gram: double.parse(gramController.text),
        laborCost: double.parse(laborCostController.text),
        costPrice: double.parse(costPriceController.text),
        purityRate: double.parse(purityRateController.text),
      ).toJson();

      try {
        GoldProductDbHelper().insert(json).then(
              (value) => {
                GoldProductDbHelper().products.add(
                      GoldProduct.fromJson(json, value),
                    ),
                print('id: $value'),
                setState(
                  () {
                    barcodeNo = '0000000000000';
                    nameController.text = '';
                    gramController.text = '';
                    costGramController.text = '';
                    purityRateController.text =
                        dropdownValue.purityRateDefinition.toString();
                    costPriceController.text = '';
                    laborCostController.text = '';

                    Navigator.of(context).pop();
                    //Navigator.of(context).popAndPushNamed('/gold-product-add-screen');
                  },
                ),

                /*IsbnService.generateBarcode(barcodeNo).then((value) => {
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
                        purityRateController.text = dropdownValue.purityRateDefinition.toString();
                        costPriceController.text = '';
                        laborCostController.text = '';

                        Navigator.of(context).pop();
                        //Navigator.of(context).popAndPushNamed('/gold-product-add-screen');
                      },
                    ),
                  },
                ),
              },),*/
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
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });
    }
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
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.hovered)) {
                    return Colors.green;
                  }
                  return Colors.grey;
                },
              ),
            ),
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
                color: Colors.white,
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
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
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
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
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
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
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
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
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
