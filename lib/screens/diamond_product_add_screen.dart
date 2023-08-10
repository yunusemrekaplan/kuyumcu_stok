import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kuyumcu_stok/data/diamond_product_db_helper.dart';
import 'package:kuyumcu_stok/models/diamond_product.dart';
import 'package:kuyumcu_stok/validations/number_validator.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';

class DiamondProductAddScreen extends StatefulWidget {
  const DiamondProductAddScreen({super.key});

  @override
  State<DiamondProductAddScreen> createState() =>
      _DiamondProductAddScreenState();
}

class _DiamondProductAddScreenState extends State<DiamondProductAddScreen> {
  late TextEditingController barcodeController;
  late TextEditingController nameController;
  late TextEditingController gramController;
  late TextEditingController priceController;

  _DiamondProductAddScreenState() {
    barcodeController = TextEditingController();
    nameController = TextEditingController();
    gramController = TextEditingController();
    priceController = TextEditingController();
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
          buildGramRow(),
          buildPriceRow(),
          buildSaveButtonRow(),
          const SizedBox(
            height: 200,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 32.0, top: 16, bottom: 16),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context,
                          '/diamond-products-screen', (route) => false);
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
            child: TextFormField(
              controller: barcodeController,
              style: const TextStyle(
                fontSize: 18,
                height: 1,
              ),
              decoration: buildInputDecoration(const Size(150, 35)),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
          ),
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
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
        ],
      ),
    );
  }

  Padding buildPriceRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, top: 16, bottom: 16),
      child: Row(
        children: [
          const Text(
            'Fiyat: ',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          // ToDo validatörleri unutma!!!
          TextFormField(
            validator: NumberValidator.validate,
            controller: priceController,
            style: const TextStyle(
              fontSize: 18,
              height: 1,
            ),
            decoration: buildInputDecoration(const Size(100, 35)),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
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
            onPressed: onSaved,
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

  void onSaved() {
    if (barcodeController.text.length != 13) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Doğru formatta barkod kodu girin!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    } else {
      if (gramController.text.isEmpty || priceController.text.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Boşlukları doldurun!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Tamam'),
              ),
            ],
          ),
        );
      } else {
        DiamondProduct product = DiamondProduct(
            barcodeText: barcodeController.text,
            name: nameController.text,
            gram: double.parse(gramController.text),
            price: double.parse(priceController.text));

        DiamondProductDbHelper().insert(product.toJson()).then(
              (value) => {
                product.id = value,
                DiamondProductDbHelper().products.add(product),
                Navigator.of(context).pop(),
              },
            );
      }
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        },
      );
    }
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
