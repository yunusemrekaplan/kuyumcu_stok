// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kuyumcu_stok/data/diamond_product_db_helper.dart';
import 'package:kuyumcu_stok/model/diamond_product.dart';
import 'package:kuyumcu_stok/validations/number_validator.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';

class DiamondProductEditScreen extends StatefulWidget {
  late DiamondProduct product;
  DiamondProductEditScreen({super.key, required this.product});

  @override
  State<DiamondProductEditScreen> createState() => _DiamondProductEditScreenState(product: product);
}

class _DiamondProductEditScreenState extends State<DiamondProductEditScreen> {
  late DiamondProduct product;
  late TextEditingController nameController;
  late TextEditingController gramController;
  late TextEditingController priceController;

  _DiamondProductEditScreenState({required this.product}) {
    print(product.id);
    print(product.toJson());
    nameController = TextEditingController();
    gramController = TextEditingController();
    priceController = TextEditingController();

    nameController.text = product.name;
    gramController.text = product.gram.toString();
    priceController.text = product.price.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          buildNameRow(),
          buildGramRow(),
          buildPriceRow(),
          buildUpdateButtonRow(),
          const Expanded(
            child: SizedBox(),
          ),
          buildBackButton(context),
        ],
      ),
    );
  }

  Padding buildBackButton(BuildContext context) {
    return Padding(
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

  Padding buildUpdateButtonRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, top: 16, bottom: 16),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: onUpdate,
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

  void onUpdate() {
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
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      product.name = nameController.text;
      product.gram = double.parse(gramController.text);
      product.price = double.parse(priceController.text);

      for(int i=0; i<DiamondProductDbHelper().products.length; i++) {
        if (DiamondProductDbHelper().products[i].id == product.id) {
          DiamondProductDbHelper().products[i] = product;
          print(product.name);
          break;
        }
      }
      DiamondProductDbHelper().update(product.toJson(), product.id).then((value) => {
        DiamondProductDbHelper().getProductById(product.id).then((value) => print(value)),
        Navigator.pushNamedAndRemoveUntil(
            context, '/diamond-products-screen', (route) => false),
      });
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
